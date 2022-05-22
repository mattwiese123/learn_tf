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

Terraform generates `.tfstate` and `.tfstate.backup` files when running `terraform apply`, which may contain secrets, and so should **NEVER** be uploaded to repositories. They should be added to `.gitignore` file. Instead, `.tfstate` files should be stored in an S3 bucket so the team can reference the same state for infrastructure management. This allows locking state so parallel executions don't coincide. This also enables sharing output vlaues with other Terraform configuration or code. 

The following snippet is an example of telling terraform where to store the `.tfstate` file. Note, the bucket must first exist in order for this configuration to be valid.
```terraform
terraform {
    backend "s3" {
        region  = "us-east-1"
        key     = "terraformstatefile"
        bucket  = "supersecrets3bucket"
    }
}
```

Terraform also generates `.terraform/` directories, which also should **NEVER** be uploaded to repositories, so they should also be added to `.gitignore` files. 

Terraform has variables. It is best practice to separate the variables into a separate file, `variables.tf` from the main code body, `main.tf`.

Terraform references the folder it is in when using `terraform apply`, with no way of specifying a specific `.tf` file to run. This means every piece of IaC written should be organized into separate folders, or, in Terraform jargon, **modules**. For instance, the following will not allow us to run `terraform apply` for specific pieces of infrastructure, ie `.tf` files:
```bash
folder/
    |- infra1.tf
    |- infra2.tf
    |- variables.tf
    |- terraform.tfstate
    |- .terraform.lock.hcl
```
The more desirable way to organize `.tf` files is by **modules**, like so:
```bash
folder/
    |- infra1/
            |- main.tf
            |- variables.tf
            |- terraform.tfstate
            |- .terraform.lock.hcl
    |- infra2/
            |- main.tf
            |- variables.tf
            |- terraform.tfstate
            |- .terraform.lock.hcl
```

### 1.2 Useful Terraform Commands
-  `terraform init` - Prepare your working directory for other commands
-  `terraform validate` - Check whether the configuration is valid
-  `terraform plan` - Show changes required by the current configuration
-  `terraform apply` - Create or update infrastructure
-  `terraform destroy` - Destroy previously-created infrastructure
-  `terraform graph` - Generate a Graphviz graph of the steps in an operation. eg:
    - `terraform graph > test1_graph.dot`
    - `dot -Tsvg test1_graph.dot > test1_graph.svg`

### 1.3 Terraform State
`terraform.tfstate` files are stored locally by defualt, but can be stored remotely in something like S3. It maps real-world resources to Terraform configuration and tracks resource dependency metadata. Prior to any modification operation, Terraform refreshes the state file.

- `terraform state` has the following subcommands:
    - `list` - List resources in the state
    - `mv` - Move an item in the state
    - `pull` - Pull current state and output to stdout
    - `push` - Update remote state from a local state file
    - `replace-provider` - Replace provider in the state
    - `rm` - Remove instances from the state
        - Useful if you want to preserve a resource
    - `show` - Show a resource in the state
        - Useful to get specifics of a resource managed by Terraform

### 1.4 Terraform Variables
#### 1.4.1 Variable Syntax
#### 1.4.2 Types
Terraform has the following primitive types:
- number
    - ` replicas = 3`
- string
    - `name = "cluster2"`
- bool
    - `backup = true`

Terraform has complex types which can be divided into 2 subtypes:
1. **collection**: complex types which allow multiple values of **one** primitive type to be grouped together
1. **structural**: complex types which allow multiple values of **different** primitive types to be grouped together.

Terraform has the following complex types:
- list (collections)
    ```terraform 
    variable "mylist" {
        type = list(string)
        default = ["string1", "string2"]
    } 
    ```
- tuple (collections, structural)
      ```terraform 
    variable "mylist" {
        type = list(string)
        default = ("string1", "string2")
    } 
    ```
- map (collections)
- set (collections, structural)
- object (structural)
    ```terraform
    variable "instructor" {
        type = object({
            name = string
            age = number
        })
    }
    ```
### 1.5 Terraform Modules

### 1.6 Terraform Built-In functions
Here is a [reference of built-ins](https://www.terraform.io/docs/configurations/functions.html).

Consider the following block. What would the Name be?

```terraform
variable "project-name" {
    type = string
    default = "prod"
}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = join("-",["terraform", var.project-name])
    }
}
```
The `Name` variable would have the value of "terraform-prod".

Terraform functions can be explored in `terraform console`