

---

# Nextflow Nedir? / What is Nextflow?

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

---

# Nextflow ile FastQC Analizi Yapma / Performing FastQC Analysis with Nextflow

Bu belge, Nextflow kullanarak FastQC analizi yapmayı adım adım açıklar. Ayrıca, ham FASTQ dosyalarını kesmek için Cutadapt kullanılarak yapılan eklemeleri de kapsar. / This document explains how to perform FastQC analysis using Nextflow step-by-step, including additional steps that involve trimming raw FASTQ files using Cutadapt.

## Giriş / Introduction

Nextflow, veri işleme akışlarını yönetmek için güçlü ve esnek bir araçtır. Bu belgede, Nextflow'un genişletilebilirlik özelliklerinden yararlanarak FastQC analizi yapmayı göstereceğiz. Şimdi, aynı iş akışına FastQC analizi sonrası kesme işlemi ve ardından yeniden FastQC analizi ekleyeceğiz. / Nextflow is a powerful and flexible tool for managing data processing workflows. In this document, we will demonstrate how to perform FastQC analysis using Nextflow's extensibility features. Now, we will also add trimming of FASTQ files followed by another FastQC analysis to the workflow.

## Gereksinimler / Requirements

- Nextflow'un yüklü olduğundan emin olun. Nextflow'un nasıl yükleneceğine dair talimatlar için [Nextflow resmi belgelerine](https://www.nextflow.io/docs/latest/getstarted.html) başvurabilirsiniz. / Make sure Nextflow is installed. For instructions on how to install Nextflow, you can refer to the [official Nextflow documentation](https://www.nextflow.io/docs/latest/getstarted.html).
- FastQC'nin sistemde yüklü olduğundan emin olun. FastQC'nin yüklü olup olmadığını kontrol etmek için terminal veya komut istemcisinde `fastqc --version` komutunu çalıştırabilirsiniz. FastQC'nin yüklü olmadığı durumda, [FastQC web sitesinden](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) indirip kurabilirsiniz. / Ensure FastQC is installed on your system. You can check if FastQC is installed by running the `fastqc --version` command in your terminal or command prompt. If FastQC is not installed, you can download and install it from the [FastQC website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).
- Cutadapt'ın yüklü olduğundan emin olun. Bunu kontrol etmek için cutadapt --version komutunu çalıştırabilirsiniz. Cutadapt'ı yüklemek için Cutadapt'ın GitHub sayfasını ziyaret edebilirsiniz. / Make sure Cutadapt is installed. You can check by running cutadapt --version. To install Cutadapt, visit the Cutadapt GitHub page.

## Adım Adım Talimatlar / Step-by-Step Instructions

1. **nextflow.config Dosyası Ayarları / Setting up the nextflow.config File**

   `nextflow.config` dosyasını, giriş ve çıkış dosya yollarını içerecek şekilde ayarlayın. Ayrıca DSL2'yi etkinleştirin. / Set up the `nextflow.config` file to include the input and output file paths. Also, enable DSL2.

   ```groovy
   nextflow.enable.dsl=2

   params.fastq="data/*.fastq.gz"
   params.qc_report="results/fastqc-before-trim"
   params.trimmed_fastq="results/trimmed_fastq"
   params.qc_report_after_trim="results/fastqc-after-trim"
   ```

2. **QC Süreci Tanımı / Defining the QC Process**

   Ham FASTQ dosyalarına FastQC analizi uygulamak için bir süreç tanımlayın. / Define a process to apply FastQC analysis to raw FASTQ files.

   ```groovy
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
   ## "publishDir" Nedir? / What is "publishDir"?

   *publishDir("${params.qc_report}", mode: 'copy'):*

"publishDir("${params.qc_report}", mode: 'copy')" satırı, "QC" adlı işlemde elde edilen sonuçların belirtilen dizine nasıl yayımlanacağını açıklar. / The line "publishDir("${params.qc_report}", mode: 'copy')" describes how the results obtained in the process named "QC" are published to the specified directory.

- *publishDir(...):* İşlemde üretilen dosyaların belirtilen dizine yayımlanmasını sağlar. / This ensures that the files generated by the process are published to the specified directory.
- *"${params.qc_report}":* Dosyaların yayımlanacağı dizin. Bu örnekte, bu değişken "results/fastqc-before-trim" olarak ayarlanmış, yani dosyalar "results/fastqc-before-trim" dizinine gönderilecektir. / The directory where the files will be published. In this example, the variable is set to "results/fastqc-before-trim", so the files will be sent to the "results/fastqc-before-trim" directory.
- *mode: 'copy':* Yayımlanan dosyaların bu dizine kopyalanacağını belirtir. 'copy' modu, işlem çıktılarının orijinal konumlarında da kalacağı anlamına gelir. Alternatif olarak 'move' modu kullanılabilirdi; bu durumda dosyalar işlem tamamlandıktan sonra orijinal konumlarından kaldırılıp yalnızca hedef dizinde tutulurdu. / This indicates that the published files will be copied to this directory. The 'copy' mode means that the outputs will also remain in their original locations. Alternatively, the 'move' mode could be used, which would remove the files from their original locations after the process and keep them only in the target directory.
Özetle, bu satır, işlem tamamlandığında elde edilen tüm dosyaların "results/fastqc-before-trim" dizinine kopyalanacağını belirtir. Bu, işlem çıktılarının merkezi bir konumda düzenli bir şekilde saklanmasına ve kolayca erişilebilmesine yardımcı olur. / In summary, this line indicates that all files obtained after the process is completed will be copied to the "results/fastqc-before-trim" directory. This helps keep the process outputs in a centralized location, organized, and easily accessible.

3. **TRIM Süreci Tanımı / Defining the TRIM Process**

   FastQC analizinden sonra FASTQ dosyalarını kesmek için bir süreç tanımlayın. Bu adımda Cutadapt kullanılır. / Define a process to trim FASTQ files after FastQC analysis. This step uses Cutadapt.

   ```groovy
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
   ```


   ## "${fastq.baseName}_trimmed.fastq.gz $fastq" Nedir? / What is "${fastq.baseName}_trimmed.fastq.gz $fastq"?
  **${fastq.baseName}_trimmed.fastq.gz** kısmı, kesme işleminin sonucunda oluşacak dosyanın adını belirler. **${fastq.baseName}** kullanılarak, orijinal **FASTQ** dosyasının temel adı alınır ve ardından **"_trimmed"** ifadesi eklenir. Bu, kesilmiş 
  dosyaları orijinallerinden ayırt etmek için kullanılır. **$fastq** kısmı ise kesme işlemi için girdi olarak kullanılacak orijinal **FASTQ** dosyasını temsil eder. Bu kod satırı, hangi dosyanın kesileceğini ve kesme sonucunda ne adla bir dosyanın 
 oluşturulacağını belirtir. / The **${fastq.baseName}_trimmed.fastq.gz** part specifies the name of the output file resulting from the trimming process. By using **${fastq.baseName}**, the base name of the original **FASTQ** file is retrieved, and 
 then the **"_trimmed"** suffix is appended. This is used to differentiate trimmed files from the originals.
  The **$fastq** part represents the original **FASTQ** file that will be used as input for the trimming process. This line of code indicates which file will be trimmed and the name of the file that will be created as a result of the trimming.
   

5. **QC_AFTER_TRIM Süreci Tanımı / Defining the QC_AFTER_TRIM Process**

   Kesilen FASTQ dosyalarına FastQC analizi uygulamak için bir süreç tanımlayın. / Define a process to apply FastQC analysis to trimmed FASTQ files.

   ```groovy
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
   ```

6. **Çalışma Akışı Tanımı / Defining the Workflow**

   Çalışma akışını FastQC, kesme ve ardından tekrar FastQC analizi için ayarlayın. / Define the workflow to include FastQC, trimming, and then another FastQC analysis.

   ```groovy
   workflow {

       fastq_ch = Channel.fromPath(params.fastq)
       QC(fastq_ch)
       QC.out.view()

       trimmed_fastq_ch = TRIM(fastq_ch)
       QC_AFTER_TRIM(trimmed_fastq_ch)
       QC_AFTER_TRIM.out.view()
   }
   ```

## Çalıştırma / Running

Belirtilen adımları izledikten sonra, Nextflow betiğini çalıştırarak FastQC analizini başlatabilirsiniz. / After following the specified steps, you can initiate the FastQC analysis by running the Nextflow script.

```bash
nextflow run pipeline.nf
```
## Sonuçlar / Results
FastQC analizi tamamlandıktan sonra, FastQC raporlarını belirtilen QC rapor klasörlerinde bulabilirsiniz. / After the completion of FastQC analysis, you can find the FastQC reports in the specified QC report folders.

---
