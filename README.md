# fov

### fabric network 만들기
cd ./fabric-network

./network.sh up && createChannel

### chaincode 설치
./network.sh deployCC

### fabric network & chaincode 삭제
./network.sh down

### up, createChannel, deployCC
./network.sh start