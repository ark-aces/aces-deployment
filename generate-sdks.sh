#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

REPOS_PATH=$DIR/..
SWAGGER_CODEGEN_PATH=$REPOS_PATH/aces-swagger-codegen/modules/swagger-codegen-cli/target
ENCODED_LISTENER_API_PATH=$REPOS_PATH/aces-encoded-listener-api
SERVICE_API_PATH=$REPOS_PATH/aces-service-api


for LANGUAGE in java php go javascript python csharp
do
    rm -rf $ENCODED_LISTENER_API_PATH/sdks/$LANGUAGE/
    java -jar $SWAGGER_CODEGEN_PATH/swagger-codegen-cli.jar generate \
        -i $ENCODED_LISTENER_API_PATH/aces-encoded-listener-api-swagger.yaml \
        -l $LANGUAGE \
        -o $ENCODED_LISTENER_API_PATH/sdks/$LANGUAGE/ \
        -c $DIR/configs/encoded-listener-sdks/$LANGUAGE.json

    rm -rf $SERVICE_API_PATH/sdks/$LANGUAGE/
    java -jar $SWAGGER_CODEGEN_PATH/swagger-codegen-cli.jar generate \
        -i $SERVICE_API_PATH/aces-service-api-swagger.yaml \
        -l $LANGUAGE \
        -o $SERVICE_API_PATH/sdks/$LANGUAGE/ \
        -c $DIR/configs/service-sdks/$LANGUAGE.json
done

