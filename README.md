# gateway-service

The API for Gateway.

npm install
npm install -g gulp
npm install -g coffee-script

### npm commands

* `npm run build` -- Build the javascript from coffeescript
* `npm test` -- Run the mocha tests in the test directory.
* `npm start` -- Run the program locally.

### Install mongodb locally if you want to run this locally

```
docker pull mongo
docker run --name some-mongo -d mongo -p 21017:21017
```

### Docker: to build and run a docker image locally:

docker build -t gateway . -f Docker_micro.docker 

docker run -it -p 3000:3000 -e NODE_ENV=local --rm --name gateway-service gateway-service

docker stop [container id]

cleanup: 
docker rm -v $(docker ps -a -q -f status=exited)
docker rmi $(docker images -f dangling=true -q)

### Continuous Integration:

The build and test pipeline is at: https://jk.builddirect.com/job/gateway-service-build as gateway-service.

### Deployment is to AWS through a build pipeline: 

https://console.aws.amazon.com/codepipeline/home?region=us-east-1#/view/gateway-service

Configuration of the database comes from two files on s3: 
https://console.aws.amazon.com/s3/home?region=us-east-1&bucket=bd-auth-keys&prefix=api/

### Docker Repository Instructions: 

Now that your repository exists, you can push a Docker image by following these steps:

To install the AWS CLI and Docker and for more information on the steps below, visit the ECR documentation page.
1) Retrieve the docker login command that you can use to authenticate your Docker client to your registry:

`aws ecr get-login --region us-east-1`

2) Run the docker login command that was returned in the previous step.

`docker run gateway-service`

(you can use '-e DB='someurl' for environment variables)

other runtime commands:
`docker ps`
`docker stop [id]`

3) Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here. You can skip this step if your image is already built:

`docker build -t gateway-service .`

4) After the build completes, tag your image so you can push the image to this repository:

`docker tag gateway-service:latest 419539186404.dkr.ecr.us-east-1.amazonaws.com/gateway-service:latest`

5) Run the following command to push this image to your newly created AWS repository:

`docker push 419539186404.dkr.ecr.us-east-1.amazonaws.com/gateway-service:latest`

### Running Tests:

To run the tests you have to set the environment variables REX_PASSWORD, AWS_ACCESS_KEY_ID, and AWS_SECRET_ACCESS_KEY.
