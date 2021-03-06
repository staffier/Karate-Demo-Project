## Introduction

**Please note: This demo was sourced from Soumendra Daas's Karate-Kafka project: https://github.com/Sdaas/karate-kafka**

This project provides a library to test Kafka applications using KarateDSL. It provides a `KafkaProducer` and
a `KafkaConsumer` that can be called from a Karate feature. An example:

```cucumber
Feature: Kafka Producer and Consumer Demo

  Background:
    * def KafkaProducer = Java.type('kafka.KarateKafkaProducer')
    * def KafkaConsumer = Java.type('kafka.KarateKafkaConsumer')
    * def topic = 'test-topic'

  Scenario: Write messages to test-topic and read it back

    * def kp = new KafkaProducer()
    * def props = KafkaConsumer.getDefaultProperties()
    * def kc = new KafkaConsumer(topic,props)
    * def key = "message_key"
    * def value =
    """
    {
      person : {
          firstName : "Santa",
          lastName : "Claus"
          },
      location : "North Pole"
    }
    """
    * def headers = { x-header-one : "header-one-value", x-header-two : "header-two-value" }
    * kp.send(topic, key, value,headers);

    # Read from the consumer
    * json out = kc.take()

    * kp.close()
    * kc.close()

    # Match
    * match out.key == "message_key"
    * match out.value.person.firstName == 'Santa'
    * match out.headers contains { "x-header-one": "header-one-value" }
    * match out.headers contains { "x-header-two": "header-two-value" }
```
## Quick Demo

Start up a single-node Kafka cluster locally with a topic called `test-topic`. Running
`KafkaRunner` will invoke [`src/test/java/kafka/kafka-demo.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/kafka/kafka-demo.feature) which will attempt to
write a few messages to this topic and read it back. Finally, shut down the Kafka cluster.

```
$ ./startup.sh   
$ mvn test -Dtest=KafkaRunner  
$ ./teardown.sh  
```

## Documentation
### Using this in your project

Add the following to your `pom.xml` :
```xml
<dependency>
    <groupId>com.daasworld</groupId>
    <artifactId>karate-kafka</artifactId>
    <version>0.1.2</version>
</dependency>
```
and
```xml
<repositories>
    <repository>
        <id>karate-kafka</id>
        <url>https://raw.github.com/sdaas/karate-kafka/mvn-repo/</url>
    </repository>
</repositories>

```
### Kafka Producer

Creating a Kafka producer with the default properties ...
```cucumber
* def kp = new KafkaProducer()
```
Get the default KafkaProducer properties
```cucumber
* def props = KafkaProducer.getDefaultProperties()
```
The following default properties are used to create the producer. 
```
{
  "bootstrap.servers": "127.0.0.1:9092",
  "value.serializer": "kafka.MyGenericSerializer",
  "key.serializer": "kafka.MyGenericSerializer",
  "linger.ms": "20",
  "max.in.flight.requests.per.connection": "5",
  "batch.size": "32768",
  "enable.idempotence": "true",
  "compression.type": "snappy",
  "acks": "all"
}
```
The `kafka.MyGenericSerializer` tries
to automatically guess the key/value type and attempts to serialize it as `Integer`, `Long`, `String`, or `JSON` 
based on the input. These default properties should work most of the time for testing, but you can always
override them ...

Overriding the default Properties
```cucumber
* def prop = { ... } 
* def kp = new KafkaProducer(prop)


```
Producing a message with or without a key
```cucumber
* kp.send(topic, "hello world")
* kp.send(topic, "the key", "hello again")
```
Producing a Message with headers. Header key and values must be strings. 
```cucumber
* def headers = { x-header-one : "header-one-value", x-header-two : "header-two-value" }
* kp.send(topic, "message_key", "message_payload", headers)
```
Producing a JSON message 
```cucumber
* def key = { ... }
* def value= { ... }
* kp.send(topic, key, value)
```

Terminating the Kafka producer ...
```
* kp.close()
```

### Kafka Consumer

Creating a Kafka consumer with the default properties. A consumer starts listening to the topic as soon as it is created
```cucumber
* def kc = new KafkaConsumer(topic)
```

The following default properties are used to create the consumer
```
{
  "bootstrap.servers": "127.0.0.1:9092",
  "key.deserializer": "org.apache.kafka.common.serialization.StringDeserializer",
  "value.deserializer": "org.apache.kafka.common.serialization.StringDeserializer",
  "group.id": "karate-kafka-default-consumer-group"
}
```

Creating a consumer with specified properties ...
```cucumber
* def props = { ... }
* def kc = new KafkaConsumer(topic, props)

# Get the default Properties
* def props = KafkaConsumer.getDefaultProperties()
```
Create a customer that filters the key and the value. The key filter is a regular
expression, and the value filter is a [jsonPath](https://github.com/json-path/JsonPath) predicate expression. 
```cucumber
* def kc = new KafkaConsumer(topic, consumerProps, "test.*", "[?(@.message =~ /hi.*/)]")
```

Read a record from the topic. This call will block until data is available.
```cucumber  
* json output = kc.take();
```
After reading, the `output` will contain
* `key`: Is always present. If producer did not specify a key, then this will be `null`.
* `value`: The message value.
* `headers`: Kafka message headers. Present only if the message had headers.
 
        
Read a record from the topic waiting upto the specified amount of time (in milliseconds). If the data is not available
by that time, it will return null. This can be used (for example) to check that no records were written to a topic
```cucumber  
* def raw = kc.poll(3000);
* match raw == null
```

Read multiple records from the topic. This call will block until data is available.  
```cucumber  
* json output = kc.take(5);
```

Terminating the Kafka consumer ...
```cucumber
* kc.close()
```

### Running Features and Scenarios

By default, Karate runs all the features ( and the scenarios in each feature) in parallel. Having multiple threads reading and
and writing from Kafka can lead to interleaving of results from different test cases. For this, it is best to run all the features
and scenario in a single thread. To do this, the following changes are needed:

* Add `@parallel=false` at the top of each feature file. This will ensure that the scenarios are run serially. BTW, Kafka does NOT 
guarantee that the scenarios will be executed in the same order that they appear in the feature file

* Set the number of threads to 1 in the `xxxRunner.java` file. e.g., `Runner.path(...).parallel(1);

### Cheat Sheet for configuring Serializers and Deserializers

On the consumer side, you need to specify a deserializer for the key / value the data type is an integer

| Data Type  | Serializer |
| ---| ---|
| Integer | org.apache.kafka.common.serialization.IntegerDeserializer  |
| Longer | org.apache.kafka.common.serialization.LongDeserializer  |
| String | auto-configured  |
| JSON | auto-configured  |

On the Producer Side, you should never have to configure a serializer either for the key or data

## Managing the local Kafka broker

The configuration for Kafka and Zookeeper is specified in `kafka-single-broker.yml`. See
[Wurstmeister's Github wiki](https://github.com/wurstmeister/kafka-docker) on how to configure this.

### Setting up the Kafka Cluster

From the command line, run 

```
$ ./startup.sh
Starting karate-kafka_zookeeper_1 ... done
Starting karate-kafka_kafka_1     ... done
CONTAINER ID        IMAGE                    NAMES
ce9b01556d15        wurstmeister/zookeeper   karate-kafka_zookeeper_1
33685067cb82        wurstmeister/kafka       karate-kafka_kafka_1
*** sleeping for 10 seconds (give time for containers to spin up)
```

From the command-line, run `./teardown.sh` to tear down the cluster. This stops zookeeper
and all the kafka brokers, and also deletes the containers. This means all the data written
to the kafka cluster will be lost. During testing, this is good because it
allows us to start each test from the same known state.

### References

* [Kafkacat](https://github.com/edenhill/kafkacat)
* [Running Kafka inside Docker](https://github.com/wurstmeister/kafka-docker)
* [Markdown syntax](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
* [Java-Javascript Interop Issues in Nashorn](https://github.com/EclairJS/eclairjs-nashorn/wiki/Nashorn-Java-to-JavaScript-interoperability-issues)
* [Hosting a maven repository on github](https://dev.to/iamthecarisma/hosting-a-maven-repository-on-github-site-maven-plugin-9ch)
* [Upgrading to Karate 1.0.0](https://github.com/karatelabs/karate/wiki/1.0-upgrade-guide)
