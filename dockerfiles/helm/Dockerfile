FROM continuumio/miniconda3:4.8.2 as base

ARG HELM_VER=v3.2.4

RUN conda install -c conda-forge curl

RUN conda install -c conda-forge curl && \
      curl -k https://get.helm.sh/helm-${HELM_VER}-linux-amd64.tar.gz | tar -xz

FROM continuumio/miniconda3:4.8.2

COPY --from=base linux-amd64/helm /usr/local/bin/helm3

RUN conda update -n base -c defaults conda && \
      conda install -c conda-forge ruamel.yaml && \
      conda clean -a -y
