#!/bin/bash
terraform_init=$(terraform init)
echo "Terraform Init\n${terraform_init}"

terraform_validate=$(terraform validate -no-color)
echo "Terraform Validate\n${terraform_validate}"

terraform_show=$(terraform show -json | head -2 | tail -1 > tf.show)
echo "Terraform Show\n${terraform_show}"

mock_recco=$(python gen_recco.py tf.show)
echo "Generate Mock Reccomendations\n${mock_recco}"

install=$(bash installScript.sh)
echo "Installing tflint and cloudfix-linter\n${install}"

linter_init=$(./cloudfix-linter/cloudfix-linter init)
echo "Cloudfix-Linter init\n${linter_init}"

export CLOUDFIX_FILE=true
export CLOUDFIX_TERRAFORM_LOCAL=true 
raw_recco=$(./cloudfix-linter/cloudfix-linter recco | tail +2)
markup_recco=$(python beautifier.py "${raw_recco}")
echo "gh api repos/${repository}/issues/${pr_number}/comments -f body="${markup_recco}""
res=$(gh api repos/${repository}/issues/${pr_number}/comments \
            -f body="${markup_recco}")
echo "${res}"