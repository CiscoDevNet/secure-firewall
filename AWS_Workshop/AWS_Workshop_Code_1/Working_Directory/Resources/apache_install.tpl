#!/bin/bash
echo 'test' > output.txt
curl 10.1.6.10:9000/archive.tar.gz -o kd.tar.gz
tar zxvf kd.tar.gz
cd ./web
sudo dpkg -i *.deb