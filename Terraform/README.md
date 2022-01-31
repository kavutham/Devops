terraform init --> initialize a terrform directory. downloads and installs the providers defined in the configuration

terraform fmt --> automatically updates configurations in the current directory for readability and consistency. Terraform will print out the names of the files it modified, if any.

terraform validate --> check configuration is syntactically valid and internally consistent

terraform plan --> shows the plan which will applied by apply command but actually not create any resource

terraform apply --> apply the configuration

terraform show --> Inspect the current state. shows the tfstate which stores all the id and senstive information of the resource it cretaed

terraform state list --> list subcommand to list of the resources in your project's state.

terraform destroy --> destroys the resource created by apply commmand

terraform apply -var "container_name=YetAnotherName" --> pass variable value using var flag

terraform output --> displays output captured from output.tf

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

    Environment variables
    The terraform.tfvars file, if present.
    The terraform.tfvars.json file, if present.
    Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
    Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)
