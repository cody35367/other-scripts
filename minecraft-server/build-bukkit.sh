#!/bin/bash

# Ref: https://www.spigotmc.org/wiki/buildtools/

set -e

sudo dnf install git java-1.8.0-openjdk-devel

mkdir -p ./BuildTools
curl https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -o ./BuildTools/BuildTools.jar

cd ./BuildTools
java -jar BuildTools.jar --compile craftbukkit
