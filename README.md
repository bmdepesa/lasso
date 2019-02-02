# lasso
A collection of scripts to speed up common tasks when working with Rancher

_I don't claim that these are good, only good enough. Please submit PRs for anything you can make better!_

## Requirements

lasso requires that the following be installed and available on your path:

* git (`brew install git`)
* tugboat (`brew install tugboat`)
  * Make sure tugboat is configured 
* awscli (`pip install awscli`)
  * Make sure awscli is configured 
* kubectl (`brew install kubernetes-cli`)
* jq (`brew install jq`)
* rke
  * get the latest release from https://github.com/rancher/rke/releases) and ensure it is available on your path

## Installation
* `cd ~/Dev/tools # anywhere you want`
* `curl https://raw.githubusercontent.com/bmdepesa/lasso/master/internet_install.sh | sh`
* Restart your terminal session

or

* Clone project
* Set `install.sh` and `config/configure.sh` to be executable (`chmod +x`)
* `./install.sh -c`
* Restart your terminal session

## Upgrading
* pull the `master` branch of this project

## Removal
* `rm -rf $LASSO_HOME`
* `rm -rf ~/.lasso/`
* remove additions from (.bashrc, .zshrc, .bash_profile) files

## Configuration
* `config/configuration.sh` will update your configuration for all(most?) scripts
* To manually view/update the configuration, all files are in `~/.lasso/`
  * `.config` - contains LASSO_HOME
  * `aws.config` - settings for AWS
  * `rancher.config` - settings for Rancher installations
  * `do.config` - settings for DO
  
Most commands/scripts can have the defaults overriden through arguments.

## Notes
* This relies on `ssh-agent`, add any keys (aws/do) with `ssh-add -K <key>`

## Scripts
* `rancher_create_ha -n <name>` 
  * Creates a Rancher HA installation (with an existing load balancer and target groups), the ami must match the region, and the ami must have Docker preinstalled.
  
More documentation to come.. read through the files to view the scripts/commands/options.
