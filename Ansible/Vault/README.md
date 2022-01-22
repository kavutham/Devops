**Plaintext YAML file**

    $ cat secrets_file.enc

api_key: SuperSecretPassword

**Encrypt the file with ansible-vault**

    $ ansible-vault encrypt secrets_file.enc

    $ ansible-playbook -i inventory.ini -e @secrets_file.enc --ask-vault-pass main.yml

    $ cat password_file -->store the password here in this file
    passwordblhablah

    $ ansible-playbook -i inventory.ini -e @secrets_file.enc --vault-password-file password_file main.yml

## Hasicorrp:

The Ansible community has written a number of custom modules for interacting with these types of systems.

The following playbook uses a lookup plugin to obtain a secret from HashiCorp Vault and then use that secret in a task
