# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pyhs2
import pandas as pd

with pyhs2.connect(host='52.91.127.213',
               port=10000,
               authMechanism="PLAIN",
               user='root',
               database='default') as conn:
    with conn.cursor() as cur:
        #Show databases
        print cur.getDatabases()

        #Execute query
        cur.execute("select * from cp_title limit 10")

        #Return column info from query
        schema =  cur.getSchema()
        records = cur.fetchall()
        #Fetch table results
        #rows = pd.read_sql_query(cur.fetchall(), cur)       
        
        #for i in cur.fetch():
        #    print i
        cols = []
        for i in range(0,len(schema)):
             cols.append(schema[i].values()[1])
        
df=pd.DataFrame(records,columns=cols)


