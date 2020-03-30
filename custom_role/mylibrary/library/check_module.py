#!/usr/bin/python

import subprocess
from ansible.module_utils.basic import *

def is_running(name):
    process = subprocess.Popen("ps -ef | grep -i %s | grep -v grep" % (name), shell=True, stdout=subprocess.PIPE)
    exist = process.communicate()[0]
    if exist:
        return True
    else:
        return False

def main():
    fields = {
        "name": {"default": True, "type": "str"}
    }

    module = AnsibleModule(argument_spec=fields, supports_check_mode=True)

    if module.check_mode:
        module.exit_json(changed=False)

    name = str(module.params['name'])
    results= {}
    if is_running(name) == True:
        results.update({
            "changed": False,
            "msg": "Process is running"
            })
        module.exit_json(**results)
    else:
        results.update({
            "changed": False,
            "msg": "Process is NOT running"
            })
        module.fail_json(**results)

if __name__ == '__main__':
    main()