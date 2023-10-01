#!/bin/bash
sudo apt-get update
sudo apt install python3
sudo apt-get --print-uris --yes install w3m | grep ^\' | cut -d\' -f2 > todownload.txt
sudo apt-get --print-uris --yes install apache2 | grep ^\' | cut -d\' -f2 > todownload1.txt
mkdir web
cd ./web
sudo wget --input-file /todownload.txt
sudo wget --input-file /todownload1.txt
cd ..
tar -czvf archive.tar.gz /web
python3 -m http.server --bind 0.0.0.0 9000
