#!/usr/bin/env bash
#
# Measure sustained performance under load

# number of iterations to run per server
ITERATIONS=10000
# maximum number of concurrent requests
CONCURRENCY=50
# URL to test
URL=http://localhost:8080/ping/hi
# ab stops after timeout seconds regardless of how many requests it has sent
TIMEOUT=300


echo "Benchmarking Native Image server"
./out/ping-server.local > local-log.txt &
SERVER_PID=$!
SLEEP 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e native-image-sustained.csv ${URL}
kill ${SERVER_PID}
# Give some time for shutdown to complete
sleep 5


echo "Benchmarking cold JVM server"
java -jar target/scala-2.13/http4s-native-image-assembly-0.1.0-SNAPSHOT.jar > jvm-log.txt &
SERVER_PID=$!
SLEEP 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-cold-sustained.csv ${URL}
# Give some time for GC to run
sleep 5

echo "Benchmarking warm JVM server"
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-1.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-2.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-3.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-4.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-5.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-6.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-7.csv ${URL}
sleep 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-warm-sustained-8.csv ${URL}
kill ${SERVER_PID}
# Give some time for shutdown to complete
sleep 5
