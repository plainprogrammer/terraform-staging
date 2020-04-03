# Terraform Staging

Terraform-based setup process for creating team staging environments with
vanilla AWS resources.

## Dependencies

Run the following commands to install and configure local dependencies:

```
$ brew install aws-okta terraform
$ aws-okta add
Okta organization: mavenlink

Okta Region ([us], emea, preview): us

Okta domain [mavenlink.okta.com]: mavenlink.okta.com

Okta username: name@mavenlink.com

Okta password: secret

INFO[0045] Requesting MFA. Please complete two-factor authentication with your
second device
Enter MFA Code: 123456

INFO[0064] Added credentials for name@mavenlink.com
```

After this setup you are ready to run the various Terraform configurations, or
to begin work on your own.

## Terraforming

Terraform provides commands to plan, apply, destroy, and perform other
operations relating to cloud provider resources. The basic staging environment
this repository describes is relatively simple and is likely to only rely on
the three Terraform commands on plan, apply, and destroy.

```
$ aws-okta exec okta-dev -- terraform plan
$ aws-okta exec okta-dev -- terraform apply
$ aws-okta exec okta-dev -- terraform destroy
```

### Plan

Compares the available Terraform configuration to the current state of cloud
provider infrastructure. This command will provide a summary of what changes
would be made were the `apply` command to be run.

### Apply

Updates cloud provider infrastructure and resources to match the available
Terraform configuration.

### Destroy

Tears down cloud provider infrastructure as described in the available
Terraform configurations.

