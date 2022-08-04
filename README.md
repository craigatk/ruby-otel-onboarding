# Ruby OpenTelemtry onboarding demo

Example app used for onboarding to OpenTelemetry for the first time with Ruby. Built by a Ruby n00b (me).

Disclaimer: some of the gems this app uses may be missing from the `Gemfile` and may need to be added.

## Startup

Start MySQL

```
docker-compose up
```

In the MySql console - create the database:

```
CREATE DATABASE plants;
```

Start the app

```
ruby app.rb
```

## Database

Connect to database:

```
mysql --user=root --port=3308 --password=example
```

# Resources

* https://github.com/sinatra/sinatra
* https://stackoverflow.com/questions/16683903/sinatra-mysql-and-activerecord
  * https://stackoverflow.com/a/5494410
  * https://guides.rubyonrails.org/active_record_basics.html
* https://hub.docker.com/_/mysql
* https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html
