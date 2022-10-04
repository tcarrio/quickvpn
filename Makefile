.PHONY: env_test tf_* vpn_* vultr_* up down
.SILENT: tf_output

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
TF_VAR_wg_private_key_path = ../wg_key
TF_VAR_wg_public_key_path = ../wg_key.pub

tf = terraform -chdir=./terraform
tf_init:
	cd terraform && terraform init
tf_plan:
	$(tf) plan $(ARGS)
tf_apply:
	$(tf) apply -auto-approve
tf_destroy:
	$(tf) destroy $(ARGS)
tf_output:
	$(tf) output $(ARGS)

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


#####################
# Wireguard Recipes #
#####################

wg_key:
	(umask 0077 && wg genkey > wg_key)

wg_key.pub: wg_key
	(umask 0077 && wg pubkey < wg_key > wg_key.pub)

######################
# Entrypoint Recipes #
######################

up: wg_key.pub tf_plan tf_apply vpn_connect
down: tf_destroy
