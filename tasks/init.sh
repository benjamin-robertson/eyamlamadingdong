#!/usr/bin/env bash
if puppet config print server | grep -v -q `hostname`; then
  echo "This task can only be run on the master node."; 
  exit 1
fi
/opt/puppetlabs/puppet/bin/puppet resource package hiera-eyaml ensure=present provider=puppet_gem
/bin/tee -a /etc/puppetlabs/puppet/hiera.yaml <<EOF
  - name: "Eyaml hierarchy"
    lookup_key: eyaml_lookup_key # eyaml backend
    paths:
      - "common.eyaml"
      - $PT_path
    options:
        pkcs7_private_key: "/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem"
        pkcs7_public_key: "/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem"
EOF
cd /etc/puppetlabs/puppet/;/opt/puppetlabs/puppet/bin/eyaml createkeys
#/opt/puppetlabs/puppet/bin/puppet agent -t
