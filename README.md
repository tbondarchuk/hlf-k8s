# hlf-k8s

Example Manifests to deploy Hyperledger Fabric to Kubernentes

uses cert-manager for tls and ecert certificates

## kind cluster

start: `./kind.sh`
delete: `kind delete cluster`

## network

start: `./network.sh`

## check

```sh
openssl s_client -connect org0-orderer1.org0.localho.st:443 -servername org0-orderer1.org0.localho.st
```
