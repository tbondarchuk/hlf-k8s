#!/bin/bash

for org in org0 org1 org2
do
  for component in $(ls -1 ${org}/)
  do
    kubectl apply --recursive -f ${org}/${component}
    sleep 3
  done
done
