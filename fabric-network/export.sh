#!/bin/bash

function printHelp() {
    echo "Usage: "
    echo "  source ./export.sh <Mode>"
    echo "    <Mode>"
    echo "      - 'vol1' - export vol1 environment variable"
    echo "      - 'vol2' - export vol2 environment variable"
}

function exportVol1() {
    echo "================ Vol1 ================"
#    set -x
    export FABRIC_CFG_PATH=$PWD/../config/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Vol1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/vol1.example.com/users/Admin@vol1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
#    set +x
    echo "================ End Vol1 ================"
}

function exportVol2() {
    echo "================ Vol2 ================"
    export FABRIC_CFG_PATH=$PWD/../config/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Vol2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/vol2.example.com/users/Admin@vol2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    echo "================ End Vol2 ================"
}
## Parse mode
if [[ $# -lt 1 ]] ; then
  printHelp
  exit 0
else
  MODE=$1
  shift
fi

if [ "${MODE}" == "vol1" ]; then
  exportVol1
elif [ "${MODE}" == "vol2" ]; then
  exportVol2
fi
