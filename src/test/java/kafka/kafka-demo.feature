Feature: Kafka Producer & Consumer Demo

  Background:
    * def KafkaConsumer = Java.type('kafka.KarateKafkaConsumer')
    * def KafkaProducer = Java.type('kafka.KarateKafkaProducer')
    * def topic = 'test-topic'

  Scenario: Write to a topic and read only the records matching given key and value filters
    # Create a consumer, which will start listening to the topic as soon as it is created and consume only the records that meet the key & value filter criteria:
    * def kc = new KafkaConsumer(topic, "test.*", "[?(@.message =~ /hi.*/)]")

    # Create a producer:
    * def kp = new KafkaProducer()

    # Send a message without key:
    * kp.send(topic, { message: "hello world"} )

    # Send a message with a key:
    * kp.send(topic, "the_key", { message: "hello again"})

    # Send a message with a key that starts with 'test':
    * kp.send(topic, "test_key", { message: "hello from test"})

    # Send another message with a key that starts with 'test' and a value that starts with 'hi':
    * kp.send(topic, "test_key2", { message : "hi from test"} )

    # Close the producer:
    * kp.close()

    # Read the output (the call to take() will block until some data is available):
    * json output = kc.take()

    # Close the consumer before doing the match (otherwise, if the test fails, you will not be able to close the consumer):
    * kc.close()

    # Verify the consumer only consumed the keys that start with 'test' and the values start with 'hi':
    * match output == { key : 'test_key2', value : {message: hi from test} }

  Scenario: Write JSON to test-topic and read it back
    # Create a producer:
    * def kp = new KafkaProducer()

    # Create a consumer:
    * def props = KafkaConsumer.getDefaultProperties()
    * def kc = new KafkaConsumer(topic,props)

    # Define a key & value:
    * def key = { id: 10 }
    * def value =
      """
      {
        person : {
            firstName : "Daniel",
            lastName : "LaRusso"
            },
        location : "Reseda, CA"
      }
      """

    # Send a message:
    * kp.send(topic, key, value);

    # Convert the output to JSON (for matching purposes):
    * json output = kc.take()

    # Close the producer & consumer:
    * kp.close()
    * kc.close()

    # Run some assertions on the output:
    * match output.key == key
    * match output.value == value
    * match output.key.id == 10
    * match output.value.person.firstName == 'Daniel'

  Scenario: Read a list of messages from the test-topic
    * def kc = new KafkaConsumer(topic)
    * def kp = new KafkaProducer()

    # Send two messages:
    * kp.send(topic, "value one")
    * kp.send(topic, "test key", "value two")

    # Close the producer:
    * kp.close()

    # Read the output:
    * json output = kc.take(2)

    # Close the consumer:
    * kc.close()

    # Validate the output:
    * match output contains { key : #null, value : 'value one' }
    * match output contains { key : 'test key', value : 'value two' }

  Scenario: Reading from test-topic with timeout
    * def kc = new KafkaConsumer(topic)
    * def kp = new KafkaProducer()

    # Send a message:
    * kp.send(topic, "key", "value")

    # Poll for 5 seconds
    * def pollResults = kc.poll(5000)

    # Close the consumer & producer:
    * kc.close()
    * kp.close()

    # Verify the poll results:
    * match pollResults == '{key: key, value: value}'

  Scenario: Kafka producer & consumer with properties
    # Create a consumer with properties:
    * def consumerDefaults = KafkaConsumer.getDefaultProperties()
    * def kc = new KafkaConsumer(topic, consumerDefaults)

#    # We could also define our own consumer properties (rather than use the default values):
#    * def consumerProps =
#      """
#      {
#        "bootstrap.servers": "127.0.0.1:9092",
#        "value.deserializer": "org.apache.kafka.common.serialization.StringDeserializer",
#        "key.deserializer": "org.apache.kafka.common.serialization.StringDeserializer",
#        "group.id": "test-consumer"
#      }
#      """
#    * def kc = new KafkaConsumer(topic, consumerProps)

    # Create a producer with properties:
    * def producerDefaults = KafkaProducer.getDefaultProperties()
    * def kp = new KafkaProducer(producerDefaults)

    # Send a message:
    * kp.send(topic, "the_message_key", "the_message_value")

    # Grab the output:
    * json output = kc.take()

    # Close the producer & consumer:
    * kp.close()
    * kc.close()

    # Validate the output:
    * match output == { key : 'the_message_key', value : 'the_message_value' }

  Scenario: Kafka producer & consumer with headers
    * def kc = new KafkaConsumer(topic)
    * def kp = new KafkaProducer()
    * def headers = { x-header-one : "header-one-value", x-header-two : "header-two-value" }
    * kp.send(topic, "message_key", "message_payload", headers)
    * json out = kc.take()
    * kc.close()
    * kp.close()
    * match out.headers contains { "x-header-one": "header-one-value" }
    * match out.headers contains { "x-header-two": "header-two-value" }
    * match out.key == "message_key"
    * match out.value == "message_payload"
