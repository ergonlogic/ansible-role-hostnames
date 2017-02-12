ROLES_PATH ?= tests/roles

.PHONY: hostname-test inv

init-tests: $(ROLES_PATH)/ergonlogic.cloud $(ROLES_PATH)/ergonlogic.hostnames

$(ROLES_PATH)/ergonlogic.cloud:
	git clone https://github.com/ergonlogic/ansible-role-cloud $(ROLES_PATH)/ergonlogic.cloud

$(ROLES_PATH)/ergonlogic.hostnames:
	cd $(ROLES_PATH) && ln -s ../.. ergonlogic.hostnames

hostnames-test: export ANSIBLE_ROLES_PATH = $(ROLES_PATH)
hostnames-test: init-tests generate-keypair inv
	if ! out=`ansible-playbook tests/hosts/setup.yml`; then echo $$out; fi
	if ! out=`make inv`; then echo $$out; fi
	ansible-playbook tests/hosts/apply_ec2.yml
	ansible-playbook tests/hosts/apply_linode.yml
	ansible-playbook tests/hosts/check_ec2.yml
	ansible-playbook tests/hosts/check_linode.yml
	if ! out=`make inv`; then echo $$out; fi
	if ! out=`ansible-playbook tests/hosts/cleanup.yml`; then echo $$out; fi

cleanup: export ANSIBLE_ROLES_PATH = $(ROLES_PATH)
cleanup: inv
	ansible-playbook tests/hosts/cleanup.yml

inv: inventory
	inventory/ec2.py --refresh-cache
	inventory/linode.py --refresh-cache

inventory: $(ROLES_PATH)/ergonlogic.cloud
	ln -s $(ROLES_PATH)/ergonlogic.cloud/inventory/ .

-include $(ROLES_PATH)/ergonlogic.cloud/mk/common.mk
include .mk/GNUmakefile

# vi:syntax=makefile
