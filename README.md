# AWS Amplify Console & builidng dotnet core lambda functions

I added my first [dotnet core lambda function](https://aws.amazon.com/blogs/developer/introducing-net-core-support-for-aws-amplify-backend-functions/) to an *Amplify* app, and on my first Amplify console build, I got the error:
`Unable to find dotnet version 3.1 on the path.`

## The problem

The cause of the error message was that dotnet tools are not installed in the default *Amplify Console* build image. I was looking into installing the dotnet tools as steps in the `amplify.yml` when I found this the Github issue [#685](https://github.com/aws-amplify/amplify-console/issues/685) reported by @CoreyPritchard.

Lucky for me @alexkates had already described a better fix in a comment to the [github issue](https://github.com/aws-amplify/amplify-console/issues/685#issuecomment-685684624), with creating a *custom Docker image* to build with instead.

## The solution

Since I love CI/CD pipelines, I decided to automate the steps provided by @alexkates in an *AWS CodeBuild project*.

### This Github repo

The files that are doing the job here are:

* `buildspec.yml`
  Automate the steps from cloning the AWS Amplify console latest image repo, login into Docker Hub, building the images and pushing the new build image to Docker Hub.
* `Dockerfile`
  Describes the additions needed in the docker image to make dotnet core builds work. See comments in it for more info.

### AWS Codebuild project

I followed the this [Docker sample for CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) when setting up the project, but connected it to this repository so this `buildspec.yml` and `Dockerfile` are used.

Environment variables that muyst be set up for the project:

* IMAGE_REPO_NAME
The Docker Hub image repository name including the user/organisation. Example `your docker hub user or organisation`/`repository name` .
* IMAGE_TAG
 Normally "latest".
* DOCKER_HUB_USER
A Docker Hub username
* DOCKER_HUB_TOKEN
 An access token for the username yoo provided

### Make your Amplify app use the new build image

After the first succesfull build of the new docker image, you must wire up your custom image in the *Amplify Console* Build Settings. See  [Configure Amplify to use the custom docker image](https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html) on how to do it.

## Possible improvements

* The provision of the build image from Docker Hub seems to be slow. A possible improvement is to push it to Amazon Elastic Container Registry instead of Docker Hub
* The access token is printed in the log
Use the `-password-stdin`  instead of `-password` argument when login to docker hub. See [docs](https://docs.docker.com/engine/reference/commandline/login/).
* Customize the AWS Dockerfile and remove everything that is not necesarry to improve load time.
