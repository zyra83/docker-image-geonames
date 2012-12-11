REM @echo off

REM rmdir /S /Q dl
REM mkdir dl
cd dl

REM Téléchage les données depuis géonames.org */
REM ..\bin\wget http://download.geonames.org/export/dump/admin2Codes.txt
REM ..\bin\wget  http://download.geonames.org/export/dump/admin1CodesASCII.txt 
REM ..\bin\wget  http://download.geonames.org/export/dump/allCountries.zip

REM ..\bin\wget  http://download.geonames.org/export/dump/cities15000.zip
REM ..\bin\wget  http://download.geonames.org/export/dump/cities1000.zip
REM ..\bin\wget  http://download.geonames.org/export/dump/cities5000.zip

REM ..\bin\wget  http://download.geonames.org/export/dump/alternateNames.zip
REM ..\bin\wget  http://download.geonames.org/export/dump/countryInfo.txt 
REM ..\bin\wget  http://download.geonames.org/export/dump/featureCodes_en.txt
REM ..\bin\wget  http://download.geonames.org/export/dump/iso-languagecodes.txt
REM ..\bin\wget  http://download.geonames.org/export/dump/timeZones.txt 
REM ..\bin\wget  http://download.geonames.org/export/dump/userTags.zip

REM prépare les fichiers
REM ..\bin\7z x allCountries.zip 
REM ..\bin\7z x cities15000.zip 
REM ..\bin\7z x cities5000.zip 
REM ..\bin\7z x cities1000.zip 
REM ..\bin\7z -y x alternateNames.zip 
REM ..\bin\7z x userTags.zip

REM del *.zip

REM fait le ménage dans country info
REM type countryInfo.txt | findstr /v /r "^#" > countryInfo-n.txt

mysql -uroot -proot < ..\data\import.sql

pause