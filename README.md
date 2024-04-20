

---

# Nextflow ile Veri Akışı Yönetimi / Managing Data Flow with Nextflow

Nextflow, araştırmacıların ve veri bilimcilerin karmaşık veri analizi iş akışlarını yönetmelerine yardımcı olan bir araçtır. / Nextflow is a tool that helps researchers and data scientists manage complex data analysis workflows.

## Ne İşe Yarar? / What is it for?

Nextflow, dağınık ve paralel veri işleme iş akışlarını yönetmek için kullanılır. Başlıca özellikleri şunlardır: / Nextflow is used to manage distributed and parallel data processing workflows. Its main features include:

- **Modüler İş Akışları / Modular Workflows**: Her işlemi ayrı bir modül olarak tanımlama ve birleştirme olanağı sunar. / It allows defining and combining each task as a separate module.
- **Yeniden Kullanılabilirlik / Reusability**: Bir defa tanımlanan iş akışlarını kolayca yeniden kullanabilirsiniz. / Workflows defined once can be easily reused.
- **Paralel İşleme / Parallel Processing**: İşlemleri aynı anda veya sırayla çalıştırabilir, böylece performansı artırabilirsiniz. / Processes can be run concurrently or sequentially to improve performance.
- **Dağınık Hesaplama / Distributed Computing**: Birden fazla bilgisayarı veya bulut kaynağını kullanarak işlemleri dağıtabilir. / Tasks can be distributed across multiple machines or cloud resources.
- **Yeniden Başlatma Yeteneği / Restart Capability**: İşlemler hata aldığında veya kesintiye uğradığında kaldığı yerden devam edebilir. / Processes can resume from where they left off in case of errors or interruptions.
- **Hata İzleme ve Hata Ayıklama / Error Monitoring and Debugging**: İş akışlarını izlemek ve hataları gidermek için kolay araçlar sunar. / Provides easy-to-use tools for monitoring workflows and debugging errors.

## Nasıl Kurulur? / How to Install?

### Bash Üzerinde Kurulum / Installation on Bash

1. **Java JDK Kurulumu / Install Java JDK**: Nextflow'un çalışması için Java JDK'nın yüklü olması gerekir. [Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) veya [OpenJDK](https://openjdk.java.net/) kullanabilirsiniz. / Java JDK is required for Nextflow to work. You can use either [Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) or [OpenJDK](https://openjdk.java.net/).

2. **Nextflow Kurulumu / Install Nextflow**: Bash terminalinize aşağıdaki komutu yazarak Nextflow'u indirebilir ve kurabilirsiniz: / You can download and install Nextflow by typing the following command into your Bash terminal:

    ```bash
    curl -s https://get.nextflow.io | bash
    ```

3. **Nextflow'un PATH'e Eklenmesi / Adding Nextflow to PATH**: Nextflow betiğini PATH ortam değişkenine ekleyin: / Add the Nextflow script to your PATH environment variable:

    ```bash
    export PATH=$PATH:<nextflow_installation_directory>
    ```

### Conda Üzerinde Kurulum / Installation on Conda

1. **Conda Ortamı Oluşturma / Create a Conda Environment**: Bir Conda ortamı oluşturun (isteğe bağlı): / Create a Conda environment (optional):

    ```bash
    conda create -n nextflow_env
    conda activate nextflow_env
    ```

2. **Nextflow Kurulumu / Install Nextflow**: Conda ile Nextflow'un resmi kanalından kurulum yapın: / Install Nextflow from the official channel of Conda:

    ```bash
    conda install -c bioconda nextflow
    ```

# Nextflow ile FastQC Analizi Yapma /  FastQC Analysis with Nextflow

Bu belge, Nextflow kullanarak FastQC analizi yapmayı adım adım açıklar. / This document explains how to perform FastQC analysis using Nextflow step by step.

## Giriş / Introduction

Nextflow, veri işleme akışlarını yönetmek için güçlü ve esnek bir araçtır. Bu belgede, Nextflow'un genişletilebilirlik özelliklerinden yararlanarak FastQC analizi yapmayı göstereceğiz. / Nextflow is a powerful and flexible tool for managing data processing workflows. In this document, we will demonstrate how to perform FastQC analysis using Nextflow's extensibility features.

## Gereksinimler / Requirements

- Nextflow'un yüklü olduğundan emin olun. Nextflow'un nasıl yükleneceğine dair talimatlar için [Nextflow resmi belgelerine](https://www.nextflow.io/docs/latest/getstarted.html) başvurabilirsiniz. / Make sure Nextflow is installed. For instructions on how to install Nextflow, you can refer to the [official Nextflow documentation](https://www.nextflow.io/docs/latest/getstarted.html).
- FastQC'nin sistemde yüklü olduğundan emin olun. FastQC'nin yüklü olup olmadığını kontrol etmek için terminal veya komut istemcisinde `fastqc --version` komutunu çalıştırabilirsiniz. FastQC'nin yüklü olmadığı durumda, [FastQC web sitesinden](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) indirip kurabilirsiniz. / Ensure FastQC is installed on your system. You can check if FastQC is installed by running the `fastqc --version` command in your terminal or command prompt. If FastQC is not installed, you can download and install it from the [FastQC website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

## Adım Adım Talimatlar / Step-by-Step Instructions

1. **nextflow.config Dosyası Ayarları / Setting up nextflow.config File**

2.**Okumalar için/ for reads:** https://drive.google.com/drive/folders/1nVZoJBbzGHKM0azNMPNGla_-A1h68H6Q?usp=drive_link

   İlk olarak, `nextflow.config` dosyasında DSL2'nin etkin olduğundan emin olun. Bu, Nextflow'un ikinci nesil Domain Specific Language (DSL) sürümünü kullanacağını belirtir. Ayrıca, giriş ve çıkış dosya yolunu belirlemek için `params` bloğunu yapılandırın. / First, make sure DSL2 is enabled in the `nextflow.config` file. This specifies that Nextflow will use the second-generation Domain Specific Language (DSL). Also, configure the `params` block to specify the input and output file paths.

   ```bash
   nextflow.enable.dsl=2

   params.fastq= # "your_path/fastq/*.fastq.gz"

   params.qc_report= # "your_path/fastqc_report"
   ```

3. **QC Süreci Tanımı / Definition of QC Process**

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

4. **Çalışma Akışı Tanımı / Definition of Workflow**

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
