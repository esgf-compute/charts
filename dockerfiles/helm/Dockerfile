FROM continuumio/miniconda3:4.8.2 as base

ARG HELM_VER=v3.2.4
ARG KUBECTL_VER=v1.18.0

RUN conda install -c conda-forge curl

RUN conda install -c conda-forge curl && \
      curl -k https://get.helm.sh/helm-${HELM_VER}-linux-amd64.tar.gz | tar -xz && \
      curl -kLO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VER}/bin/linux/amd64/kubectl

FROM continuumio/miniconda3:4.8.2

COPY --from=base linux-amd64/helm /usr/local/bin/helm
COPY --from=base kubectl /usr/local/bin/kubectl

RUN conda update -n base -c defaults conda && \
      conda install -c conda-forge ruamel.yaml && \
      conda clean -a -y
