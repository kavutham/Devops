## Ansible basic commands and guide

To do dry run have to add -C to your ansible-playbook startup command
    
    $ ansible-playbook -C sampleplaybook.yml -i ansible_hosts

ansible-lint --> command line utility to be installed first. Used for linting playbook syntax. Will already have some default rules that can be listed using -L arguement.

    ansible-lint *.yml
  
ansible-vault --> to create ansible secrets encrypt or decrypt sensitive information

    $ ansible-vault create vault.yml   --> prompt for password set and prompted for password each time you do some vault operation on that file
    $ other commands --> ansible-vault encrypt filename (encrypt, decrypt, rekey, view, edit)
    $ ansible-playbook secret.yml --vault-password-file=password_file --> store the vault password in password_file and run this to avoid giving password each time
    $ ansible-vault encrypt_string --> to encrypt single string value inside yaml

ansible-playbook --> to run playbooks/play

ansible-galaxy --> to create roles

vars to define inline variables within the playbook

vars_files to import files with variables
