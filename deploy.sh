TMP_NAME=$1
VERSION=$2
AWS_BASEDOMAIN=
GCP_BASEDOMAIN=
AZURE_BASEDOMAIN=

if [ "${AWS_BASEDOMAIN}" == "" ] || [ "${GCP_BASEDOMAIN}" == "" ] || [ "${AZURE_BASEDOMAIN}" == "" ]; then
  echo "Make sure you set the _BASEDOMAIN values in the deploy.sh file"
  exit 1
fi

if [ "${VERSION}" == "" ] || [ "${TMP_NAME}" == "" ]; then
  echo "Missing parameters"
  echo "./deploy.sh <PREFIX> <VERSION>"
  exit 1
fi

echo "Applying version ${VERSION} with prefix $TMP_NAME"

printf "Check that the version exists... "
oc get clusterImageSets | grep "img${VERSION}-x86-64" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  printf "Missing!\n"
  echo "The version ${VERSION} did not match an existing clusterImageSet, instead found these:"
  oc get clusterImageSets
  echo "./deploy.sh <PREFIX> <VERSION>"
  exit 1
fi
printf "Found!\n${IMAGE_OUT}\n"

cp cluster-templates/*.yaml .

echo "Generating cluster YAML"
sed -i "s/VERSION/${VERSION}/g" ./cluster-aws.yaml
sed -i "s/VERSION/${VERSION}/g" ./cluster-gcp.yaml
sed -i "s/VERSION/${VERSION}/g" ./cluster-azure.yaml

sed -i "s/TMP_NAME/${TMP_NAME}/g" ./cluster-aws.yaml
sed -i "s/REPLACE_BASEDOMAIN/${AWS_BASEDOMAIN}/g" ./cluster-aws.yaml
sed -i "s/TMP_NAME/${TMP_NAME}/g" ./cluster-gcp.yaml
sed -i "s/REPLACE_BASEDOMAIN/${GCP_BASEDOMAIN}/g" ./cluster-gcp.yaml
sed -i "s/TMP_NAME/${TMP_NAME}/g" ./cluster-azure.yaml
sed -i "s/REPLACE_BASEDOMAIN/${AZURE_BASEDOMAIN}/g" ./cluster-azure.yaml
sed -i "s/TMP_NAME/${TMP_NAME}/g" ./aws-install-config.yaml
sed -i "s/REPLACE_BASEDOMAIN/${AWS_BASEDOMAIN}/g" ./aws-install-config.yaml
sed -i "s/TMP_NAME/${TMP_NAME}/g" ./gcp-install-config.yaml
sed -i "s/REPLACE_BASEDOMAIN/${GCP_BASEDOMAIN}/g" ./gcp-install-config.yaml
sed -i "s/TMP_NAME/${TMP_NAME}/g" ./azure-install-config.yaml
sed -i "s/REPLACE_BASEDOMAIN/${AZURE_BASEDOMAIN}/g" ./azure-install-config.yaml

echo "Done!"
#oc apply -k .

