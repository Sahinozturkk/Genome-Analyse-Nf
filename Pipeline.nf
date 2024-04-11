nextflow.enable.dsl=2

params.fastq="/home/ozturksahin/nextflow/fastq/*.fastq.gz"

params.qc_report="/home/ozturksahin/nextflow/fastqc_report"



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
