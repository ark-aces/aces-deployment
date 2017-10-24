#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LANGUAGE=$1

java -jar $DIR/../aces-swagger-codegen/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar config-help \
    -l $LANGUAGE

