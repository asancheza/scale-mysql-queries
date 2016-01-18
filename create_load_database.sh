#!/bin/bash

# Alias with your mysql binary client
MYSQLPATH=/Applications/XAMPP/bin/
DATABASE=sample

# Drop database

$MYSQLPATH/mysql -u root -e "DROP DATABASE "$DATABASE
$MYSQLPATH/mysql -u root -e "CREATE DATABASE IF NOT EXISTS "$DATABASE" CHARACTER SET utf8 COLLATE utf8_general_ci" > users.sql

echo "CREATE TABLE IF NOT EXISTS users (
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  PRIMARY KEY(id)
);" >> users.sql

# Configure before the my.cnf to not prompt a password
$MYSQLPATH/mysql -u root $DATABASE < users.sql

rm -rf users_data.sql

for i in `seq 1 50`
do
  for j in `cat /usr/share/dict/words`
  do
    echo "INSERT INTO users (full_name, email, city) VALUES ('"$i$j"', '"$i$j"@example.com', 'San Francisco');" >> users_data.sql
  done
done

cat users_data.sql | $MYSQLPATH/mysql -u root sample

# Optimize engine
$MYSQLPATH/mysql -u root -D sample -e "ALTER TABLE users ENGINE=InnoDB"

# Time
# time $MYSQLPATH/mysql -u root -D sample -e 'SELECT * from users where full_name like "%john%"' 
$MYSQLPATH/mysql -u root -vv -D sample -e 'SELECT * from users where full_name like "%john%"' 

$MYSQLPATH/mysql -u root -vv -D sample -e 'ALTER TABLE users ADD INDEX full_name (full_name)'
$MYSQLPATH/mysql -u root -vv -D sample -e 'SHOW index FROM users'

#time $MYSQLPATH/mysql -u root -D sample -e 'SELECT * from users where full_name like "%john%"' 
$MYSQLPATH/mysql -u root -vv -D sample -e 'SELECT * from users where full_name like "%john%"' 

# In memory
$MYSQLPATH/mysql -u root -D sample -e "ALTER TABLE users ENGINE = MEMORY"
#time $MYSQLPATH/mysql -u root -D sample -e 'SELECT * from users where full_name like "%john%"'
$MYSQLPATH/mysql -u root -vv -D sample -e 'SELECT full_name from users where full_name like "%john%"'

# Partition database
$MYSQLPATH/mysql -u root -p -vv -D sample -e "ALTER TABLE t1 PARTITION BY HASH(id) PARTITIONS 100"
$MYSQLPATH/mysql -u root -vv -D sample -e 'SELECT full_name from users where full_name like "%john%"'

# Logstash to elastic search and queries from elastic search
logstash -f simple-out.conf 
# curl http://localhost:9200/users/user/5?pretty
curl -XGET 'http://localhost:9200/contacts/_search?q=full_name:john'

