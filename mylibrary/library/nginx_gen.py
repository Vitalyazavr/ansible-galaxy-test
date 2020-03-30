#!/usr/bin/python

# from string import Template
import os.path
from ansible.module_utils.basic import *

def main():
    fields = {
        "filename": {"required": True, "type": "str"},
        "hostname": {"required": True, "type": "str"},
        "listen": {"required": True, "type": "str"},
        "proxy_ip": {"required": True, "type": "str"},
        "proxy_port": {"required": True, "type": "str"},
        "location": {"required": True, "type": "str"}
    }

    module = AnsibleModule(argument_spec=fields, supports_check_mode=True)

    if module.check_mode:
        module.exit_json(changed=False)

    templay = '''server ?
      listen {listen};
      server_name  {hostname};
      location {location} ?
          proxy_pass http://{ip}:{port}/;
      !
    !
    '''
    config=templay.format(listen = module.params['listen'], hostname = module.params['hostname'],
                          location = module.params['location'], ip = module.params['proxy_ip'],
                          port = module.params['proxy_port'])

    config = config.replace('?','{').replace('!','}')
    filename = '/etc/nginx/default.d/'+module.params['filename']+'.conf'
    results = {}
    if not os.path.exists(filename):
      with open(filename,"a") as file:
          file.write(config)
      results.update({
            "changed": True
            })
    else:
      results.update({
            "changed": False
            })
    module.exit_json(**results)

if __name__ == '__main__':
    main()