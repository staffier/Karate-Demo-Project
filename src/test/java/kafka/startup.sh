#!/bin/bash

## Start up a single single Kafka broker (along with Zookeeper) and create a topic called test-topic
docker-compose -f kafka-single-broker.yml up -d
docker ps
echo "*** sleeping for 15 seconds (give time for containers to spin up)"
sleep 15
