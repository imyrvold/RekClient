#!/bin/sh

#  CognitoConfig.sh
#  RekClient
#
#  Created by Ivan C Myrvold on 09/05/2021.
#  
PLISTBUDDY="/usr/libexec/PlistBuddy"
plistPath="$SRCROOT/Shared/Config/CognitoConfig.plist"

USER_POOL_NAME="ImageRekognitionUserPool"
USER_POOL_ID=$(aws cognito-idp list-user-pools --max-results 5 --query UserPools[?Name==\`${USER_POOL_NAME}\`].Id --output text | tr -d \")
echo "USER_POOL_ID=${USER_POOL_ID}"

APP_CLIENT_NAME="ImageRekognitionUserPoolClient"
APP_CLIENT_ID=$(aws cognito-idp list-user-pool-clients --user-pool-id ${USER_POOL_ID} --query UserPoolClients[?ClientName==\`${APP_CLIENT_NAME}\`].ClientId --output text | tr -d \")
echo "APP_CLIENT_ID=${APP_CLIENT_ID}"

APP_CLIENT_SECRET=$(aws cognito-idp describe-user-pool-client --user-pool-id ${USER_POOL_ID} --client-id ${APP_CLIENT_ID} --query UserPoolClient.ClientSecret --output text)
echo "APP_CLIENT_SECRET=${APP_CLIENT_SECRET}"

IDENTITY_POOL_NAME="ImageRekognitionIdentityPool"
IDENTITY_POOL_ID=$(aws cognito-identity list-identity-pools --max-results 5 --query IdentityPools[?IdentityPoolName==\`${IDENTITY_POOL_NAME}\`].IdentityPoolId --output text | tr -d \")
echo "IDENTITY_POOL_ID=${IDENTITY_POOL_ID}"

API_NAME="imageAPI"
REST_API_ID=$(aws apigateway get-rest-apis --query items[?name==\`${API_NAME}\`].id --output text | tr -d \")
ENDPOINT=https://${REST_API_ID}.execute-api.eu-west-1.amazonaws.com/prod
echo "API available at: ${ENDPOINT}"

IMAGE_BUCKET=$(aws s3 ls | aws s3 ls | awk '/lambdadeploymentstage/{print $NF}' | awk "NR==1{print;exit}")
echo "IMAGE_BUCKET=${IMAGE_BUCKET}"

THUMB_BUCKET=$(aws s3 ls | awk '/lambdadeploymentstage/{print $NF}' | awk "NR==2{print;exit}")
echo "THUMB_BUCKET=${THUMB_BUCKET}"

$PLISTBUDDY -c "Set :poolId $USER_POOL_ID" "${plistPath}"
$PLISTBUDDY -c "Set :clientId $APP_CLIENT_ID" "${plistPath}"
$PLISTBUDDY -c "Set :clientSecret $APP_CLIENT_SECRET" "${plistPath}"
$PLISTBUDDY -c "Set :imageBucket $IMAGE_BUCKET" "${plistPath}"
$PLISTBUDDY -c "Set :thumbBucket $THUMB_BUCKET" "${plistPath}"
$PLISTBUDDY -c "Set :endpoint $ENDPOINT" "${plistPath}"
