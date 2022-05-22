# learn_tf

## 0. Initial Configuration
### 0.1 Install terraform
### 0.2 Install aws manager
### 0.3 Set up aws user with IAM
## 1. General Setup
### 1.0 Configure AWS creds
Run the following to configure aws creds:
```bash 
aws configure
```
1. AWS Access Key ID:

1. AWS Secret Access Key:

1. Default region name: us-east-2

1. Default output format: JSON

Run the following to initialize terraform:
```bash
terraform init
```

### 1.1 Terraform Files and Modules
Terraform files are files with the `.tf` extension. 

Terraform generates `.tfstate` and `.tfstate.backup` files when running `terraform apply`, which may contain secrets, and so should **NEVER** be uploaded to repositories. They should be added to `.gitignore` file. 

Terraform also generates `.tfstate/` directories, which also should **NEVER** be uploaded to repositories, so they should also be added to `.gitignore` files. 

Terraform references the folder it is in when using `terraform apply`, with no way of specifying a specific `.tf` file to run. This means every piece of IaC written should be organized into separate folders, or, in Terraform jargon, **modules**. For instance, the following will not allow us to run `terraform apply` for specific pieces of infrastructure, ie `.tf` files:
```bash
folder/
    |- infra1.tf
    |- infra2.tf
    |- terraform.tfstate
    |- .terraform.lock.hcl
```
The more desirable way to organize `.tf` files is by **modules**, like so:
```bash
folder/
    |- infra1/
            |- infra1.tf
            |- terraform.tfstate
            |- .terraform.lock.hcl
    |- infra2/
            |- infra2.tf
            |- terraform.tfstate
            |- .terraform.lock.hcl
```

### 1.2 Useful Terraform Commands
-  `terraform init` - Prepare your working directory for other commands
-  `terraform validate` - Check whether the configuration is valid
-  `terraform plan` - Show changes required by the current configuration
-  `terraform apply` - Create or update infrastructure
-  `terraform destroy` - Destroy previously-created infrastructure
-  `terraform graph` - Generate a Graphviz graph of the steps in an operation. 
    - eg: `terraform graph > test1_graph.dot`
    - `dot -Tsvg test1_graph.dot > test1_graph.svg`