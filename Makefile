.PHONY: env_test

#####################
# Environment Setup #
#####################

.EXPORT_ALL_VARIABLES:
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

#####################
# Terraform Recipes #
#####################

TF_VAR_vultr_api_key = ${VULTR_API_KEY}

tf = terraform -chdir=./terraform
tf_plan:
	$(tf) plan
tf_apply:
	$(tf) apply -auto-approve
tf_destroy:
	$(tf) destroy

###############
# VPN Recipes #
###############

vpn_connect:
	echo "Connecting..."
vpn_disconnect:
	echo "Disconnecting..."

#########################
# Vultr Utility Recipes #
#########################

vultr_api_endpoint = https://api.vultr.com
paginate = jq . | less
vultr_auth_header = -H "Authorization: Bearer ${VULTR_API_KEY}"

vultr_list_plans:
	curl "$(vultr_api_endpoint)/v2/plans?cores=1" $(vultr_auth_header) -X GET | $(paginate)
vultr_list_regions:
	curl "$(vultr_api_endpoint)/v2/regions" $(vultr_auth_header) -X GET | $(paginate)


######################
# Entrypoint Recipes #
######################

up: tf_plan tf_apply vpn_connect
down: tf_destroy

env_test:
	sh -c "env"