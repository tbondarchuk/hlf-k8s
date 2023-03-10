# hlf-k8s

Example Manifests to deploy Hyperledger Fabric to Kubernentes

uses cert-manager for tls and ecert certificates

## kind cluster

start: `./kind.sh`

delete: `kind delete cluster`

## network

start: `./network.sh`

get admin MSPs: `./getmsp.sh`

## check

```sh
openssl s_client -connect org0-orderer1.org0.localho.st:443 -servername org0-orderer1.org0.localho.st
```

some commands:

```sh
export FABRIC_CFG_PATH=$PWD/data
export CORE_PEER_ADDRESS=org2-peer1.org2.localho.st:443
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_MSPCONFIGPATH=$PWD/data/org2/admin
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/data/org2/admin/tlscacerts/cert.pem
peer channel list

osnadmin channel list \
  --orderer-address org0-orderer1-admin.org0.localho.st:443 \
  --ca-file         $PWD/data/org0/admin/tlscacerts/cert.pem \
  --client-cert     $PWD/data/org0/admin/signcerts/cert.pem \
  --client-key      $PWD/data/org0/admin/keystore/key.pem
```

## channel

1. get msps: `./getmsp.sh`
2. create channel: `./channel.sh`


## chaincode

Uses ghcr.io/hyperledgendary/full-stack-asset-transfer-guide/contracts/asset-transfer-typescript:c7a82342f9df07fe7d3fc1994a4b3fc317602e36 from https://github.com/hyperledgendary/full-stack-asset-transfer-guide/pkgs/container/full-stack-asset-transfer-guide%2Fcontracts%2Fasset-transfer-typescript now https://github.com/hyperledger/fabric-samples/tree/main/full-stack-asset-transfer-guide


1. install: `./cc-install.sh`
2. test: `./cc-test.sh`
