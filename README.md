# Genome-Analyse-Nf
Genome analyse guide with pipeline created with nextflow.



---

# Nextflow ile FastQC Analizi Yapma / Performing FastQC Analysis with Nextflow

Bu belge, Nextflow kullanarak FastQC analizi yapmayı adım adım açıklar. / This document explains how to perform FastQC analysis using Nextflow step by step.

## Giriş / Introduction

Nextflow, veri işleme akışlarını yönetmek için güçlü ve esnek bir araçtır. Bu belgede, Nextflow'un genişletilebilirlik özelliklerinden yararlanarak FastQC analizi yapmayı göstereceğiz. / Nextflow is a powerful and flexible tool for managing data processing workflows. In this document, we will demonstrate how to perform FastQC analysis using Nextflow's extensibility features.

## Gereksinimler / Requirements

- Nextflow'un yüklü olduğundan emin olun. Nextflow'un nasıl yükleneceğine dair talimatlar için [Nextflow resmi belgelerine](https://www.nextflow.io/docs/latest/getstarted.html) başvurabilirsiniz. / Make sure Nextflow is installed. For instructions on how to install Nextflow, you can refer to the [official Nextflow documentation](https://www.nextflow.io/docs/latest/getstarted.html).
- FastQC'nin sistemde yüklü olduğundan emin olun. FastQC'nin yüklü olup olmadığını kontrol etmek için terminal veya komut istemcisinde `fastqc --version` komutunu çalıştırabilirsiniz. FastQC'nin yüklü olmadığı durumda, [FastQC web sitesinden](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) indirip kurabilirsiniz. / Ensure FastQC is installed on your system. You can check if FastQC is installed by running the `fastqc --version` command in your terminal or command prompt. If FastQC is not installed, you can download and install it from the [FastQC website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

## Adım Adım Talimatlar / Step-by-Step Instructions

1. **nextflow.config Dosyası Ayarları / Setting up nextflow.config File**

   İlk olarak, `nextflow.config` dosyasında DSL2'nin etkin olduğundan emin olun. Bu, Nextflow'un ikinci nesil Domain Specific Language (DSL) sürümünü kullanacağını belirtir. Ayrıca, giriş ve çıkış dosya yolunu belirlemek için `params` bloğunu yapılandırın. / First, make sure DSL2 is enabled in the `nextflow.config` file. This specifies that Nextflow will use the second-generation Domain Specific Language (DSL). Also, configure the `params` block to specify the input and output file paths.

   ```bash
   nextflow.enable.dsl=2

   params.fastq= # "your_path/fastq/*.fastq.gz"

   params.qc_report= # "your_path/fastqc_report"
   ```

2. **QC Süreci Tanımı / Definition of QC Process**

   Ardından, FastQC analizi için bir işlem tanımlayın. Bu işlemde, giriş dosyalarını alacak, FastQC analizini yapacak ve çıktıları belirtilen klasöre kaydedecektir. / Next, define a process for FastQC analysis. In this process, it will take input files, perform FastQC analysis, and save the outputs to the specified folder.

   ```bash
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
   ```

3. **Çalışma Akışı Tanımı / Definition of Workflow**

   Son olarak, bir çalışma akışı tanımlayın. Bu akış, giriş dosyalarını bir kanal aracılığıyla alacak, QC işlemini çalıştıracak ve çıktıları gösterecektir. / Finally, define a workflow. This workflow will take input files through a channel, execute the QC process, and display the outputs.

   ```bash
   workflow {

       fastq_ch=Channel.fromPath(params.fastq)
       QC(fastq_ch)
       QC.out.view()
   }
   ```

## Çalıştırma / Running

Belirtilen adımları izledikten sonra, Nextflow betiğini çalıştırarak FastQC analizini başlatabilirsiniz. / After following the specified steps, you can initiate FastQC analysis by running the Nextflow script.

```bash
nextflow run script.nf
```

## Sonuçlar / Results

FastQC analizi tamamlandıktan sonra, belirttiğiniz çıktı klasöründe QC raporlarını bulabilirsiniz. / After the completion of FastQC analysis, you can find the QC reports in the specified output folder.

---

