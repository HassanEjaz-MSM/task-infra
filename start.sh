#!/bin/bash

set -e 

cd env

echo '######################################'
echo "##### Building ENV"
echo '######################################'
terraform init 
terraform validate 
terraform plan 
terraform apply -auto-approve 
terraform output  > output.txt 

echo '######################################'
echo "##### Replacing IPs and Host"
echo '######################################'
cd ..
pwd

i_p=$(cat "ansible/aws_hosts" | sed -n '2p')
current_ip=$(cat "env/output.txt" | grep jump_box | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
echo "Found jumbox IP ${i_p} updating to ${current_ip}"

sed -i "" "s|$i_p|$current_ip|g" "ansible/aws_hosts"

server_ip1=$(cat "env/output.txt" | sed -n '5p' |  tr -d '"' | tr -d " " | tr -d ",")
server_ip2=$(cat "env/output.txt" | sed -n '6p' |  tr -d '"' | tr -d " " | tr -d ",")
old_server_ip1=$(cat "ansible/aws_hosts" | sed -n '5p')
old_server_ip2=$(cat "ansible/aws_hosts" | sed -n '6p')
echo "Found server ips ${old_server_ip1} and ${old_server_ip2}  updating to ${server_ip1} and ${server_ip2}"
sed -i '' "s|${old_server_ip1}|${server_ip1}|" "ansible/aws_hosts"
sed -i '' "s|${old_server_ip2}|${server_ip2}|" "ansible/aws_hosts"

new_pgdb=$(cat "env/output.txt" | grep pgdb_endpoint | sed 's:.*=::')
echo "Found BD Endpoint ${new_pgdb}"

echo '######################################'
echo "##### Playing Ansible PLaybook"
echo '######################################'

cd ansible
ansible-playbook playbook.yaml -i aws_hosts --extra-vars "db=${new_pgdb}" 

cd ..
lb_dns=$(cat "env/output.txt" | grep lb_dns | sed 's:.*=::')
echo "LB DNS  ${lb_dns}"


