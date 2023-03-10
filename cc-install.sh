#!/bin/bash

echo "Packaging k8s chaincode"

rm -rf data/chaincode
mkdir -p data/chaincode

# use simple name so chaincode can be reused in different orgs
# can use template vars like {{.peername}} together with peer env var CHAINCODE_AS_A_SERVICE_BUILDER_CONFIG="{\"peername\":\"org1peer1\"}"
cat << EOF > data/chaincode/connection.json
{
  "address": "ccaas-asset-transfer:9999",
  "dial_timeout": "10s",
  "tls_required": false
}
EOF

cat << EOF > data/chaincode/metadata.json
{
  "type": "ccaas",
  "label": "asset-transfer"
}
EOF

tar -C data/chaincode -zcf data/chaincode/code.tar.gz connection.json
tar -C data/chaincode -zcf data/chaincode.tar.gz code.tar.gz metadata.json

PKG_ID=$(peer lifecycle chaincode calculatepackageid data/chaincode.tar.gz)
echo "package ID: ${PKG_ID}"

# use simple string to match deployment
# PKG_ID=asset-transfer:latest

for org in 1 2
do
  kubectl set env deploy/ccaas-asset-transfer CHAINCODE_ID=${PKG_ID} -n org${org}
  for peer in 1 2
    do
      echo "install chaincode on org-${org} peer-${peer}"
      export FABRIC_CFG_PATH=$PWD/data
      export CORE_PEER_ADDRESS=org${org}-peer${peer}.org${org}.localho.st:443
      export CORE_PEER_LOCALMSPID=Org${org}MSP
      export CORE_PEER_MSPCONFIGPATH=$PWD/data/org${org}/admin
      export CORE_PEER_TLS_ENABLED=true
      export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/data/org${org}/admin/tlscacerts/cert.pem
      peer lifecycle chaincode install data/chaincode.tar.gz
    done

  peer lifecycle \
      chaincode approveformyorg \
      --channelID     mychannel \
      --name          asset-transfer \
      --version       1 \
      --package-id    ${PKG_ID} \
      --sequence      1 \
      --orderer       org0-orderer1.org0.localho.st:443 \
      --tls --cafile  $PWD/data/org0/org0-orderer1-tls-cert.pem

done

peer lifecycle \
    chaincode commit \
    --channelID     mychannel \
    --name          asset-transfer \
    --version       1 \
    --sequence      1 \
    --orderer       org0-orderer1.org0.localho.st:443 \
    --tls --cafile  $PWD/data/org0/org0-orderer1-tls-cert.pem
