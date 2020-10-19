#!/bin/bash

S_JAR="../BuildTools/craftbukkit-*.jar"
D_JAR="craftbukkit.jar"

cd "$(dirname "$0")"
cp ${S_JAR} ${D_JAR}
java -jar ${D_JAR} --nogui
