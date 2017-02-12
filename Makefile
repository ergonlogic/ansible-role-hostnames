ROLES_PATH ?= tests/roles

.PHONY: hostname-test inv

init-tests: $(ROLES_PATH)/ergonlogic.cloud $(ROLES_PATH)/ergonlogic.hostnames

$(ROLES_PATH)/ergonlogic.cloud:
	git clone https://github.com/ergonlogic/ansible-role-cloud $(ROLES_PATH)/ergonlogic.cloud

$(ROLES_PATH)/ergonlogic.hostnames:
	cd $(ROLES_PATH) && ln -s ../.. ergonlogic.hostnames

hostnames-test: export ANSIBLE_ROLES_PATH = $(ROLES_PATH)
hostnames-test: init-tests generate-keypair inv
	ansible-playbook tests/hosts/setup.yml
	ansible-playbook tests/hosts/ec2.yml
	ansible-playbook tests/hosts/linode.yml
	ansible-playbook tests/hosts/cleanup.yml

inv: inventory
	inventory/ec2.py --refresh-cache
	inventory/linode.py --refresh-cache

inventory: $(ROLES_PATH)/ergonlogic.cloud
	ln -s $(ROLES_PATH)/ergonlogic.cloud/inventory/ .

-include $(ROLES_PATH)/ergonlogic.cloud/mk/common.mk
include .mk/GNUmakefile

# vi:syntax=makefile
