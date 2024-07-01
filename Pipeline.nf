nextflow.enable.dsl = 2

params.fastq = "data/raw/pe/*.fastq.gz"
params.qc_report = "results/raw/pe/"
params.trimmed_fastq = "results/processed/pe/"
params.qc_report_after_trim = "results/processed/pe"
params.threads = "4"
params.adapter_1 = "AGATCGGAAGAG" // Opisyonel / Optional
params.adapter_2 = "AGATCGGAAGAG" // Opisyonel / Optional
params.quality = "20" // Opisyonel / Optional
params.min_length = "30" // Opisyonel / Optional
params.reference_genome = "reference/ref/*.fna"
params.mapped_bam = "results/alignment"

process QC {
    conda 'envs/bioinfo.yaml'  // Araçları Conda'da yükler / Installs tools in Conda

    publishDir "${params.qc_report}", mode: 'copy'

    input:
    path fastq

    output:
    path "*"

    script:
    """
    fastqc $fastq
    """
}

process TRIM {
    conda 'envs/bioinfo.yaml'  // Araçları Conda'da yükler / Installs tools in Conda

    publishDir "${params.trimmed_fastq}", mode: 'copy'

    input:
    path fastq

    output:
    path "${fastq.baseName}_trimmed.fastq.gz"

    script:
    """
    cutadapt -q ${params.quality} -m ${params.min_length} --trim-n -a ${params.adapter_1} -a ${params.adapter_2} -j ${params.threads} -o ${fastq.baseName}_trimmed.fastq.gz $fastq
    """
}

process QC_AFTER_TRIM {
   conda 'envs/bioinfo.yaml'  // Araçları Conda'da yükler / Installs tools in Conda

    publishDir("${params.qc_report_after_trim}", mode: 'copy')

    input:
    path trimmed_fastq

    output:
    path "*"

    script:
    """
    fastqc $trimmed_fastq
    """
}

process BWA_INDEX {
    conda 'envs/bioinfo.yaml'
    input:
    path reference_genome
    output:
    path "*"
    script:
    """
    bwa index $reference_genome
    """
}

process BWA_MEM {
    conda 'envs/bioinfo.yaml'
    publishDir "${params.mapped_bam}", mode: 'copy'
    input:
    tuple val(reference_genome), path(trimmed_fastq)
    output:
    path "${trimmed_fastq.baseName}.bam"
    script:
    """
    bwa mem -t ${params.threads} $reference_genome $trimmed_fastq | \\
    samtools view -Sb - | \\
    samtools sort -o ${trimmed_fastq.baseName}.bam
    samtools index ${trimmed_fastq.baseName}.bam
    """
}



workflow {
    fastq_ch = Channel.fromPath(params.fastq)

    qc_results = QC(fastq_ch)
    qc_results.view()

    trimmed_fastq_ch = TRIM(fastq_ch)

    qc_after_trim_results = QC_AFTER_TRIM(trimmed_fastq_ch)
    qc_after_trim_results.view()

    reference_genome_ch = Channel.fromPath(params.reference_genome)
    BWA_INDEX(reference_genome_ch)

    mapped_bam_ch = trimmed_fastq_ch.map { trimmed_fastq -> tuple(params.reference_genome, trimmed_fastq) }
    BWA_MEM(mapped_bam_ch).view()

}

