# İlk pratik Script'iniz / Practice Script

Bu script, iki işlem tanımlar. İlk işlem, bir string'i 6 karakterlik parçalara böler ve her birini chunk_ önekiyle bir dosyaya yazar. İkinci işlem ise bu dosyaları alır ve içeriklerini büyük harflere dönüştürür. Ortaya çıkan stringler result kanalında yayılır ve nihai çıktı view operatörü tarafından yazdırılır. Aşağıdaki örneği favori metin düzenleyicinize kopyalayın ve tutorial.nf adlı bir dosyaya kaydedin: / This script defines two processes. The first splits a string into 6-character chunks, writing each one to a file with the prefix chunk_, and the second receives these files and transforms their contents to uppercase letters. The resulting strings are emitted on the result channel and the final output is printed by the view operator. Copy the following example into your favorite text editor and save it to a file named tutorial.nf:

```bash
params.str = 'Hello world!'

process splitLetters {
    output:
    path 'chunk_*'

    """
    printf '${params.str}' | split -b 6 - chunk_
    """
}

process convertToUpper {
    input:
    path x

    output:
    stdout

    """
    cat $x | tr '[a-z]' '[A-Z]'
    """
}

workflow {
    splitLetters | flatten | convertToUpper | view { it.trim() }
}
```

### Script'i Çalıştırma / Execute the Script
Script'i çalıştırmak için terminalinize aşağıdaki komutu girin: / Execute the script by entering the following command in your terminal:

```bash
nextflow run tutorial.nf
```
*Sonuç: / Result:*

N E X T F L O W  ~  version 23.10.0
executor >  local (3)
[69/c8ea4a] process > splitLetters   [100%] 1 of 1 ✔
[84/c8b7f1] process > convertToUpper [100%] 2 of 2 ✔
HELLO
WORLD!

**Not / Note**
Nextflow'un 22.10.0'dan önceki sürümleri için, DSL2'yi açıkça etkinleştirmeniz gerekmektedir. Bunu script'in en üstüne nextflow.enable.dsl=2 ekleyerek veya -dsl2 komut satırı seçeneğini kullanarak yapabilirsiniz. / For versions of Nextflow prior to 22.10.0, you must explicitly enable DSL2 by adding nextflow.enable.dsl=2 to the top of the script or by using the -dsl2 command-line option.

