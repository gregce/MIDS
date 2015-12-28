An extensive summary of steps taken is available in the Architecture.pdf, follow below for the general outline of what to do

1. If you're reading this, it is assumed that you have already:
   Created an EC2 instance based on the ucbw205_complete_plus_postgres_PY2.7 AMI and,
   Cloned the git@github.com:gregce/EX2Tweetwordcount.git to /root

2. Execute the following sh scripts from /root/EX2Tweetwordcount/ami_setup/ 
   setup_ucb_complete_plus_postgres.sh
   setup_conda.sh
   setup_lein.sh
   setup_postgres.sh

3. Ensure you've set the requisite env variables (so you get the write version of python) with 
   source /root/EX2Tweetwordcount/ami_setup/.bashrc

4. Open another terminal session (so you can run the application and simultaneously query it) and make sure to run "source /root/EX2Tweetwordcount/ami_setup/.bashrc"

5. In session 1, issue "sparse run" from /root/EX2Tweetwordcount/

6. In session 2, wait a couple minutes (1-2)  and then run "python /root/EX2Tweetwordcount/serving/finalresults.py the"
   
7. At this point the application should be working, refer to the Architecture.pdf found in this diretory with any questions re assumptions

