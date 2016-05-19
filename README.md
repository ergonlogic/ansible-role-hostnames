CLOUD
=====

Manage hostnames and /etc/hosts files. Currently supports Linode. AWS support coming soon.


Requirements
------------

ergonlogic.cloud ships with a custom linode.py inventory script. This inventory is required in order to provide the correct hostnames.

[Drumkit](http://github.com/ergonlogic/drumkit) is recommended.

Role Variables
--------------

    ergonlogic_hostname_provider: linode

Set which cloud provider on which the VMs are deployed.


Dependencies
------------

None.

Example Playbook
----------------

Include in as you would any other role.

    - hosts: linode
      vars:
        ergonlogic_hostname_provider: linode
      roles:
        - ergonlogic.hostnames


TODO
----

* Add support for /etc/hosts from other cloud providers.

License
-------

GPLv3 or later

Author Information
------------------

This role was created in 2016 by [Christopher Gervais](http://ergonlogic.com/).
