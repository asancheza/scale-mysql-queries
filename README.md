Basically I look for different solutions to make faster queries with 
10 millions of rows filtering with %john%. 

First solution: creating the table and make the simple query to check
the performance.

Second solution: check the same solution with another engine

Third solution: change to fulltext to increase the searchs although the last
engine supports it natively in the latest MySQL versions

Four solution: load the search in a elastic search to make faster queries

## Steps to test it

# Create the my.cnf

[client]
# The following password will be sent to all standard MySQL clients
password="my_password"

# chmod +R 755 create_load_database.sh

# ./create_load_database.sh
