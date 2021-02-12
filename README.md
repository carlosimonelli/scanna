# Scanna!

## Purpose
**Scanna!** is an interface to the Virus Total API.
Its aim is to check multiple file hashes against the VT database.
I'm not very familiar with bash scripting; so, suggestion, as well as insults or jokes about my code are welcome. :-)

## Procedure
First, you need to calculate the hashes (MD5 or SHA1) of the files with a command like:

```
find ./test -type f -exec md5 {} \; | tee hash-doc.md5
```

On my Mac, it produces the output:

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

On other systems the output may vary, so I decided to use as input a file containing only hashes.
I extract the hashes with the command:

```
cat hash-doc.md5 | cut -d "=" -f 2 > hash-list.txt
```

generating a file like:

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

Both files must be passed as parameters to the script:

```
sh scanna.sh hash-list.txt hash-doc.md5
```

The output of the elaboration will be:

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

If VirustTotal does not recognize the file, it returns a 404 code.  
If VirusTotal recognizes the file, it returns an array of data in json format, containing all the information available on it (see file `curl.out`).
In this case, the program prints out the name of the file the hash refers to and the result of the analysis.

```
    MD5 (./test/La-NIS-in-pillole.pdf) = 2a97865d936d27302c1adfa185000b7d
    filename:  	La-NIS-in-pillole.pdf
    malicious: 	0
    suspicious:	0
```

The `filename` field is the name of the file returned by VirusTotal.  

The hash and data related to files identified by VirusTotal are reported in the `hash-find.txt` file:

```
cd6b9ffc4ceb908c61c10710c023a8a8	0	16	condizion_7785474.doc
b87875732c6b642c25ad396f79b77427	0	0	analyzing-malicious-document-files.pdf
2a97865d936d27302c1adfa185000b7d	0	0	La-NIS-in-pillole.pdf
```

 
