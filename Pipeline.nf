nextflow.enable.dsl = 2

params.fastq = "data/*.fastq.gz"
params.qc_report = "results/fastqc-before-trim"
params.trimmed_fastq = "results/trimmed_fastq"
params.qc_report_after_trim = "results/fastqc-after-trim"

process QC {
    conda 'fastqc'  // FastQC'yi Conda'da yükler

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
    conda 'cutadapt'  // Cutadapt'ı Conda'da yükler

    publishDir "${params.trimmed_fastq}", mode: 'copy'

    input:
    path fastq

    output:
    path "${fastq.baseName}_trimmed.fastq.gz"

    script:
    """
    cutadapt -q 20 -m 30 --trim-n -j ${4}  -o ${fastq.baseName}_trimmed.fastq.gz $fastq
    """
}

process QC_AFTER_TRIM {
    conda 'fastqc'  // FastQC'yi Conda'da yükler

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

