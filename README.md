# Sample repo creating 2 Consul Datacenters

Code is separated in different folders so it is more modular.
Only terraform.tfvars file is missing that has to be fullfilled in both folders for DC1 and DC2.

```
aws_access_key = ""

aws_secret_key = ""

instance_type = "t1.micro"

security_group_id = [""]

region = "us-east-1"

```

Every folder will contain its own state file.
In the folders that we create the clients we are consuming the state of the respective Datacenter.
This is done in order to use the outputs from the module as inputs for the Consul clients so no variables are used.

# How to use:

1. Navigate to `code_that_use_consul_module_dc1`
- `terraform init`
- `terraform get -update`
- `terraform plan`
- `terraform apply`

Now you have created the first consul datacenter.

2. Navigate to `code_that_use_consul_module_dc2`
- `terraform init`
- `terraform get -update`
- `terraform plan`
- `terraform apply`

After apply finish the second Datacenter should be available on the UI.

3. Navigate to `code_for_client_in_dc1`
- `terraform init`
- `terraform plan`
- `terraform apply`
- When it asks for AWS region provide `us-east-1`

Now you will have nginx client in DC1.

4. Navigate to `code_for_client_in_dc1`
- `terraform init`
- `terraform plan`
- `terraform apply`
- When it asks for AWS region provide `us-east-1`

Now you will have nginx client in DC2.

Consul-Template is set on clients. It gets and replaces the default nginx homepage from the value in KV store.