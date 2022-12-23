#!/bin/bash
export CLOUDFIX_FILE=true
export CLOUDFIX_TERRAFORM_LOCAL=true 
raw_recco=$(./cloudfix-linter/cloudfix-linter recco | tail +1)
echo "${raw_recco}"
echo "${pr_number}"
res=$(gh api repos/trilogy-group/terraform-github-actions/issues/${pr_number}/comments \
            -f body="${raw_recco}")
echo "${res}"