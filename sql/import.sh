#!/bin/sh

sleep 10

ls /sql
echo '================================'
echo '$MYSQL_HOST='"'$MYSQL_HOST'"
echo '$MYSQL_USER='"'$MYSQL_USER'"
echo '$MYSQL_PASSWORD='"'$MYSQL_PASSWORD'"
echo '$RABBITMQ_HOST='"'$RABBITMQ_HOST'"
echo '$RABBITMQ_DEFAULT_USER='"'$RABBITMQ_DEFAULT_USER'"
echo '$RABBITMQ_DEFAULT_PASS='"'$RABBITMQ_DEFAULT_PASS'"
echo '$RABBITMQ_DEFAULT_VHOST='"'$RABBITMQ_DEFAULT_VHOST'"
echo '$HTTP_API_URL='"'$HTTP_API_URL'"
echo '$HTTP_API_KEY='"'$HTTP_API_KEY'"
echo '================================'

mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST -e 'create database Gamemaster;'
mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST --database=Gamemaster < /sql/Gamemaster.sql

mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST -e 'create database GameTracker;'
mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST --database=GameTracker < /sql/GameTracker.sql

mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST -e 'create database KeyMaster;'
mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST --database=KeyMaster < /sql/KeyMaster.sql

mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST -e 'create database Peerchat;'
mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST --database=Peerchat < /sql/Peerchat.sql

mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_HOST --database=GameTracker < /sql/user_seed.sql


python3 /sql/rabbitmqadmin declare exchange -H $RABBITMQ_HOST --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS --vhost=$RABBITMQ_DEFAULT_VHOST name=openspy.core type=topic durable=true
python3 /sql/rabbitmqadmin declare exchange -H $RABBITMQ_HOST --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS --vhost=$RABBITMQ_DEFAULT_VHOST name=openspy.master type=topic durable=true
python3 /sql/rabbitmqadmin declare exchange -H $RABBITMQ_HOST --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS --vhost=$RABBITMQ_DEFAULT_VHOST name=openspy.natneg type=topic durable=true
python3 /sql/rabbitmqadmin declare exchange -H $RABBITMQ_HOST --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS --vhost=$RABBITMQ_DEFAULT_VHOST name=openspy.gamestats type=topic durable=true
python3 /sql/rabbitmqadmin declare exchange -H $RABBITMQ_HOST --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS --vhost=$RABBITMQ_DEFAULT_VHOST name=presence.core type=topic durable=true
python3 /sql/rabbitmqadmin declare exchange -H $RABBITMQ_HOST --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS --vhost=$RABBITMQ_DEFAULT_VHOST name=peerchat.core type=topic durable=true


curl -X POST "http://$HTTP_API_URL/v1/Game/SyncToRedis" -d "" -H "accept: application/json" -H "APIKey: $HTTP_API_KEY"
curl -X POST "http://$HTTP_API_URL/v1/Group/SyncToRedis" -d "" -H "accept: application/json" -H "APIKey: $HTTP_API_KEY"
