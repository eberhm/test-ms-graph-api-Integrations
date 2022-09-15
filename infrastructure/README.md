# Terraform blueprint 
Creates the needed resources to allow to run ECS applications

## Preparation

### Login to AWS

Use our [Single Sign-On](https://fs.xing.com/adfs/ls/idpinitiatedSignon.aspx) to login to Amazon AWS console.

### Setup

We provide a [Brewfile](./Brewfile) for all necessary dependencies:

```sh
brew bundle
```

### Configuration

#### Saml2AWS

We use [saml2aws](https://github.com/Versent/saml2aws) to retrieve temporary AWS credentials. Find detailed information about the required setup [here](https://confluence.xing.hh/pages/viewpage.action?spaceKey=xingoperations&title=Getting+started+with+AWS#GettingstartedwithAWS-AWSCLI).

```sh
saml2aws login
```

## Terraform

## Best practices

The [Terraform best practices](https://www.terraform-best-practices.com/) is a good source for examples how to do things.

## Naming resources

These are our [recommendations how to name resources](https://source.xing.com/cloudcuckooland/aws-naming-convention) at New Work.

## How to build and deploy my own image?

Use script:
```sh

sh infrastructure/scripts/deployEcs.sh -r REGION -e ENVIRONMENT -a APP_NAME -t TAG (optional)

New tasks will build, push and deploy the image with the code in the current directory. 

## How to use Terragrunt?

For now, init and first deploy needs to be run manually.

### init

*init* the sandbox environment:

```sh
cd environments/sandbox
AWS_PROFILE=saml terragrunt run-all init
```

### plan

Create execution *plan* for sandbox environment without obtaining a lock:

```sh
cd environments/sandbox
AWS_PROFILE=saml terragrunt run-all plan —terragrunt-exclude-dir ./secrets
```

### apply

Create execution plan for sandbox environment, obtain a lock and *apply* changes:

```sh
cd environments/sandbox
AWS_PROFILE=saml terragrunt run-all apply —terragrunt-exclude-dir ./secrets
```


### Secrets

If you want to have secrets handled by terraform (at least creation) which is useful for referencing them on the config later, you need to create them under `/secrets` folder as terraform config. This step will only handle the creation, values need to be setted on the console for now (or using aws cli), although some values as some passwords can be generated on config.

```sh
cd environments/sandbox/secrets
AWS_PROFILE=saml terragrunt [plan or apply]
```
## Set secret value

You can set a secret value throught the cli, using saml to authenticate:

```sh
 aws secretsmanager put-secret-value \
    --secret-id my-secret-arn \
    --secret-string my-secret-value --profile saml --region AWS_REGION
```
## Destroy secrets

*This can be dangerous!* Secrets can be permanently destroyed (avoiding the 7 day wait to destroy by default) using the cli, there's a script to help with this:
```sh
cd ./
TF_ENV=preview AWS_REGION=eu-central-1 ./deleteSecrets.sh
```

## Access to ECS containers
The setup is prepared to access to the fargate containers via CLI
Execute the command like this
```
aws ecs execute-command  \
    --region eu-central-1 \
    --cluster <clusterName> \
    --task <task-id> \
    --container <container name> \
    --command "node" \
    --interactive \
    --profile=saml
```
eg
```
aws ecs execute-command  \
    --region eu-central-1 \
    --cluster marketplace-msteams-poc-proxy-cluster-preview \
    --task 8c444bad92844b20bd12f55293b95158 \
    --container marketplace-msteams-poc-proxy-container-preview-worker \
    --command "/bin/bash" \
    --interactive \
    --profile=saml
```
will allow to use the container console. 
This also requires an special setup on your local machine, this tool will allow you to know if you had everything setup:
https://github.com/aws-containers/amazon-ecs-exec-checker


