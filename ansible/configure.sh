#!/bin/bash

db=$1
cd /tmp
git clone https://github.com/hassanejaz/java-app.git
cd java-app/build/libs/
psql "postgresql://postgres:postgres@"${db}"" -c 'CREATE DATABASE helloworld'
sudo java -jar interview-helloworld.jar this-is-a-non-option-arg --DATABASE_HOST="${db}"
