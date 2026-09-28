#!/bin/bash

ScriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

start https://kubeconfig.test.local

read -p "Введите ваш ID Token из kubeconfig.test.local: " Token

K8sApiServer=https://api.test.local
Namespace=test_namespace
SecretName=local-env
FileName=local-env
OutputFile=$ScriptDir/.env
Url=${K8sApiServer}/api/v1/namespaces/${Namespace}/secrets/${SecretName}
DataKey=.data.\"${FileName}\"

curl -k -X GET ${Url} -H "Authorization: Bearer ${Token}" -H "Accept: application/json" | jq -r ${DataKey} | base64 -di > $OutputFile
