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
export FABRIC_CFG_PATH=$PWD/msp
export CORE_PEER_ADDRESS=org2-peer1.org2.localho.st:443
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_MSPCONFIGPATH=$PWD/msp/org2/admin
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/msp/org2/admin/tlscacerts/cert.pem
peer channel list

osnadmin channel list \
  --orderer-address org0-orderer1-admin.org0.localho.st:443 \
  --ca-file         $PWD/msp/org0/admin/tlscacerts/cert.pem \
  --client-cert     $PWD/msp/org0/admin/signcerts/cert.pem \
  --client-key      $PWD/msp/org0/admin/keystore/key.pem
```
