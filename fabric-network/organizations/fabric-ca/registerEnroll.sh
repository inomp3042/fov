

function createVol1 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/vol1.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/vol1.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:qwer1234@localhost:7054 --caname ca-vol1 --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-vol1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-vol1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-vol1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-vol1.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/vol1.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-vol1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-vol1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-vol1 --id.name vol1admin --id.secret vol1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/vol1.example.com/peers
  mkdir -p organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-vol1 -M ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/msp --csr.hosts peer0.vol1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-vol1 -M ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls --enrollment.profile tls --csr.hosts peer0.vol1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/vol1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/vol1.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/vol1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/vol1.example.com/tlsca/tlsca.vol1.example.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/vol1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/peers/peer0.vol1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/vol1.example.com/ca/ca.vol1.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/vol1.example.com/users
  mkdir -p organizations/peerOrganizations/vol1.example.com/users/User1@vol1.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-vol1 -M ${PWD}/organizations/peerOrganizations/vol1.example.com/users/User1@vol1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/vol1.example.com/users/Admin@vol1.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://vol1admin:vol1adminpw@localhost:7054 --caname ca-vol1 -M ${PWD}/organizations/peerOrganizations/vol1.example.com/users/Admin@vol1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/vol1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/vol1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/vol1.example.com/users/Admin@vol1.example.com/msp/config.yaml

}


function createVol2 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/vol2.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/vol2.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:qwer1234@localhost:8054 --caname ca-vol2 --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vol2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vol2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vol2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vol2.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/vol2.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-vol2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-vol2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-vol2 --id.name vol2admin --id.secret vol2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/vol2.example.com/peers
  mkdir -p organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-vol2 -M ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/msp --csr.hosts peer0.vol2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-vol2 -M ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls --enrollment.profile tls --csr.hosts peer0.vol2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/vol2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/vol2.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/vol2.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/vol2.example.com/tlsca/tlsca.vol2.example.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/vol2.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/peers/peer0.vol2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/vol2.example.com/ca/ca.vol2.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/vol2.example.com/users
  mkdir -p organizations/peerOrganizations/vol2.example.com/users/User1@vol2.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-vol2 -M ${PWD}/organizations/peerOrganizations/vol2.example.com/users/User1@vol2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/vol2.example.com/users/Admin@vol2.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://vol2admin:vol2adminpw@localhost:8054 --caname ca-vol2 -M ${PWD}/organizations/peerOrganizations/vol2.example.com/users/Admin@vol2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/vol2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/vol2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/vol2.example.com/users/Admin@vol2.example.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/example.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:qwer1234@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml


}
