params.fastq="data/*.fastq.gz"
params.qc_report="results/fastqc-before-trim"
params.trimmed_fastq="results/trimmed_fastq"
params.qc_report_after_trim="results/fastqc-after-trim"



process QC {

publishDir("${params.qc_report}", mode: 'copy')

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

    publishDir("${params.trimmed_fastq}", mode: 'copy')

    input:
    path fastq

    output:
    path "*"

    script:
    """
    cutadapt -q 20 -m 30 --trim-n -o ${fastq.baseName}_trimmed.fastq.gz $fastq
    """
}


process QC_AFTER_TRIM {

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
    QC(fastq_ch)
    QC.out.view()

    trimmed_fastq_ch = TRIM(fastq_ch)
    QC_AFTER_TRIM(trimmed_fastq_ch)
    QC_AFTER_TRIM.out.view()
}


