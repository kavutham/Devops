Notice that there is no provider block in this configuration. When Terraform processes a module block, it will inherit the provider from the enclosing configuration. Because of this, we recommend that you do not include provider blocks in modules.

Just like the root module of your configuration, modules will define and use variables.


Whenever you add a new module to a configuration, Terraform must install the module before it can be used. Both the terraform get and terraform init commands will install and updatemodules. The terraform init command will also initialize backends and install plugins.


aws s3 cp modules/aws-s3-static-website-bucket/www/ s3://$(terraform output -raw website_bucket_name)/ --recursive

terraform output
Visit the website domain in a web browser, and you will see the website contents.

https://<YOUR BUCKET NAME>.s3-us-west-2.amazonaws.com/index.html


aws s3 rm s3://$(terraform output -raw website_bucket_name)/ --recursive
terraform destroy