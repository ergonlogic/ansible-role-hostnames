ROLES_PATH       ?= tests/roles
LINODE_INVENTORY ?= $(ROLES_PATH)/ergonlogic.cloud/inventory/linode.py
EC2_INVENTORY    ?= $(ROLES_PATH)/ergonlogic.cloud/inventory/ec2.py

init-tests: $(ROLES_PATH)/ergonlogic.cloud $(ROLES_PATH)/ergonlogic.hostnames

$(ROLES_PATH)/ergonlogic.cloud:
	git clone https://github.com/ergonlogic/ansible-role-cloud $(ROLES_PATH)/ergonlogic.cloud

$(ROLES_PATH)/ergonlogic.hostnames:
	cd $(ROLES_PATH) && ln -s ../.. ergonlogic.hostnames

linode-test: export ANSIBLE_ROLES_PATH = $(ROLES_PATH)
linode-test: init-tests generate-keypair
	ansible-playbook tests/hosts/linode/setup.yml -i $(LINODE_INVENTORY)
	ansible-playbook tests/hosts/common/test0.yml -i $(LINODE_INVENTORY)
	ansible-playbook tests/hosts/linode/cleanup.yml -i $(LINODE_INVENTORY)

ec2-test: export ANSIBLE_ROLES_PATH = $(ROLES_PATH)
ec2-test: init-tests generate-keypair
	ansible-playbook tests/hosts/ec2/setup.yml -i $(EC2_INVENTORY)
	ansible-playbook tests/hosts/common/test0.yml -i $(EC2_INVENTORY)
	ansible-playbook tests/hosts/ec2/cleanup.yml -i $(EC2_INVENTORY)

-include $(ROLES_PATH)/ergonlogic.cloud/mk/common.mk
include .mk/GNUmakefile

# vi:syntax=makefile
