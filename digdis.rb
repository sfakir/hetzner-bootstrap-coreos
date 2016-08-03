#!/usr/bin/env ruby
require "rubygems"
require "hetzner-bootstrap-coreos"

# Retrieve your API login credentials from the Hetzner admin interface
# at https://robot.your-server.de and assign the appropriate environment
# variables:
#
#     $~ export HBC_ROBOT_USER="hetzner_user"
#     $~ export HBC_ROBOT_PASSWORD="verysecret"
#     $~ export HBC_IP_ADDRESS="1.2.3.4"
#     $~ export HBC_HOSTNAME="core-01.example.com"
#
# Next launch the bootstrap script:
#
#     $~ ./example.rb

bs = Hetzner::Bootstrap::CoreOS.new(
	:api => Hetzner::API.new(ENV['HBC_ROBOT_USER'], ENV['HBC_ROBOT_PASSWORD'])
)

# Main configuration (cloud-config) 
cloud_config = <<EOT
#cloud-config

hostname: <%= hostname %>
ssh_authorized_keys:
  - "<%= public_keys %>"
  - <%= public_keys %>
users:
 - name: "fakir"
   passwd: "$1$dSjBDOKO$Efdj3bfeC0D4WVyEHmUrr."
   groups:
      - "sudo"
      - "docker"
   ssh-authorized-keys:
      - "<%= public_keys %>"

EOT

# The post_install hook is the right place to launch further tasks (e.g.
# software installation, system provisioning etc.)
post_install = <<EOT
  # TODO
EOT

bs << { :ip => ENV['HBC_IP_ADDRESS'],
    :cloud_config => cloud_config,
    :hostname => ENV['HBC_HOSTNAME'],
    :public_keys => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD0beLx7n8xLGQ6rwKNaX2VSjEHUcibjODgosLPBnJrxIZnbv8mSxVoFZRcBuWB0mqN/NezmfVVxmbVfp4KdW68Ut4gNjJH0OPw/4e4skuUlexumR9hKPyACmYhSWfKLdLJABsLLbp5wQ9Z/OuKoqj6orPXigHDBcv6kWIUrmDTHknpkrS3zII3IeC0G+Gktg75OjoPRhPTIcugHVkSqz+yA/UKLdJANFNN6K4Bs9OflJEpNX9YjqxFdwtA75il05TYhnwlCmegJvx2lrOdmO8v5yevvcdZsrZ6do8dkjZb4alsGqS1uownmehaE0dytl25v+RyFIszbsia83urfq2f',
    :post_install => post_install
}

bs.bootstrap!
