This is a work in progress.

This project is a skeleton that can be used to deploy your AWS Lambdas using Terraform. 
To make it a bit useful - each lambda is a cron job.
Two versions are available : JavaScript and Scala.  
 
# Prerequisites
Install Terraform, Node and Scala

    $ brew install node sbt terraform
    
Make sure you have AWS keys setup. 

    $export AWS_ACCESS_KEY_ID=[your access key id]
    $export AWS_SECRET_ACCESS_KEY=[your secret access key]
  
To run example successfully make sure an AWS user has following IAM Policies attached: 
* CloudWatchFullAccess
* IAMFullAccess
* AWSLambdaFullAccess

Warning: These policies should never be used in production. You would probable use some static policies defined by your AWS administrator. 

#Cron jobs

The cron jobs are written in Scala/Node. 

For illustration purpose both jobs just print logs into Cloudwatch every minute.

# Run 

There are 2 parts in AWS Lambda deployment. First we have to build them and second we have to deploy them.

Building javascript project: 

    $ cd js && npm run package
 
Deployment with Terraform: 

    $ cd terraform 
    $ terraform plan 
    $ terraform apply


Run `terraform plan` first to make sure the changes are correct.

After running this you should see following output :
```
Outputs:

js_cron_job = https://console.aws.amazon.com/lambda/home?region=us-east-1#/functions/js_cron
js_cron_job_logs = https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logStream:group=%252Faws%252Flambda%252Fjs_cron

```
You can access `js_cron_job_logs` or `scala_cron_job_logs` to see that jobs are actually running and producing results every minute.

You can repeat this process a couple of times - terraform will deploy when there are changes. 

# Cleanup

After you finished, you can cleanup all AWS resources by running : 

    $ terraform destroy

