#make an hdfs directory
hdfs dfs -mkdir -p /root/persist/data/cp_imdb_db/

for file in "movie_companies" "company_name" "char_name" "cast_info" "aka_title" "person_info" \
    "name" "aka_name" "movie_keyword" "keyword" "movie_link" "movie_info_idx" \
    "movie_info" "title" "complete_cast";
do
  # mkdirs for each file
  hdfs dfs -mkdir /root/persist/data/cp_imdb_db/${file}/

  # put files into hadoop
  hdfs dfs -put ${file}.csv /root/persist/data/cp_imdb_db/${file}/
done
