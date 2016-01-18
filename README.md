# Scale mysql queries

Basically I look for different solutions to make faster queries with 
10 millions of rows filtering with %john%. 

1. First solution: creating the table and make the simple query to check
the performance.

2. Second solution: check the same solution with another engine

3. Third solution: change to fulltext to increase the searchs although the last
engine supports it natively in the latest MySQL versions

4. Four solution: load the search in a elastic search to make faster queries

# Steps to test it

## Create the my.cnf

```
[client]
# The following password will be sent to all standard MySQL clients
password="my_password"

# chmod +R 755 create_load_database.sh

# ./create_load_database.sh
```
