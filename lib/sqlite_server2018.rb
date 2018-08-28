#!/usr/bin/env ruby

# file: sqlite_server2018.rb

require 'drb'
require 'sqlite3'
require 'hashcache'


class SQLiteServer
  include SQLite3
  
  def initialize(cache: 5, debug: false)
    
    @dbcache = HashCache.new(cache: cache)
    @h = {}
    @debug = debug
    
  end
  
  def execute(dbfile, *args, &blk)
    
    p 'dbfile: ' + dbfile if @debug
    db = Database.new dbfile
    
    if @debug then
      p 'db: ' + db.inspect
      p 'args: ' + args.inspect
    end
    
    begin      
      read(dbfile).execute(*args, &blk)
    rescue
      ($!).inspect
    end

  end
  
  def load(dbfile)
    read dbfile
    'loaded'
  end
  
  def query(*args, &blk)
    
    begin
      read(dbfile).query(*args, &blk)
    rescue
      ($!).inspect
    end
    
  end  
  
  private
  
  def read(dbfile)
    @dbcache.read(dbfile) { Database.new dbfile }
  end
  
end

class SQLiteServer2018

  def initialize(host: 'localhost', port: '57000', cache: 5)

    @host, @port, @cache = host, port, cache

  end

  def start()
    
    DRb.start_service "druby://#{@host}:#{@port}", 
        SQLiteServer.new(cache: @cache)
    DRb.thread.join

  end  
end

