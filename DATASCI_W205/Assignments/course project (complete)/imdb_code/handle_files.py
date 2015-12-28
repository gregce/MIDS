# -*- coding: utf-8 -*-
"""
Created on Sun Nov  1 12:56:54 2015

@author: ceccarelli
"""
import gzip
import glob
import os

class fileHandler(object):
    
    @staticmethod
    def unzip(self, source, dest, endswith='*.gz'):
        for src_name in glob.glob(os.path.join(source, endswith)):
            dest_name = os.path.join(dest, os.path.basename(src_name)[:-3])
            with gzip.open(src_name, 'rb') as infile:
                with open(dest_name, 'w') as outfile:
                    for line in infile:
                        outfile.write(line)
                        
    @staticmethod
    def cleanup(self, endswith='*.gz'):
        print "Are you sure you want to delete: " + '\n'.join(os.listdir(self.source, endswith)) + " ?"
        reply = raw_input(" Please confirm, y/[n]]" )
        if reply=='y': 
            for file in glob.glob(os.path.join(self.source, endswith)):
                 print 'Deleting file %s' % file
                 os.remove(file)
        else:
              print "Aborting..."

# %%

# fh = fileHandler.unzip(u'/Users/ceccarelli/MIDS/DATASCI_W205/w205-Course-Project/imdb_files',
#     u'/Users/ceccarelli/MIDS/DATASCI_W205/w205-Course-Project/imdb_files')

