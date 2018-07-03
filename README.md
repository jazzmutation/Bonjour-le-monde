# Purpose

This is my response to a recruitment challenge exercise.
The key criteria for assessment are  listed in the challenge gihthub page, I will address these in this document.
- Requirements for buiding and provisioning the application.
  - These instructions assume AWS knowledge and practical experience (also some experience with Packer and Terraform would be a bonus).
  - Amazon AWS account with an IAM user with AdministratorAccess membership and an API access key. Export the keys in your terminal session:
    - export AWS_ACCESS_KEY_ID="mykeyid"
    - export AWS_SECRET_ACCESS_KEY="mysecretkey"
  - HashiCorp tools, Packer and Terraform are required. Install these tools on your workstation as per the instructions provided by HashiCorp. If you are using a Red Hat Operating System, add these tools to the beginning of your PATH to avoid a conflict with another tool called packer. 
  - install git to be able to clone this project to your local workstation home directory.
    - git clone  https://github.com/jazzmutation/bonjour-le-monde.git
    - change to the directory called bonjour-le-monde to begin deploying the simple hello world application.
- Begin the deployment by exporting your aws api keys as shown above and begin the AMI build procedure by using this command: 
  - ```make bake```
  - The Packer AMI builder will output progress as it builds the image, this will take a while.
  - On completion record the AMI ID for use in the next step to deploy the new AMI build:
  - ```make init AMI="my-new-ami-id"```
  - The terraform tool will output the progress of the initialisation step, on success proceed to the plan step:
  - ```make plan AMI="my-new-ami-id"```
  - The plan output will indicate there are 16 resources to add, now proceed to create resources:
  - ```make apply AMI="my-new-ami-id"```
  - This step will create the resources required to stand up the auto scaling load balanced web server farm for the sample application with two web servers running accross two availability zones.
  - To access the hosted sample application, copy and paste the url shown on the screen from the apply terraform output (shown in green colour).
  - After the review, these commands are used to remove the resources:
  - ```make destroy AMI="my-new-ami-id"```
  - ```rm terraform.tfstate terraform.tfstate.backup```

## Design for the solution

When I read the requirements, I realised that I had completed an earlier release of this challenge about four years ago using puppet razor for VM provisioning and puppet agent /puupet server for application deployment and configuration management. 

There were shortfalls, in that, the reviewer was unable to test my code with similar infrastructure as my homelab. This time I decided to use an AWS account for this challenge, giving the reviewer the option of spinning up the complete environment for testing.

To meet the criteria of simplicity, I decided to use tools that are pretty much the everyday tools (where I work) for provisioning on AWS, these being Packer and Terraform. I standup environments from time to time in my job role and generally use these tools. In addition, I like to use a tool called terragrunt as a terraform wrapper, it provides extra features like very clean structure for multi project code and the associated terraform state infomation.

With this Packer and Terraform challenge, I looked for a simple demo project to get started with, a more simpler outlook than an enterprise approach I am used to. With this in mind I found a simple demo and started with it (https://github.com/robmorgan/terraform-rolling-deploys). This project is fine for the challenge where terraform state information can be stored locally and no terraform record locking on a DynamoDB table is needed.

I did refer back to my VM configuration of my solution of four years ago and found the VM configuration was for Centos 6.6. With this new solution based on Centos 7.5, I found it interesting porting the work for unicorn and nginx. I had to move the unix socket location from the /tmp filesystem to /run as the /tmp filesystem is mapped to user sessions on 7.5. I migrated the init script to a systemd unit file. Other minor changes included specifiying a newer ruby version running under rvm. Systemd services provides restart options on error to increase reslisence, e.g. a failure of the unicorn service (altough the elastic load balancer has a health check that will terminate and replace a failing instance).

To understand the workflow, look at the steps for deployment show in the above how to section. Essentally it is a simple stepped approch using bake (Packer), init (Terraform), plan (Terraform), apply (Terraform) and destroy (Terraform) commands via a simple make Makefile for execution.  This stepped aproach only requires one parameter to be specifed (the AMI ID) by the user, again to keep it simple. Assumptions are that the user is happy to use the Sydney AWS region for the deploy by default. To keep it even simpler I stripped out the use of a bastion type server in private subnets to achieve a total of 16 AWS resources for the deploy. 

In respects to idempotency, I found that I was not concerned as I would normally be, like with a puppet managed guest VM. In this challenge, I am using the approch of immutable infrastructure and not concerned with maintaining the ongoing configuration in the running VM. A new image is to be created and deployed to the elastic load balancer in a staged approach with zero downtime. The new image creation trigger would be for operation system security patch cycles and application updates.

With security, I have made sure selunix is running in enforcing mode, operating system updates are applied at image creation time and the sshd service is disabled. In procdution I would migrate a web application service to TLS and add a cloudfront distribution for further protection from attacks. 

With anti-fragility, I think the auto scaling facility, cross zone load balancing feature and AWS's service improvement cycles help in this respect to react to system shocks. Also scaling policies can be configured and tuned to provide horizontal scaling under load or latency situations.

## Known issues

During the Packer AMI build, I noticed on one ocassion the ruby rvm installer failed, this appears to be due to connectivity issues with the web site hosting rvm. If this occurs, repeat the make bake command. Also I noticed that sometimes during the ruby gem installs, especially sinatra, there is a pause of a few minutes, I added a user notice when each gem is being installed indicating it may take a while.

## Improvements

I think that during the application install step in the AMI build, I would add curl commands to download the sample application files from the github site, this would add the ability to dynamically bake in the latest published application code.
 
I enjoyed this challange and I look forward to feedback from the recruitment team.

