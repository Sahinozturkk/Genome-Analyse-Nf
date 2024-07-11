
# Nextflow Betiği ile Genom Analizi / Genome Analaysis With Nf Script

## Giriş / Introduction

Bu Nextflow pipeline'ı, ham FASTQ verilerini işlemek için tasarlanmış bir dizi biyoinformatik analiz adımını içerir. Bu pipeline'ın amacı, ham veri kalitesini kontrol etmek, verileri kesmek ve ardından kesilmiş verilerin kalitesini yeniden kontrol etmektir. Böylece yüksek kaliteli ve analiz için uygun veriler elde edilir. Pipeline, Conda environment'ı kullanarak gerekli yazılım ve bağımlılıkları yönetir, bu da iş akışının taşınabilir ve tekrarlanabilir olmasını sağlar.

Bu analizlerde kullanılacak veri dosyalarına [bu bağlantıdan](https://drive.google.com/drive/folders/1nVZoJBbzGHKM0azNMPNGla_-A1h68H6Q?usp=drive_link) ulaşabilirsiniz.

This Nextflow pipeline includes a series of bioinformatics analysis steps designed to process raw FASTQ data. The aim of this pipeline is to perform quality control on the raw data, trim the data, and then perform quality control on the trimmed data. This ensures that high-quality and analysis-ready data are obtained. The pipeline uses a Conda environment to manage the required software and dependencies, making the workflow portable and reproducible.

You can access the data files used in these analyses [through this link](https://drive.google.com/drive/folders/1nVZoJBbzGHKM0azNMPNGla_-A1h68H6Q?usp=drive_link).

### Parametrelerin Oluşturulması / Defining the Parameters

Pipeline'da kullanılan parametreler, kullanıcının belirli ayarları kolayca değiştirmesine ve iş akışını özelleştirmesine olanak tanır. Aşağıdaki parametreler pipeline'ın başında tanımlanmıştır:

The parameters used in the pipeline allow the user to easily change specific settings and customize the workflow. The following parameters are defined at the beginning of the pipeline:

```bash
params.fastq = "data/raw/pe/*.fastq.gz"
params.qc_report = "results/raw/pe/fastqc_before_process"
params.trimmed_fastq = "results/processed/pe/processed_fastq"
params.qc_report_after_trim = "results/processed/pe/processed_fastqc"
params.threads = "4"
params.adapter_1 = "AGATCGGAAGAG" // Optional
params.adapter_2 = "AGATCGGAAGAG" // Optional
params.quality = "38" // Optional
params.min_length = "37" // Optional
```

### YAML Dosyasının Eklenmesi / Adding the YAML File

Bu Nextflow pipeline'ında, bioinfo.yaml adlı bir Conda environment dosyası kullanılır. Bu dosya, kullanılan yazılım ve bağımlılıklarını tanımlar ve Nextflow işlemlerinin gerektiği araçları ve sürümleri sağlar.

In this Nextflow pipeline, a Conda environment file named `bioinfo.yaml` is used. This file defines the software and dependencies required, ensuring that the necessary tools and versions are available for Nextflow processes.

```bash
name: bioinfo
channels:
  - conda-forge
  - bioconda
dependencies:
  - fastqc
  - cutadapt
  - bwa
  - samtools
  - openssl=1.0
```

### QC Aşaması / QC Stage

Bu aşama, ham FASTQ dosyalarının kalite kontrolünü (QC) gerçekleştirir. FastQC aracı kullanılarak dosyalar analiz edilir ve sonuçlar belirtilen bir dizine kopyalanır.

This stage performs quality control (QC) on the raw FASTQ files. The FastQC tool is used to analyze the files, and the results are copied to a specified directory.

```bash
process QC {
    conda 'envs/bioinfo.yaml'

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
```

### TRIM Aşaması / TRIM Stage

Bu aşama, FASTQ dosyalarını keser ve kalite kontrol sonrası işlenmiş dosyaları oluşturur. Cutadapt aracı kullanılarak adapter dizileri ve düşük kaliteli tabanlar kaldırılır.

This stage trims the FASTQ files and produces processed files after quality control. The Cutadapt tool is used to remove adapter sequences and low-quality bases.

```bash
process TRIM {
    conda 'envs/bioinfo.yaml'

    publishDir "${params.trimmed_fastq}", mode: 'copy'

    input:
    path fastq

    output:
    path "${fastq.baseName}_processed.fastq.gz"

    script:
    """
    cutadapt -q ${params.quality} -m ${params.min_length} --trim-n -a ${params.adapter_1} -a ${params.adapter_2} -j ${params.threads} -o ${fastq.baseName}_processed.fastq.gz $fastq
    """
}
```

### QC_AFTER_TRIM Aşaması / QC_AFTER_TRIM Stage

Bu aşama, kesilmiş (trimmed) FASTQ dosyalarının kalite kontrolünü gerçekleştirir. FastQC aracı kullanılarak dosyalar analiz edilir ve sonuçlar belirtilen bir dizine kopyalanır.

This stage performs quality control on the trimmed FASTQ files. The FastQC tool is used to analyze the files, and the results are copied to a specified directory.

```bash
process QC_AFTER_TRIM {
    conda 'envs/bioinfo.yaml'

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
```

### İş Akışı / Workflow

Bu iş akışı, yukarıdaki aşamaları sırasıyla çalıştırır. İlk olarak, ham FASTQ dosyaları kalite kontrolünden geçirilir, ardından kesilir ve son olarak tekrar kalite kontrolünden geçirilir.

This workflow runs the above stages in sequence. First, the raw FASTQ files undergo quality control, then they are trimmed, and finally, they undergo quality control again.

```bash
workflow {
    fastq_ch = Channel.fromPath(params.fastq)

    qc_results = QC(fastq_ch)
    qc_results.view()

    trimmed_fastq_ch = TRIM(fastq_ch)

    qc_after_trim_results = QC_AFTER_TRIM(trimmed_fastq_ch)
    qc_after_trim_results.view()
}
```

### Çalıştırma Kodu / Execution Command

Pipeline'ı çalıştırmak için terminale aşağıdaki komutu girin:

Execute the script by entering the following command in your terminal:

```bash
    nextflow run nf_scripts/Pipeline.nf
```
