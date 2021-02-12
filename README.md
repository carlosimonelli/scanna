# scanna!

## Interface to the Virus Total API

## Procedure

Per prima cosa, vanno calcolati gli hash (md5 o sha1) dei file da verificare.  
Ipotizzando che i file siano contenuti nelle sotto-directory di una stessa cartella (nel nostro caso, la directory `test`), il comando può essere:

```
find ./test -type f -exec md5 {} \; | tee hash-doc.md5
```

e genererà un output simile a questo:

```
MD5 (./test/Malware Technical Insight _Turla “Penquin_x64”.pdf) = 9c183abae72a8619e594843872719e95
MD5 (./test/downturnsurveyreport.pdf) = 8159f7835ea0cfa671f12351effc80ea
MD5 (./test/FortiOS-5.2.14-REST-API-Reference.pdf) = c441ae0a430ea037578e4ed1daaa5c72
MD5 (./test/cd6b9ffc4ceb908c61c10710c023a8a8) = cd6b9ffc4ceb908c61c10710c023a8a8
MD5 (./test/wp-accessible-security-orchestration.pdf) = 93b85eee2b6357de89ecd17ff697b43a
MD5 (./test/Infographics Penquin_x64 by LDO.pdf) = 4ed2b1eb9bd245db31c208fd13a93530
MD5 (./test/analyzing-malicious-document-files.pdf) = b87875732c6b642c25ad396f79b77427
MD5 (./test/La-NIS-in-pillole.pdf) = 2a97865d936d27302c1adfa185000b7d
```

Dato che il formato potrebbe variare, ho preferito creare un file di input contenente solo gli hash, che può essere facilmente generato con comandi come:

```
cat hash-doc.md5 | cut -d "=" -f 2 > hash-list.txt
```

generando un file simile a:

```
9c183abae72a8619e594843872719e95
8159f7835ea0cfa671f12351effc80ea
c441ae0a430ea037578e4ed1daaa5c72
cd6b9ffc4ceb908c61c10710c023a8a8
93b85eee2b6357de89ecd17ff697b43a
4ed2b1eb9bd245db31c208fd13a93530
b87875732c6b642c25ad396f79b77427
2a97865d936d27302c1adfa185000b7d
```

I due file, poi, devono essere passati come parametri allo script:

```
sh scanna.sh hash-list.txt hash-doc.md5
```

che produrrà il seguente output:

```
9c183abae72a8619e594843872719e95 = 404
8159f7835ea0cfa671f12351effc80ea = 404
c441ae0a430ea037578e4ed1daaa5c72 = 404
cd6b9ffc4ceb908c61c10710c023a8a8 = 200
	MD5 (./test/cd6b9ffc4ceb908c61c10710c023a8a8) = cd6b9ffc4ceb908c61c10710c023a8a8
	filename:  	condizion_7785474.doc
	malicious: 	16
	suspicious:	0
93b85eee2b6357de89ecd17ff697b43a = 404
4ed2b1eb9bd245db31c208fd13a93530 = 404
b87875732c6b642c25ad396f79b77427 = 200
	MD5 (./test/analyzing-malicious-document-files.pdf) = b87875732c6b642c25ad396f79b77427
	filename:  	analyzing-malicious-document-files.pdf
	malicious: 	0
	suspicious:	0
2a97865d936d27302c1adfa185000b7d = 200
	MD5 (./test/La-NIS-in-pillole.pdf) = 2a97865d936d27302c1adfa185000b7d
	filename:  	La-NIS-in-pillole.pdf
	malicious: 	0
	suspicious:	0
```

Se VirustTotal non riconosce il file, torna un codice 404.
Se al contrario lo riconosce, torna un array di dati in formato json, in cui sono contenute tutte le informazioni disponibili su di esso (v. file `curl.out`).
In questo caso, il programma stampa il nome del file a cui si riferisce l'hash e legge l'esito dell'analisi dall'output json della chiamata `curl`.
Il campo `filename` è il nome del file che è stato analizzato da VirusTotal.
L'hash e i dati relativi ai file identificati da VirusTotal sono riportati nel file `hash-find.txt`: 

```
cd6b9ffc4ceb908c61c10710c023a8a8	0	16	condizion_7785474.doc
b87875732c6b642c25ad396f79b77427	0	0	analyzing-malicious-document-files.pdf
2a97865d936d27302c1adfa185000b7d	0	0	La-NIS-in-pillole.pdf
```

 
