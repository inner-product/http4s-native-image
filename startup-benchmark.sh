#!/usr/bin/env bash

# Measure the startup time (time to first response) for Native Image and JVM server
#
# Modified from https://sites.google.com/a/athaydes.com/renato-athaydes/posts/a7mbnative-imagejavaappthatrunsin30msandusesonly4mbofram

# command that tests that the server is accepting connections
CMD="curl localhost:8080/ping/hi >& /dev/null"

RESULTS_FILE=ping-server-native.csv

rm $RESULTS_FILE
echo "time (ms),mem (kb)" >> $RESULTS_FILE
for N in {1..100}
do
    START_TIME=$(gdate +%s%3N)
    # start the server
    ./out/ping-server.local &
    SERVER_PID=$!

    STEP=0.001      # sleep between tries, in seconds
    TRIES=500
    eval ${CMD}
    while [[ $? -ne 0 ]]; do
        ((TRIES--))
        echo -ne "Tries left: $TRIES"\\r
        if [[ TRIES -eq 0 ]]; then
            echo "Server not started within timeout"
            exit 1
        fi
        sleep ${STEP}
        eval ${CMD}
    done

    END_TIME=$(gdate +%s%3N)
    TIME=$(($END_TIME - $START_TIME))
    MEM=$(ps -o rss= -p "$SERVER_PID")
    echo "Server connected in $TIME ms"
    echo "Memory usage is $MEM"
    printf "%d,%s\n" $TIME $MEM >> $RESULTS_FILE

    kill ${SERVER_PID}
done


RESULTS_FILE=ping-server-jvm.csv

rm $RESULTS_FILE
echo "time (ms),mem (kb)" >> $RESULTS_FILE
for N in {1..100}
do
    START_TIME=$(gdate +%s%3N)
    # start the server
    java -jar target/scala-2.13/http4s-native-image-assembly-0.1.0-SNAPSHOT.jar &
    SERVER_PID=$!

    STEP=0.001      # sleep between tries, in seconds
    TRIES=500
    eval ${CMD}
    while [[ $? -ne 0 ]]; do
        ((TRIES--))
        echo -ne "Tries left: $TRIES"\\r
        if [[ TRIES -eq 0 ]]; then
            echo "Server not started within timeout"
            exit 1
        fi
        sleep ${STEP}
        eval ${CMD}
    done

    END_TIME=$(gdate +%s%3N)
    TIME=$(($END_TIME - $START_TIME))
    MEM=$(ps -o rss= -p "$SERVER_PID")
    echo "Server connected in $TIME ms"
    echo "Memory usage is $MEM"
    printf "%d,%s\n" $TIME $MEM >> $RESULTS_FILE

    kill ${SERVER_PID}
    # Without this sleep the port will occasionally not have been released and the next run will fail
    sleep 0.1
done
