# -*- coding: utf-8 -*-
"""
Created on Sat Oct 31 17:59:24 2015

@author: ceccarelli
"""

import ftplib
import socket
import os

#print 'The current working directory is %s' % os.getcwd()

HOST = r'ftp.fu-berlin.de'
DRN = r'/pub/misc/movies/database/'


class ftpHandler(object):
    
    def __init__(self, host, drn):
        """ Return a ftpHandler object"""
        self.host = host
        self.drn = drn
        
    def connect(self):
        try:
            self.connection = ftplib.FTP(self.host)
            print "CONNECTED TO HOST '%s'" % self.host
        except (socket.error, socket.gaierror) as e:
            print 'Error: cannot reach "%s"' % self.host
        if self.connection:
            try:
                self.connection.login()
            except:
                print 'Error: cannot login annonymously'
                self.connection.quit()
            print "Logged In"
        return self.connection
        
    def directory(self):
        try:
             self.connection.cwd(self.drn)
             print 'Changed to "%s" folder' %self.drn
             self.filelist = self.connection.nlst()
             #print self.filelist
        except ftplib.error_perm:
             print 'Error: cannot CD to "%s"' %self.drn
             self.connection.quit()
        return self.filelist
  
    
    def getfiles(self, dir_to_write=os.getcwd(), endswith=".gz"):
        try:
            for file in self.filelist[1:]:
                if file.endswith(endswith):
                    with open(os.path.join(dir_to_write, file), 'wb') as local_file:
                        self.connection.retrbinary('RETR %s' % file, local_file.write)
                        print 'Downloaded file %s' % file
                    
        except ftplib.error_perm:
            print 'Error cannot read file "%s"' % file
            os.unlink(file)
            self.connection.quit()

# %%

f = ftpHandler(HOST,DRN)
f.connect()
f.directory()
f.getfiles(dir_to_write=u'/root/persist/imdb_files')

#./imdbpy2sql.py -d /usr/local/w205-Course-Project/imdb_files -u  mysql://root@localhost:3306/imdb?unix_socket=/var/lib/mysql/mysql.sock -c /usr/local/w205-Course-Project/imdb_csvs/ --csv-only-write
#nohup ./imdbpy2sql.py -d /usr/local/w205-Course-Project/imdb_files -u  mysql://root@localhost:3306/imdb?unix_socket=/var/lib/mysql/mysql.sock -c /usr/local/w205-Course-Project/imdb_csvs/ --csv-only-write &

# %%
#f.getfiles(dir_to_write=u'/Users/ceccarelli/MIDS/DATASCI_W205/w205-Course-Project/imdb_files',n=5)
