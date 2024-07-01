# Nasıl Kurulur? / How to Install?

## Bash Üzerinde Kurulum / Installation on Bash

1. **Java JDK Kurulumu / Install Java JDK**: Nextflow'un çalışması için Java JDK'nın yüklü olması gerekir. *[Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)* veya *[OpenJDK](https://openjdk.java.net/)* kullanabilirsiniz.

Java JDK is required for Nextflow to work. You can use either *[Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)* or *[OpenJDK](https://openjdk.java.net/).*

2. **Nextflow Kurulumu / Install Nextflow**: Bash terminalinize aşağıdaki komutu yazarak Nextflow'u indirebilir ve kurabilirsiniz:

You can download and install Nextflow by typing the following command into your Bash terminal:

```bash
curl -s https://get.nextflow.io | bash
```

3. **Nextflow'un PATH'e Eklenmesi / Adding Nextflow to PATH:** *Nextflow betiğini PATH ortam değişkenine ekleyin: / Add the Nextflow script to your PATH environment variable:*

```bash
export PATH=$PATH:<nextflow_installation_directory>
```

## Conda Üzerinde Kurulum / Installation on Conda

Conda, farklı yazılım paketlerini ve onların bağımlılıklarını yönetmek için kullanılan açık kaynaklı bir paket yöneticisidir. Conda'nın nasıl kurulacağını ve kullanılarak Nextflow'un nasıl yükleneceğini aşağıda bulabilirsiniz. / Conda is an open-source package manager used to manage different software packages and their dependencies. Below you can find how to install Conda and use it to install Nextflow.
    
1. **Conda'yı Kurma / Installing Conda**

Miniconda veya Anaconda yükleyicisini indirin ve kurun. Miniconda, daha hafif bir yükleyicidir ve sadece temel Conda araçlarını içerir, oysa Anaconda, birçok ek veri bilimi paketini içerir. / Download and install the Miniconda or Anaconda installer. Miniconda is a lighter installer and includes only the basic Conda tools, whereas Anaconda includes many additional data science packages.

*Bash terminalinize aşağıdaki komutu yazarak miniconda'yı indirebilir ve kurabilirsiniz: / You can download and install miniconda by typing the following command into your Bash terminal:*

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
 
*İşlem tamamlandıktan sonra script'i silebilirsiniz / You can delete the script after it is finished :*

```bash
rm Miniconda3-latest-Linux-x86_64.sh
```

*Conda Güncelleme / Update Conda :*
```bash
eval "$(miniconda3/bin/conda shell.bash hook)"
```


2. **Conda Ortamı Oluşturma / Create a Conda Environment:** *Bir Conda ortamı oluşturun (isteğe bağlı): / Create a Conda environment (optional):*

```bash
conda create -n nextflow_env
conda activate nextflow_env
```

3. **Nextflow Kurulumu / Install Nextflow:** *Conda ile Nextflow'un resmi kanalından kurulum yapın: / Install Nextflow from the official channel of Conda:*

```bash
conda install -c bioconda nextflow
```

