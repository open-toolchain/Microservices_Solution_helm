FROM ibmcom/ibmnode:4 as ibmnode
FROM alpine as ibmcloud

RUN apk update
RUN apk add ca-certificates openssl wget curl bash
RUN update-ca-certificates  2>/dev/null || true

RUN wget --quiet --output-document /usr/local/bin/kubectl  https://storage.googleapis.com/kubernetes-release/release/$(wget --quiet --output-document - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN wget --quiet --output-document /tmp/get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get && \
    chmod +x /tmp/get_helm.sh && /tmp/get_helm.sh

RUN if [ -z ${GITLTS_VERSION+x} ]; then \
      GITLTS_VERSION=$(wget --quiet --output-document - "https://api.github.com/repos/git-lfs/git-lfs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^\"]+)".*/\1/'); \
    fi && \
    wget --quiet --output-document - https://github.com/git-lfs/git-lfs/releases/download/${GITLTS_VERSION}/git-lfs-linux-amd64-${GITLTS_VERSION:1}.tar.gz | tar xz  && \
    mv git-lfs-*/git-lfs /usr/local/bin

FROM selenium/standalone-chrome

USER root 
RUN apt-get -qqy update && \
    apt-get -qqy install git && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY --from=ibmnode /usr/local/ /usr/local
COPY --from=ibmcloud /usr/local /usr/local
RUN wget --quiet --output-document - http://public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/latest/Bluemix_CLI_amd64.tar.gz  | tar xz  -C /tmp && \
    /tmp/Bluemix_CLI/install_bluemix_cli && \
    bx config --check-version false && \
    bx plugin install container-service -r Bluemix && \
    bx plugin install container-registry -r Bluemix && \
    bx plugin install cloud-functions -r Bluemix && \
    bx --version && \
    bx plugin list && \
    helm init --client-only && \
    git lfs install && \
    rm -fr /tmp/*

ENV NODE_HOME=/usr/local/bin/node/bin/ \
    PATH=/usr/local/bin/node/bin:$PATH
