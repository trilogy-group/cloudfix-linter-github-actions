#!/bin/bash
export CLOUDFIX_FILE=true
export CLOUDFIX_TERRAFORM_LOCAL=true 
raw_recco=$(./cloudfix-linter/cloudfix-linter recco | tail +2)
echo "gh api repos/${repository}/issues/${pr_number}/comments -f body="${raw_recco}""
# res=$(gh api repos/${repository}/issues/${pr_number}/comments \
#             -f body="${raw_recco}")
# echo "${res}"