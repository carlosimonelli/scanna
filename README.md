# scanna!

## Interface to the Virus Total API

## Procedure

Per prima cosa, vanno calcolati gli hash (md5 o sha1) dei file da verificare.  
Ipotizzando che i file siano contenuti nelle sotto-directory di una stessa cartella, il comando può essere:

```
find . -type f -exec md5 {} \; | tee document-hash.md5
```

e genererà un output simile a questo:

```
MD5 (./curl.json) = d41d8cd98f00b204e9800998ecf8427e
MD5 (./LICENSE) = 1ebbd3e34237af26da5dc08a4e440464
MD5 (./bin/bump-version.sh) = fa6ddccae1e1ca105f7a3e5885535147
MD5 (./bin/purge-cache.sh) = 8c476433df73fed3f4b3b64ea756b403
MD5 (./CHANGELOG.md) = 5920c6c492400fff0713ea547a615980
MD5 (./curl.out) = d41d8cd98f00b204e9800998ecf8427e
MD5 (./output) = 614585d2ab4ead339b5a39381e21143c
MD5 (./README.md) = 408d0f4ba72b42af5bd82f0e02754dba
MD5 (./hash.list) = a9ebc21037b8b234e1b20627471c41e7
MD5 (./virustotal-api.sh) = cd44927ea0ea843a65d49e4c98d0606d
MD5 (./.gitignore) = 65555acbc36d4c601cd9a88e39b18c11
MD5 (./VERSION) = 1347633cdf7cdcb2168d61093630d5ae
MD5 (./hash.200) = d41d8cd98f00b204e9800998ecf8427e
MD5 (./.git/config) = 09b91165e6425f5f04b80f1b1df96398
```

Dato che il formato potrebbe variare, ho preferito creare un file di input contenente solo gli hash, che può essere facilmente generato con comandi come:

```
cat document-hash.md5 | cut -d "=" -f 2 > hash-list.txt
```

generando un file simile a:

```
d41d8cd98f00b204e9800998ecf8427e
1ebbd3e34237af26da5dc08a4e440464
fa6ddccae1e1ca105f7a3e5885535147
8c476433df73fed3f4b3b64ea756b403
5920c6c492400fff0713ea547a615980
d41d8cd98f00b204e9800998ecf8427e
614585d2ab4ead339b5a39381e21143c
408d0f4ba72b42af5bd82f0e02754dba
a9ebc21037b8b234e1b20627471c41e7
```

I due file, poi, devono essere passati come parametri allo script:

```
sh scanna.sh hash-list.txt document-hash.md5
```
