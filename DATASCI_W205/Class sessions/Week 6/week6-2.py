
# coding: utf-8

# 

# ##Lets get started
# 
# Go to SparkHome/bin and run ./pyspark
# 
# You should see:
# 
# ```
# Welcome to
#       ____              __
#      / __/__  ___ _____/ /__
#     _\ \/ _ \/ _ `/ __/  '_/
#    /__ / .__/\_,_/_/ /_/\_\   version 1.3.1
#       /_/
# 
# Using Python version 2.7.6 (v2.7.6:3a1db0d2747e, Nov 10 2013 00:42:54)
# 
# ```
# 

# In[ ]:

./pyspark
chmod +x pyspark


# In[ ]:

# print Spark version
print("pyspark version:" + str(sc.version))


# ## Once you run PySpark, it defines a Spark context object (sc) and a SQL conext (sqlCtx)
# #
# #

# In[ ]:

sc


# 

# 
# 

# In[ ]:

rdd=sc.parallelize(range(1,1000))
rdd


# In[ ]:



# In[ ]:

# take
x = sc.parallelize([1,2,3,4,5])
y = x.take(num = 3)
print(y)


# ###rdd.collect()` converts a RDD object into a Python list on the host machine. i.e get all the values in an RDD
# #

# In[ ]:

# collect

x = sc.parallelize([1,2,3,4,5])
y = x.collect()
print(y)  # not distributed



# In[ ]:

# first
y = x.first()
print(y)


# In[ ]:

# filter
y = x.filter(lambda x: x%2 == 1)  # filters out even elements
print(y.collect())



# In[ ]:

# map
y = x.map(lambda x: (x,x**2))
y.collect()



# In[ ]:

# flatMap
x = sc.parallelize([1,2,3,4,5])
y1 = x.map(lambda x: (x, 100*x, x**2))
y2 = x.flatMap(lambda x: (x, 100*x, x**2))
print(x.collect())
print(y1.collect())
print(y2.collect())





# In[ ]:

# reduce
y = x.reduce(lambda obj, accumulated: obj + accumulated)  # computes a cumulative sum
print(y)


# In[ ]:

# reduceByKey
x = sc.parallelize([('B',1),('B',2),('A',3),('A',4),('A',5)])
y = x.reduceByKey(lambda v1, v2: v1 + v2)
print(y.collect())


# ##MapReduce

# In[ ]:

x.map(lambda gender:(data[1],1).reduceByKey(lambda x,y:(x+y)).collect()


# In[ ]:




# In[ ]:

# union
x = sc.parallelize(['A','A','B'])
y = sc.parallelize(['D','C','A'])
z = x.union(y)
print(z.collect())


# In[ ]:




# ##Reading from Files

# In[ ]:

inputTxt=sc.textFile("austen-sense.txt")


# ##Each line is a separate element in the RDD

# In[ ]:

inputTxt.take(10)


# ##Saving to Files

# 
# `.saveAsTextFile()` saves an RDD as a string. there is also `.saveAsPickleFile()`.
# 
# `.rsaveAsNewAPIHadoopDataset()` saves an RDD object to HDFS.

# ##Reading inputs from S3 and counting the words
# #
# 

# In[ ]:

#text = sc.textFile("s3://YOUR_S3_BUCKET/austen-sense.txt")

text=sc.textFile("austen-sense.txt")





# In[ ]:

lines	=	sc.textFile("mytext",	5)	
comments	=	lines.filter(myFunc)	
print	lines.count()
print   comments.count()	


# ## How to solve this problem?

# In[ ]:

lines	=	sc.textFile("mytext",	5)	
lines.cache()	#	save,	don't	recompute!	
comments	=	lines.filter(myFunc)	
print	lines.count(),comments.count()	


# Spark Program Lifecycle
# 1. Create RDDs from external data or parallelize a
# collection in your driver program
# 2. Lazily transform them into new RDDs
# 3. cache() some RDDs for reuse
# 4. Perform actions to execute parallel
# computation and produce results

# 

# In[ ]:

words = text.flatMap(lambda line: line.split())             .map(lambda word: word.lower())


# In[ ]:

words.take(10)


# In[ ]:

mapw=words.map(lambda word: (word, 1))
               


# In[ ]:

mapw.take(3)


# In[ ]:

count=mapw.reduceByKey(lambda x,y: x + y)


# In[ ]:

count.take(3)


# In[ ]:

def wordcounts(words_rdd):
    return words_rdd.map(lambda word: (word, 1))                 .reduceByKey(lambda x,y: x + y)                 .sortByKey(False)
                #.map(lambda (word, count): (count, word)) \


# In[ ]:

wordcounts(words).take(10)


# In[ ]:




# In[ ]:

sc


# In[ ]:




# ##How do I write a program that uses Spark

# In[ ]:

from pyspark import SparkContext, SparkConf

#Optional Config
ProgramName="Myp"
master="local"
config = SparkConf().setAppName(ProgramName).setMaster(master)


sc = SparkContext(conf=config)


# In[ ]:

get_ipython().system(u'cat student.py')


# In[ ]:

./pyspark --py-files student.py


# In[ ]:

sc


# In[ ]:

import student


# In[ ]:

get_ipython().system(u'cat records.txt')


# In[ ]:

students=sc.textFile("records.txt")


# In[ ]:

students.take(10)


# In[ ]:

students=sc.textFile("records.txt").map(lambda rec: student.Student().parse(rec))


# In[ ]:

students.first()


# In[ ]:

P_Group=students.map(lambda p: (p.program,1)).reduceByKey(lambda x,y: x + y)


# In[ ]:

P_Group.collect()


# In[ ]:




# #Joins#: Gets 2 RDDs (k,v1),(k,v2) and create a joined RDD (k,(v1,v2))

# In[ ]:

students_courses=[("Alex","w205"),("Mike","info290"),("Ross","w205")]


# In[ ]:

program_rec=[("Alex","MIDS"),("Mike","MIMS"),("Ross","MIDS")]


# In[ ]:

SC_rdd=sc.parallelize(students_courses)


# In[ ]:

P_rdd=sc.parallelize(program_rec)


# In[ ]:

Comp_rec=SC_rdd.join(P_rdd)


# In[ ]:

Comp_rec.collect()


# In[ ]:




# ## DataTables: RDDs with Schema
# 
# -Similar to Tables in SQL
# 
# -Are python objects without methods that you can have access to field
# 
# -All rows in DataTables should have the same types such as JSON objects with the same fields (opposite to RDDs)
# Could have rows with null or arrays
# 
# 
# -The schema can be from semi-structured files such as JSONs but you can enforce a schema if you do not have it in the input.
# 
# -No code translation. Most of its codes are executed in Scala and you do not pay the perfromace overhead that pyspark has excpet the small initial requests/getting the results- -There is query optimizer that you can use which does not use the python interface-no overhead except for showing the results
# 
# 

# In[ ]:

get_ipython().system(u'cat records.json')


# In[ ]:

students=sqlCtx.jsonFile("records.json")



# #Generates some folders and files to keep track of schemas,...

# ##students is an RDD and you can do all the stuff that you did with RDDs but..

# In[ ]:

students.show()  #the first 20 rows in the context


# In[ ]:

students.select('program').show()


# In[ ]:

students.select(students.program).show()


# In[ ]:

students.filter(students.age > 27).show()


# ##Since it uses a variation of DataFrame

# In[ ]:

students[students.program == 'MIDS'].show()


# In[ ]:

students.groupBy(students.program).count().show()


# In[ ]:

students.groupBy(students.program).avg('age').show()


# In[ ]:




# In[ ]:




# #Like SQL more? You can run SQL in Spark

# In[ ]:

students.registerTempTable("st")


# In[ ]:

sqlCtx.sql("select name, program FROM st").show()


# In[ ]:




# In[ ]:

sqlCtx.sql("select program,avg(age) AS AverageAge FROM st GROUP BY program").show()


# In[ ]:




# In[ ]:

from pyspark.sql import functions as funcs

AvgMin=students.groupBy('program').agg(funcs.avg('age').alias('AverageAge '),funcs.max('age').alias('MaximumAge'))

AvgMin.show()


# In[ ]:




# #How the queries are optimized

# In[ ]:

sqlCtx.sql("select name, program FROM st").explain()


# In[ ]:




# In[ ]:



