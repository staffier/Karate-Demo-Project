Feature: Database querying & updates with Karate

  DB name  = testdb
  User     = newuser
  Password = password

  $ brew services restart postgresql
  $ psql postgres

  postgres=# CREATE ROLE newuser WITH LOGIN PASSWORD 'password'
  postgres=# ALTER ROLE newuser CREATEDB
  postgres=# CREATE DATABASE testdb

  Background:
    * def config = { username: 'newuser', password: 'password', url: 'jdbc:postgresql://localhost:5432/postgres', driverClassName: 'org.postgresql.Driver' }
    * def DbUtils = Java.type('database.helpers.DbUtils')
    * def db = new DbUtils(config)

  Scenario: Create a table
    * def createTable = db.editRows("CREATE TABLE Persons (PersonID int, LastName varchar(255), FirstName varchar(255))")
    * def tables = db.readRows("SELECT * FROM pg_catalog.pg_tables")
    * print tables
    * match tables contains deep { "tablename": "persons", "tableowner": "newuser" }
    * match tables[*].tablename contains "persons"

  Scenario: Add rows to the table
    * text rows =
      """
      INSERT INTO Persons (PersonID, LastName, FirstName)
      VALUES (1, 'McGee', 'Bobby'), (2, 'May', 'Maggie'), (3, 'Claypool', 'Les')
      """
    * db.editRows(rows)

  Scenario: Query the table
    * def query = db.readRows("SELECT * from Persons")
    * print query
    # 'match ==' works even with keys out of order:
    * match query ==
      """
      [
        { "firstname": "Bobby", "personid": 1, "lastname": "McGee" },
        { "personid": 2, "lastname": "May", "firstname": "Maggie" },
        { "lastname": "Claypool", "firstname": "Les", "personid": 3 }
      ]
      """
    # 'match contains' works even with rows (and keys) out of order:
    * match query contains
      """
      [
        { "personid": 2, "lastname": "May", "firstname": "Maggie" },
        { "lastname": "Claypool", "firstname": "Les", "personid": 3 },
        { "firstname": "Bobby", "personid": 1, "lastname": "McGee" }
      ]
      """
    # ...or you could use 'match ==' with 'query[0]' to validate the array is exactly equal to your expected results without worrying about the order of things:
    * match query[0] ==
      """
        { "firstname": "Bobby", "personid": 1, "lastname": "McGee" },
        { "lastname": "Claypool", "firstname": "Les", "personid": 3 },
        { "personid": 2, "lastname": "May", "firstname": "Maggie" }
      """
    # 'match contains deep' to look for a couple keys within one of three objects:
    * match query contains deep { "personid": 1, "lastname": "McGee" }
    # fuzzy matchers:
    * match query contains [ "#object", { "personid": "#present", "lastname": "#string", "firstname": "#notnull" } ]

  Scenario: Update the table
    * def update = db.editRows("UPDATE Persons SET LastName = 'LaLonde', FirstName = 'Larry' WHERE PersonID = 3")
    * def query = db.readRows("SELECT * from Persons")
    * print query
    * match query contains { "personid": 3, "lastname": "LaLonde", "firstname": "Larry" }

  Scenario: Delete all records in the table
    * def delete = db.editRows("DELETE FROM Persons")
    * def query = db.readRows("SELECT * from Persons")
    * print query
    * match query == []

  Scenario: Drop the table
    * def dropTable = db.editRows("DROP TABLE Persons")
    * def tables = db.readRows("SELECT * FROM pg_catalog.pg_tables")
    * match tables !contains { "tablename": "persons", "tableowner": "newuser" }
    * match tables[*].tablename !contains "persons"
