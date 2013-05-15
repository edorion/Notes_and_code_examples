#!/bin/bash
JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64
DIR=/usr/local/selenium-server
CLASSPATH=${DIR}/.:${DIR}/junit-4.10.jar:${DIR}/selenium-server-standalone-2.25.0.jar:${DIR}/selenium-2.25.0/.:${DIR}/selenium-2.25.0/libs/. org.junit.runner.JUnitCore

echo $CLASSPATH

# {JAVA_HOME}/bin/java -cp ${CLASSPATH} ${DIR}/Seleniumtc1 $@

