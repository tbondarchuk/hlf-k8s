#!/bin/bash

org=1
peer=1

export FABRIC_CFG_PATH=$PWD/data
export CORE_PEER_ADDRESS=org${org}-peer${peer}.org${org}.localho.st:443
export CORE_PEER_LOCALMSPID=Org${org}MSP
export CORE_PEER_MSPCONFIGPATH=$PWD/data/org${org}/admin
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/data/org${org}/admin/tlscacerts/cert.pem

echo "query from org1 peer1"
peer chaincode query \
      --channelID     mychannel \
      --name          asset-transfer \
      -c '{"Args":["org.hyperledger.fabric:GetMetadata"]}'

echo "create asset"
peer chaincode invoke \
      --channelID     mychannel \
      --name          asset-transfer \
      --orderer       org0-orderer1.org0.localho.st:443 \
      --tls --cafile  $PWD/data/org0/org0-orderer1-tls-cert.pem \
      -c '{"Args":["CreateAsset","{\"ID\":\"001\", \"Color\":\"Red\",\"Size\":52,\"Owner\":\"Fred\",\"AppraisedValue\":234234}"]}'

echo "get asset"
peer chaincode query \
      --channelID     mychannel \
      --name          asset-transfer \
      -c '{"Args":["ReadAsset","001"]}'

echo "switch to org2"
sleep 5
org=2
peer=2

export FABRIC_CFG_PATH=$PWD/data
export CORE_PEER_ADDRESS=org${org}-peer${peer}.org${org}.localho.st:443
export CORE_PEER_LOCALMSPID=Org${org}MSP
export CORE_PEER_MSPCONFIGPATH=$PWD/data/org${org}/admin
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/data/org${org}/admin/tlscacerts/cert.pem

echo "query from org2 peer2"
peer chaincode query \
      --channelID     mychannel \
      --name          asset-transfer \
      -c '{"Args":["org.hyperledger.fabric:GetMetadata"]}'

echo "get asset"
peer chaincode query \
      --channelID     mychannel \
      --name          asset-transfer \
      -c '{"Args":["ReadAsset","001"]}'
