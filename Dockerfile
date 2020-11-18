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

# Install Python 3.8
RUN curl https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz --output /tmp/Python-3.8.1.tgz
RUN cd /tmp && tar xzf Python-3.8.1.tgz 
WORKDIR /tmp/Python-3.8.1/
RUN ./configure --enable-optimizations
RUN make altinstall
RUN pip3.8 install --user pipenv pylint
RUN ln -fs /usr/local/bin/python3.8 /usr/bin/python3
RUN ln -fs /usr/local/bin/pip3.8 /usr/bin/pip3
RUN echo "export PATH=/root/.local/bin:${PATH}" >> /root/.bashrc

ENTRYPOINT [ "bash", "-c" ]
