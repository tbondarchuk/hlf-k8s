#!/bin/bash

mkdir -p data/org{0,1,2}/admin/{cacerts,keystore,signcerts,tlscacerts}
mkdir -p data/org{0,1,2}/msp/{cacerts,tlscacerts}
touch data/core.yaml

for org in org0 org1 org2
do
  kubectl get -n ${org} cm ${org}-nodeou -o json | jq -r '.data."config.yaml"' > data/${org}/admin/config.yaml
  kubectl get -n ${org} cm ${org}-nodeou -o json | jq -r '.data."config.yaml"' > data/${org}/msp/config.yaml

  kubectl get -n ${org} secret ${org}-tls-cert-issuer -o json | jq -r '.data."tls.crt"' | base64 -d > data/${org}/admin/tlscacerts/cert.pem
  kubectl get -n ${org} secret ${org}-tls-cert-issuer -o json | jq -r '.data."tls.crt"' | base64 -d > data/${org}/msp/tlscacerts/cert.pem
  kubectl get -n ${org} secret ${org}-cert-issuer -o json | jq -r '.data."tls.crt"' | base64 -d > data/${org}/msp/cacerts/cacert.pem

  kubectl get -n ${org} secret ${org}-admin-cert -o json | jq -r '.data."tls.key"' | base64 -d > data/${org}/admin/keystore/key.pem
  kubectl get -n ${org} secret ${org}-admin-cert -o json | jq -r '.data."ca.crt"' | base64 -d > data/${org}/admin/cacerts/cacert.pem
  kubectl get -n ${org} secret ${org}-admin-cert -o json | jq -r '.data."tls.crt"' | base64 -d > data/${org}/admin/signcerts/cert.pem
done

for i in 1 2 3
do
  kubectl get -n org0 secret org0-orderer${i}-tls-cert -o json | jq -r '.data."tls.crt"' | base64 -d > data/org0/org0-orderer${i}-tls-cert.pem
done
