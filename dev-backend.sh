#!/bin/bash
mkdir -p frontend/target/classes
export KAFKA_BOOTSTRAP_SERVERS=host.docker.internal:9092
export APICURIO_URL=http://host.docker.internal:8081/apis/registry/v2
echo "starting app in dev mode"
echo "!!! WARNING !!!"
echo "if another instance of your app is running concurrently, Kakfa messages might be distributed to both instances"
mvn -f backend/pom.xml clean compile quarkus:dev -DdebugHost=0.0.0.0 -Pno-resources