#!/bin/bash

DBNAME=${MYSQL_DATABASE}

HOSTNAME=${MYSQL_HOST}

PASSWORD=${MYSQL_ROOT_PASSWORD}

PORT=${MYSQL_PORT}

USERNAME=root

LOCK_PATH=/root/created_database

curl ${HOSTNAME}:${PORT}
curl ${LIVE_SERVICE_HOST}:${LIVE_SERVICE_PORT}
curl ${SERVICE_NAME}
echo $HOSTNAME
echo $PORT
echo $DBNAME

LOGIN_CMD="mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD}"

echo "${LOGIN_CMD}"

create_database() {
    echo "create database ${DBNAME}"
    create_db_sql="create database if not exists ${DBNAME} character set utf8"
    echo "${create_db_sql}" | ${LOGIN_CMD}

    if [ $? -ne 0 ]
    then
        echo "create database ${DBNAME} failed..."
        exit 1
    else
        echo "succeed to create database ${DBNAME}"
    fi
}

Generate_lock_file(){
    mount | grep ${LOCK_PATH} > /dev/null
    if [[ $? != 0 ]];then
        echo -e "\033[43;37m[ WARN ]\033[0m The lock path in which the lock file must be persisted! Check \$LOCK_PATH"
    fi
    echo -e "\033[42;37m[ INFO ]\033[0m Generating the lock file ${LOCK_PATH}/.datainited"
    touch ${LOCK_PATH}/.datainited
}

if [[ ! -f ${LOCK_PATH}/.datainited ]];then
    create_database && Generate_lock_file
else
    echo -e "\033[42;37m[ INFO ]\033[0m The data has already been initialized, skiping..."
fi

