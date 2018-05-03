#!/bin/bash -e

# Install VSCODE repo
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders


# Install git 
sudo apt-get install -y git

# Install terraform
curl -o terraform.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform.zip
mkdir -p ./local/bin
mv terraform ./local/bin/

PATH="/home/markitoxs/.local/bin/:$PATH"
export PATH

# Install zsh
sudo apt-get install -y zsh
chsh $(whoami) -s $(which zsh)

# Install python and ruby
sudo apt-get install -y python rbenv
