## Interacting with a Database

The [`database.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/database/database.feature) file assumes you have [Homebrew](https://brew.sh/) installed.  It also assumes you have Postgresql installed locally, with a database ("testdb") created and login credentials configured (user: 'newuser'; password: 'password'): 

```
$ brew install postgresql
$ psql postgres

  postgres=# CREATE ROLE newuser WITH LOGIN PASSWORD 'password'
  postgres=# ALTER ROLE newuser CREATEDB
  postgres=# CREATE DATABASE testdb
```

This database can be started & stopped using [`startdatabase.sh`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/database/startdatabase.sh) and [`stopdatabase.sh`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/database/stopdatabase.sh), respectively. 

Once the database is started, the `database.feature` file can be used to create a new table, add some rows to it, query & update those rows, delete those rows, and finally, drop the table -- all using plain SQL thanks to the [`DbUtils`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/database/helpers/DbUtils.java) helper class. 
