# amplify_dockerbuild_image_dotnet
 


https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html

https://github.com/aws-amplify/amplify-console/issues/685


here is the step-by-step procedure to get this to work.

git clone https://github.com/aws-amplify/amplify-console.git
cd amplify-console/images/latest && docker build -t amplify-console/buildimage:latest .
Create your own Dockerfile with the following...
`FROM amplify-console/buildimage:latest

RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
RUN yum -y update && \
    yum -y install \
        dotnet-host-3.1.4 \
        dotnet-sdk-3.1

RUN dotnet tool install -g Amazon.Lambda.Tools
RUN dotnet tool install -g Amazon.Lambda.TestTool-3.1
RUN echo "export PATH=\$PATH:/root/.dotnet/tools" >> /root/.bashrc

ENTRYPOINT [ "bash", "-c"]`


Build and push your image to Dockerhub.
In the Amplify Console, wire up your custom image in the Build Settings.