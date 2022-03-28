## Interacting with a Database

The [`database.feature`]() file assumed you have Postgresql installed locally, with a database ("testdb") created and login credentials configured (user: 'newuser'; password: 'password'). 

```
$ brew install postgresql
$ psql postgres

  postgres=# CREATE ROLE newuser WITH LOGIN PASSWORD 'password'
  postgres=# ALTER ROLE newuser CREATEDB
  postgres=# CREATE DATABASE testdb
```

This database can be started & stopped using [`startdatabase.sh`]() and [`stopdatabase.sh`](), respectively. 
