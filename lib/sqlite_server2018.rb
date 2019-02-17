#!/usr/bin/env ruby

# file: sqlite_server2018.rb

require 'drb'
require 'sqlite3'
require 'rxfhelper'
require 'hashcache'


class SQLiteServer
  include SQLite3
  
  def initialize(cache: 5, debug: false, filepath: '.')
    
    @dbcache = HashCache.new(cache: cache)
    @h = {}
    @debug = debug
    Dir.chdir filepath    
    
  end
  
  def execute(dbfile, *args, &blk)
    
    p 'dbfile: ' + dbfile if @debug
    
    if @debug then
      p 'db: ' + db.inspect
      p 'args: ' + args.inspect
    end
    
    begin      
      
      r = read(dbfile).execute(*args).map(&:to_a)
      blk ? r.each {|*x| blk.call(*x) } : r

    rescue
      'SQLiteServerError: ' + ($!).inspect
    end

  end
  
  def exists?(raw_dbfile)
    
    dbfile = if raw_dbfile =~ /^sqlite:\/\// then    
      raw_dbfile[/^sqlite:\/\/[^\/]+\/(.*)/,1]
    else
      raw_dbfile      
    end
    
    File.exists? dbfile
  end
  
  def load_db(dbfile)
    read dbfile
    'loaded ' + dbfile
  end
  
  def ping()
    :pong
  end
  
  def query(dbfile, *args, &blk)
    
    begin
      r = read(dbfile).query(*args).map(&:to_a)
      blk ? r.each {|*x| blk.call(*x) } : r      
    rescue
      'SQLiteServerError: ' + ($!).inspect
    end
    
  end  
  
  private
  
  def read(dbfile)
    @dbcache.read(dbfile) { Database.new dbfile }
  end
  
end

class SQLiteServer2018

  def initialize(host: 'localhost', port: '57000', cache: 5, 
                 debug: false, filepath: '.')

    @host, @port, @cache, @filepath = host, port, cache, filepath

  end

  def start()
    
    DRb.start_service "druby://#{@host}:#{@port}", 
        SQLiteServer.new(cache: @cache, debug: @debug, filepath: @filepath)
    DRb.thread.join

  end  
end
