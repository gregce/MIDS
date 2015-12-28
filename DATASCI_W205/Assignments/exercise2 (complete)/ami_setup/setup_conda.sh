#download conda
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.4.0-Linux-x86_64.sh

#run the installer
bash Anaconda2-2.4.0-Linux-x86_64.sh

#cleanup the installer
rm Anaconda2-2.4.0-Linux-x86_64.sh

#make sure anaconda is deault python
source /root/EX2Tweetwordcount/ami_setup/.bashrc

#install py2hs driver
conda install -c https://conda.anaconda.org/moutai pyhs2

#install mysql driver
conda install mysql-python

#install imdbpy
cd /root/anaconda2/pkgs
wget https://bitbucket.org/alberanid/imdbpy/get/5.0.tar.gz
tar xvzf 5.0.tar.gz
mv alberanid-imdbpy-398c01b96107/ imdbpy
pip install imdbpy/

#install psycopg2
pip install psycopg2

#install streamparse
pip install streamparse

#install pylab
pip install pylab

#install tweepy
pip install tweepy
