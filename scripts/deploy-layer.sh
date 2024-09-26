#!/bin/sh

cd ../layers/uuid-layer
npm i
mkdir -p nodejs/
cp -r node_modules nodejs/
zip -q -r layer-uuid.zip nodejs

layerVersionArn=$(aws lambda publish-layer-version --layer-name layer-uuid \
    --zip-file fileb://layer-uuid.zip \
    --compatible-runtimes nodejs20.x \
    --compatible-architectures "arm64" | grep "LayerVersionArn" | cut -d '"' -f 4)

echo $layerVersionArn

rm -f ./layer-uuid.zip
rm -rf ./nodejs
rm -rf ./node_modules

cd ../../lambdas

zip -q -r lambda-file.zip ./index.mjs

aws lambda create-function --function-name layered-lambda --runtime nodejs20.x \
     --role arn:aws:iam::084828590737:role/lambda-basic-execution \
     --zip-file fileb://lambda-file.zip --handler index.handler

sleep 5

aws lambda update-function-configuration --function-name layered-lambda \
    --cli-binary-format raw-in-base64-out \
    --layers "$layerVersionArn"

rm -f ./lambda-file.zip


