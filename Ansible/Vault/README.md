# Plaintext YAML file

$ cat secrets_file.enc

api_key: SuperSecretPassword

# Encrypt the file with ansible-vault

$ ansible-vault encrypt secrets_file.enc

$ ansible-playbook -i inventory.ini -e @secrets_file.enc --ask-vault-pass main.yml

$ cat password_file 

password

$ ansible-playbook -i inventory.ini -e @secrets_file.enc --vault-password-file password_file main.yml