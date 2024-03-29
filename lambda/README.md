# Lambda Development and Packaging for Python

This module is uses the [serverless framework](https://serverless.com/)

## Initialisation
Prepare environment with helpers to allow easy build, test and deployment of Python lambdas

```
python -m virtualenv venv
source venv/Scripts/activate
```

## Installing Serverless

This runs via node, so have an up-to-date version of node and np available in the environment, then run:

`npm install -g serverless`

## Configuring

Configure details of the service in `demoproject/config.yaml`

### Enabling Python Dependencies

Install plugin to ensure the right dependencies can be pulled into lambda, based on requirements.txt contents

`sls plugin install -n serverless-python-requirements`

To enable, add the following lines to the end of serverless.yml
```
plugins:
  - serverless-python-requirements
```
## Running Unit Tests

From lambda subdir, run the following:

`python -m unittest discover -s test`

## Running locally and testing

This will invoke a lambda called `hello` locally, showing the log output, and using the events source from the file `events/valid.json`

`serverless invoke local -f sample -l -p events/valid.json`

Test events are all held in the `events` directory, covering valid and invalid scenarios to validate behaviour.

## Deploying to AWS

This will package up the lambda, excluding development dependencies, kick off a CloudFormation stack to deploy into the AWS account set up in the environment via S3 to a stage called `dev`.

`serverless deploy --stage dev`

## Removing from AWS

This will remove the CloudFormation stack, objects from S3 bucket and lambda function.

`serverless remove`

## Running remotely

This will invoke a lambda called `hello` on AWS, showing the log output, and using the events source from the file `events/valid.json`

`serverless invoke -f sample -l -p events/valid.json`

