#!/usr/bin/env bash
#
# Generate data for JVM tuning experiments

# number of iterations to run per server
ITERATIONS=10000
# maximum number of concurrent requests
CONCURRENCY=50
# URL to test
URL=http://localhost:8080/ping/hi
# ab stops after timeout seconds regardless of how many requests it has sent
TIMEOUT=300

echo "Untuned JVM server"
echo "Warming up"
java -jar target/scala-2.13/http4s-native-image-assembly-0.1.0-SNAPSHOT.jar > jvm-log.txt &
SERVER_PID=$!
SLEEP 5
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
# Give some time for GC to run
sleep 5
echo "-----------------------------------------"
echo "Untuned JVM Benchmark Run"
echo "-----------------------------------------"
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-untuned.csv ${URL}
kill ${SERVER_PID}
sleep 5


echo "GC tuned JVM server"
echo "Warming up"
java -XX:MaxGCPauseMillis=200 -jar target/scala-2.13/http4s-native-image-assembly-0.1.0-SNAPSHOT.jar > jvm-log.txt &
SERVER_PID=$!
SLEEP 5
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
# Give some time for GC to run
sleep 5
echo "-----------------------------------------"
echo "GC Tuned JVM Benchmark Run"
echo "-----------------------------------------"
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-gc-tuned.csv ${URL}
kill ${SERVER_PID}
sleep 5


echo "Compiler tuned JVM server"
echo "Warming up"
java -Dgraal.TrivialInliningSize=21 -Dgraal.MaximumInliningSize=450 -Dgraal.SmallCompiledLowLevelGraphSize=550 -jar target/scala-2.13/http4s-native-image-assembly-0.1.0-SNAPSHOT.jar > jvm-log.txt &
SERVER_PID=$!
SLEEP 5
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -dSq -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
# Give some time for GC to run
sleep 5
echo "-----------------------------------------"
echo "Compiler Tuned JVM Benchmark Run"
echo "-----------------------------------------"
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-compiler-tuned.csv ${URL}
kill ${SERVER_PID}
sleep 5


echo "Compiler + GC tuned JVM server"
echo "Warming up"
java -XX:MaxGCPauseMillis=200 -Dgraal.TrivialInliningSize=21 -Dgraal.MaximumInliningSize=450 -Dgraal.SmallCompiledLowLevelGraphSize=550 -jar target/scala-2.13/http4s-native-image-assembly-0.1.0-SNAPSHOT.jar > jvm-log.txt &
SERVER_PID=$!
SLEEP 5
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} ${URL}
# Give some time for GC to run
sleep 5
echo "-----------------------------------------"
echo "Both Tuned JVM Benchmark Run"
echo "-----------------------------------------"
ab -n ${ITERATIONS} -c ${CONCURRENCY} -s ${TIMEOUT} -e jvm-both-tuned.csv ${URL}
kill ${SERVER_PID}
sleep 5
