#make an hdfs directory
hadoop dfs -mkdir -p /user/gregce/hospital_compare/

#grab the correct files
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/Hospital\ General\ Information.csv > /usr/local/w205-hw/exercise_1/loading_and_modeling/hospitals.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/Timely\ and\ Effective\ Care\ -\ Hospital.csv > /usr/local/w205-hw/exercise_1/loading_and_modeling/effective_care.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/Readmissions\ and\ Deaths\ -\ Hospital.csv  > /usr/local/w205-hw/exercise_1/loading_and_modeling/readmissions.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/Measure\ Dates.csv  > /usr/local/w205-hw/exercise_1/loading_and_modeling/measuredates.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/hvbp_hcahps_05_28_2015.csv  > /usr/local/w205-hw/exercise_1/loading_and_modeling/hosp_patientexperience.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/hvbp_tps_05_28_2015.csv  > /usr/local/w205-hw/exercise_1/loading_and_modeling/hosp_totalperformance.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/READMISSION\ REDUCTION.csv  > /usr/local/w205-hw/exercise_1/loading_and_modeling/readmissionreduction.csv
tail -n +2 /usr/local/Hospital_Revised_Flatfiles/HCAHPS\ -\ Hospital.csv  > /usr/local/w205-hw/exercise_1/loading_and_modeling/hosp_surveys.csv

#put files into hadoop
hdfs dfs -put hospitals.csv /user/gregce/hospital_compare/
hdfs dfs -put effective_care.csv /user/gregce/hospital_compare/
hdfs dfs -put readmissions.csv /user/gregce/hospital_compare/
hdfs dfs -put measuredates.csv /user/gregce/hospital_compare/
hdfs dfs -put hosp_patientexperience.csv /user/gregce/hospital_compare/
hdfs dfs -put hosp_totalperformance.csv /user/gregce/hospital_compare/
hdfs dfs -put readmissionreduction.csv /user/gregce/hospital_compare/
hdfs dfs -put hosp_surveys.csv /user/gregce/hospital_compare/

##mkdirs for each file
hdfs dfs -mkdir /user/gregce/hospital_compare/effective_care/
hdfs dfs -mkdir /user/gregce/hospital_compare/hospitals/
hdfs dfs -mkdir /user/gregce/hospital_compare/readmissions/
hdfs dfs -mkdir /user/gregce/hospital_compare/measuredates/
hdfs dfs -mkdir /user/gregce/hospital_compare/hosp_patientexperience/
hdfs dfs -mkdir /user/gregce/hospital_compare/hosp_totalperformance/
hdfs dfs -mkdir /user/gregce/hospital_compare/readmissionreduction/
hdfs dfs -mkdir /user/gregce/hospital_compare/hosp_surveys/

#move files each into their own directory
hdfs dfs -mv /user/gregce/hospital_compare/effective_care.csv /user/gregce/hospital_compare/effective_care/
hdfs dfs -mv /user/gregce/hospital_compare/hospitals.csv /user/gregce/hospital_compare/hospitals/
hdfs dfs -mv /user/gregce/hospital_compare/readmissions.csv /user/gregce/hospital_compare/readmissions/
hdfs dfs -mv /user/gregce/hospital_compare/measuredates.csv /user/gregce/hospital_compare/measuredates/
hdfs dfs -mv /user/gregce/hospital_compare/hosp_patientexperience.csv /user/gregce/hospital_compare/hosp_patientexperience/
hdfs dfs -mv /user/gregce/hospital_compare/hosp_totalperformance.csv /user/gregce/hospital_compare/hosp_totalperformance/
hdfs dfs -mv /user/gregce/hospital_compare/readmissionreduction.csv /user/gregce/hospital_compare/readmissionreduction/
hdfs dfs -mv /user/gregce/hospital_compare/hosp_surveys.csv /user/gregce/hospital_compare/hosp_surveys/

#remove files from working dir
rm *.csv
