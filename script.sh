#!/bin/bash
terraform_init=$(terraform init)
status=$?
if [ $status != 0 ] 
then
    echo "Terraform Init Error\n${terraform_init}"
    exit 1
fi
echo "Terraform Init\n"

terraform_validate=$(terraform validate -no-color)
status=$?
if [ $status != 0 ] 
then
    echo "Terraform Validate Error\n${terraform_validate}"
    exit 1
fi
echo "Terraform Validate\n${terraform_validate}"

terraform_show=$(terraform show -json | head -2 | tail -1 > tf.show)
status=$?
if [ $status != 0 ] 
then
    echo "Terraform Show Error\n${terraform_show}"
    exit 1
fi
echo "Terraform Show\n"

mock_recco=$(python gen_recco.py tf.show)
status=$?
if [ $status != 0 ] 
then
    echo "Error in Mock recommendation\n${mock_recco}"
    exit 1
fi
echo "Generated Mock Recommendations\n"

install=$(bash installScript.sh)
status=$?
if [ $status != 0 ] 
then
    echo "install error\n ${install}"
    exit 1
fi
echo "Installed tflint and cloudfixLinter"

linter_init=$(./cloudfix-linter/cloudfix-linter init)
status=$?
if [ $status != 0 ] 
then
    echo "Cloudfix-Linter init\n${linter_init}"
    exit 1
fi
echo "Cloudfix-Linter initialized"

export CLOUDFIX_FILE=true
export CLOUDFIX_TERRAFORM_LOCAL=true 
raw_recco=$(./cloudfix-linter/cloudfix-linter recco | tail +2)
markup_recco=$(python beautifier.py "${raw_recco}")
res=$(gh api repos/${repository}/issues/${pr_number}/comments \
            -f body="${markup_recco}")
status=$?
if [ $status != 0 ] 
then
    echo "API ERROR ${res}"
    exit 1
fi