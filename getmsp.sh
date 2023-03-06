#!/bin/bash

mkdir -p msp/org{0,1,2}/admin/{cacerts,keystore,signcerts,tlscacerts}
touch msp/core.yaml

for org in org0 org1 org2
do
  kubectl get -n ${org} cm ${org}-nodeou -o json | jq -r '.data."config.yaml"' > msp/${org}/admin/config.yaml
  kubectl get -n ${org} secret ${org}-tls-cert-issuer -o json | jq -r '.data."tls.crt"' | base64 -d > msp/${org}/admin/tlscacerts/cert.pem
  kubectl get -n ${org} secret ${org}-admin-cert -o json | jq -r '.data."tls.key"' | base64 -d > msp/${org}/admin/keystore/key.pem
  kubectl get -n ${org} secret ${org}-admin-cert -o json | jq -r '.data."ca.crt"' | base64 -d > msp/${org}/admin/cacerts/cacert.pem
  kubectl get -n ${org} secret ${org}-admin-cert -o json | jq -r '.data."tls.crt"' | base64 -d > msp/${org}/admin/signcerts/cert.pem
done
