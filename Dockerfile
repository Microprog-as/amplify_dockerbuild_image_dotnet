FROM amplify-console/buildimage:latest

# Install dotnet core tools
RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
RUN yum -y update && \
    yum -y install \
        dotnet-host-3.1.4 \
        dotnet-sdk-3.1

RUN dotnet tool install -g Amazon.Lambda.Tools
RUN dotnet tool install -g Amazon.Lambda.TestTool-3.1
RUN echo "export PATH=\$PATH:/root/.dotnet/tools" >> /root/.bashrc


ENTRYPOINT [ "bash", "-c" ]
