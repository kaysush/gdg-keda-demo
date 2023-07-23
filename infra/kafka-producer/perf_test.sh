#!/bin/sh

set -e

source secrets.env

echo 'Downloading Kafka if needed'

if [[ -d "$PAYLOAD_FILE" ]]; then
echo 'Kafka installation found... Skipping'
else
    wget -o https://downloads.apache.org/kafka/3.5.0/kafka_2.12-3.5.0.tgz
    tar -xvf kafka_2.12-3.5.0.tgz
fi



TOPIC=keda-demo-topic
TOTAL_RECORDS=100000
MSGS_PER_SEC=100
CONFIG_FILE=producer.props
KAFKA_DIR=kafka_2.12-3.5.0/bin
PAYLOAD_FILE=rand_nums.txt

echo 'Creating producer config'
cat > $CONFIG_FILE << EOF
sasl.mechanism=PLAIN
bootstrap.servers=${BOOTSTRAP_SERVER}
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='${API_KEY}' password='${API_SECRET}';
security.protocol=SASL_SSL
key.serializer=org.apache.kafka.common.serialization.StringSerializer
value.serializer=org.apache.kafka.common.serialization.StringSerializer
EOF


if [[ -f "$PAYLOAD_FILE" ]]; then
    echo "$PAYLOAD_FILE exists. Truncating it."
    > $PAYLOAD_FILE
fi

echo 'Creating payload file'
for i in {1..10}
do 
    echo $i >> $PAYLOAD_FILE
done

${KAFKA_DIR}/kafka-producer-perf-test.sh \
--topic $TOPIC \
--num-records $TOTAL_RECORDS \
--throughput $MSGS_PER_SEC \
--producer.config $CONFIG_FILE \
--payload-file $PAYLOAD_FILE \
--print-metrics