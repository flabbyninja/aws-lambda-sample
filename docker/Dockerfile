FROM alpine:3.10

RUN apk update
RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    echo "*** install dependencies ***" && \
    apk add openssh git && \
    pip install virtualenv awscli python-lambda
RUN echo "*** clone repo ***" && \
    mkdir data && \
    cd data && \
    git clone https://github.com/flabbyninja/aws-lambda-sample.git
CMD [ "/bin/sh" ]