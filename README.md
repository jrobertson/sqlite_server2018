# Introducing the drb_sqlite gem

## Setting up the server

### installation

`gem install sqlite_server2018`

    require 'sqlite_server2018'

    SQLiteServer2018.new(host: '127.0.0.1').start

## Using the client

    require 'drb_sqlite'

    # Open a database
    db = DRbSQLite.new 'test.db'

    # Create a database
    sql=<<-SQL
      create table numbers (
        name varchar(30),
        val int
      );
    SQL
    rows = db.execute sql

    # Execute a few inserts
    {
      "one" => 1,
      "two" => 2,
    }.each do |pair|
      db.execute "insert into numbers values ( ?, ? )", pair
    end

    # Find a few rows
    db.execute( "select * from numbers" ) do |row|
      p row
    end

Observed:

<pre>
["one", 1]
["two", 2]
</pre>

## Resources

* sqlite_server2018 https://rubygems.org/gems/sqlite_server2018
* drb_sqlite https://rubygems.org/gems/drb_sqlite

sqlite sqlite3 gem drb_sqlite3 server sqlite_server2017 sql
