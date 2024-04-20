nextflow.enable.dsl=2

params.fastq="/*.fastq.gz"

params.qc_report="/fastqc_before_trim"



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
