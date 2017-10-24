#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for LANGUAGE in java php go javascript python csharp
do
    rm -rf $DIR/../aces-encoded-listener-api/sdks/$LANGUAGE/
	java -jar $DIR/../aces-swagger-codegen/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate \
       -i $DIR/../aces-encoded-listener-api/aces-encoded-listener-api-swagger.yaml \
       -l $LANGUAGE \
       -o $DIR/../aces-encoded-listener-api/sdks/$LANGUAGE/
done

