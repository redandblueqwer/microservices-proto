#!/bin/bash
SERVICE_NAME=$1
RELEASE_VERSION=$2

# 安装依赖
sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# 确保目标目录存在
mkdir -p ./golang/${SERVICE_NAME}

# 生成protobuf代码
protoc --go_out=./golang --go_opt=paths=source_relative \
       --go-grpc_out=./golang --go-grpc_opt=paths=source_relative \
       ./${SERVICE_NAME}/*.proto

# 初始化Go模块
cd golang/${SERVICE_NAME}
go mod init github.com/redandblueqwer/microservices-proto/golang/${SERVICE_NAME} || true
go mod tidy
cd ../../

# 配置git并提交更改
git config --global user.email "2296096713@qq.com"
git config --global user.name "redandblueqwer"
git add . && git commit -am "proto update" || true
git tag -fa golang/${SERVICE_NAME}/${RELEASE_VERSION} -m "golang/${SERVICE_NAME}/${RELEASE_VERSION}"
git push origin refs/tags/golang/${SERVICE_NAME}/${RELEASE_VERSION}