nextflow.enable.dsl = 2

params.fastq = "data/*.fastq.gz"
params.qc_report = "results/fastqc-before-trim"
params.trimmed_fastq = "results/trimmed_fastq"
params.qc_report_after_trim = "results/fastqc-after-trim"
params.threads = "4"
params.adapter_1 = "AGATCGGAAGAG" // Opisyonel / Optional
params.adapter_2 = "AGATCGGAAGAG" // Opisyonel / Optional
params.quality = "20" // Opisyonel / Optional
params.min_length = "30" // Opisyonel / Optional

process QC {
    conda 'bioinfo.yaml'  // Araçları Conda'da yükler / Installs tools in Conda

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
    conda 'bioinfo.yaml'  // Araçları Conda'da yükler / Installs tools in Conda

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
   conda 'bioinfo.yaml'  // Araçları Conda'da yükler / Installs tools in Conda

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

workflow {
    fastq_ch = Channel.fromPath(params.fastq)

    qc_results = QC(fastq_ch)
    qc_results.view()

    trimmed_fastq_ch = TRIM(fastq_ch)

    qc_after_trim_results = QC_AFTER_TRIM(trimmed_fastq_ch)
    qc_after_trim_results.view()
}

