#!/bin/bash

configtxgen -profile TwoOrgsApplicationGenesis -channelID channel -outputBlock data/genesis_block.pb

# configtxgen -inspectBlock data/genesis_block.pb | tee data/genesis_block.json | jq

for i in 1 2 3
do
  osnadmin channel join \
    --orderer-address org0-orderer${i}-admin.org0.localho.st:443 \
    --ca-file         $PWD/data/org0/admin/tlscacerts/cert.pem \
    --client-cert     $PWD/data/org0/admin/signcerts/cert.pem \
    --client-key      $PWD/data/org0/admin/keystore/key.pem \
    --channelID       channel \
    --config-block    data/genesis_block.pb
done

# for i in 1 2 3
# do
#   osnadmin channel list \
#     --orderer-address org0-orderer${i}-admin.org0.localho.st:443 \
#     --ca-file         $PWD/data/org0/admin/tlscacerts/cert.pem \
#     --client-cert     $PWD/data/org0/admin/signcerts/cert.pem \
#     --client-key      $PWD/data/org0/admin/keystore/key.pem
# done


for org in 1 2
do
  for peer in 1 2
    do
      export FABRIC_CFG_PATH=$PWD/data
      export CORE_PEER_ADDRESS=org${org}-peer${peer}.org${org}.localho.st:443
      export CORE_PEER_LOCALMSPID=Org${org}MSP
      export CORE_PEER_MSPCONFIGPATH=$PWD/data/org${org}/admin
      export CORE_PEER_TLS_ENABLED=true
      export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/data/org${org}/admin/tlscacerts/cert.pem
      peer channel join --blockpath data/genesis_block.pb
    done
done
