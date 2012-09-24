cache: varnishd -f config/varnish.vcl -F -a :$PORT -s malloc,64m
# db: postgres -D /usr/local/var/postgres/emil_kampp
db: mongod run --config config/mongod.conf
web: bundle exec puma -p $PORT -t 1:16 -e development
redis: redis-server config/redis.conf
