---
author: admin
comments: true
date: 2012-04-15 20:43:05+00:00
layout: post
slug: installing-postgresql-on-os-x-lion
title: Installing PostgreSQL on OS X Lion (using homebrew)
wordpress_id: 287
categories:
- Tech
tags: ['post']
---

So I decided to switch from MySQL to PostgreSQL for my rails app (primarily because Heroku supports PostgreSQL) OS X Lions ships with psql (the client) but you still need to install the server manually. The easiest way is to just install it via homebrew, but unfortunately that wasn't a smooth process. The fact that this I've never used PostgreSQL before didn't help matters either. Here's a list of commands and hacks that I had to do to finally make it work.



	
  1. Install [homebrew](http://mxcl.github.com/homebrew/) if you haven't yet (worth installing even if you don't need PostgreSQL) Then do
``` bash
brew install postgres
``` 
	
  2. Ideally, that should be it, but in my case, it wasn't. The brew install failed for me because some mirror (ftp.kaist.ac.kr to be specific) was down. I worked around this by adding an entry to my hosts file and pointing this to a working mirror. Add the following line to your /etc/hosts file if you face the same issue 
``` bash
198.82.183.70 ftp.kaist.ac.kr
``` 

  3. The brew install will output a set of instructions for setting up/initializing the DB. The first is to run initdb as follows 
``` bash
initdb /usr/local/var/postgres 
``` 
No prizes for guessing that even this step failed for me :D I got the following error 
``` bash
creating template1 database in /usr/local/var/postgres/base/1 ... FATAL:  could not create shared memory segment: Cannot allocate memory
DETAIL:  Failed system call was shmget(key=1, size=2138112, 03600).
HINT:  This error usually means that PostgreSQL's request for a shared memory segment exceeded available memory or swap space, or exceeded your kernel's SHMALL parameter.  You can either reduce the request size or reconfigure the kernel with larger SHMALL.  To reduce the request size (currently 2138112 bytes), reduce PostgreSQL's shared memory usage, perhaps by reducing shared_buffers or max_connections.
	The PostgreSQL documentation contains more information about shared memory configuration.
child process exited with exit code 1
``` 
Thankfully, this seems to be a fairly common problem and there are solutions posted online. The following commands fixed the issue for me.
``` bash
sudo sysctl -w kern.sysv.shmall=65536
sudo sysctl -w kern.sysv.shmmax=16777216
``` 

  4. You can now start the PostgreSQL server (again follow the instructions from the brew install output) Specifically, look for the following lines and execute the appropriate commands
``` bash
Start/Stop PostgreSQL
If this is your first install, automatically load on login with:
  mkdir -p ~/Library/LaunchAgents
  cp /usr/local/Cellar/postgresql/9.1.3/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
If this is an upgrade and you already have the homebrew.mxcl.postgresql.plist loaded:
  launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
  cp /usr/local/Cellar/postgresql/9.1.3/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
Or start manually with:
  pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
And stop with:
  pg_ctl -D /usr/local/var/postgres stop -s -m fast
``` 

  5. Now try connecting with the client (using the psql command). This will also fail, as you can expect by now. You might see an error like follows
``` bash
$ psql
psql: could not connect to server: Permission denied
	Is the server running locally and accepting
	connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?
``` 
This usually happens because psql still points to the pre-installed client, not the one that homebrew installed. To fix this, just edit /etc/paths and place the brew install path (usually /usr/local/bin) above /usr/bin . This change does not get picked up automatically (you could force it by using the source command, or by just opening a new terminal window). Once this is done, verify that it's using the right path with a "which psql" command, or you can avoid all of this and just use the absolute path

  6. psql should finally work now, but will complain about a non-existent database. So first create a DB with the following command
``` bash
createdb <db_name>
``` 
psql by default creates a connection with the current terminal user as the username, and to a db with the same name as the username. You can however use the command line arguments -U and -d respectively to change them. Also, you can create a new user can with the following command
``` bash
createuser <username> -P
``` 
The -P option is to set a password for that user. 

If things still fail, take a look at the log file (/usr/local/var/postgres/server.log) for clues. 

Now, if you plan to use PostgreSQL with Ruby on Rails, there are a couple more steps involved. 

  1. Install the gem using the following command. If you installed it previously, uninstall it and install it again. 
``` bash
env ARCHFLAGS="-arch x86_64" gem install pg
``` 
Also, add the 'pg' gem to your Gemfile, and you can remove your existing DB adapter from it as well (mysql2 for MySQL)

  2. Change the following line in the relevant sections of your config/database.yml
``` 
  adapter: mysql2
``` 
to
``` 
  adapter: postgresql
``` 

Perform a rake:db migrate to create all the required tables for Rails to work. Seed the DB if you have to. Now restart your server and verify if everything works fine. In most cases, the switch should be fairly smooth, however there could be a few queries that might break. 
