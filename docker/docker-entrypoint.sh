#!/bin/sh
echo "hello world"

echo $1

ES_DB="elasticsearch"
ES_PORT="9200"
DB_NAME="kibble"
MAILHOST="127.0.0.1:25"
SHARDS="5"
REPLICA="1"

echo "wait for ES"

result=$(curl --head --write-out %{http_code} --silent --output /dev/null $1)

echo $result

while [ $result != "200" ]
do
  sleep 5
  echo $result
  result=$(curl --head --write-out %{http_code} --silent --output /dev/null $1)
done
break


cd /var/www/kibble/setup/
python3 setup.py --skiponexist --autoadmin -e $ES_DB -p $ES_PORT -d $DB_NAME -m $MAILHOST -s $SHARDS -r $REPLICA

cd /var/www/kibble/api/
gunicorn3 -w 10 -b 127.0.0.1:8000 handler:application -t 120 -D

apachectl -D FOREGROUND
