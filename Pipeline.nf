nextflow.enable.dsl=2

params.fastq="data/*.fastq.gz"
params.qc_report="results/fastqc-before-trim"

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

workflow {

fastq_ch=Channel.fromPath(params.fastq)
QC(fastq_ch)
QC.out.view()





}
