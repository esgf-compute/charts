FROM continuumio/miniconda3:4.8.2 as base

RUN conda install -c conda-forge curl

FROM base as helm3

RUN conda install -c conda-forge curl && \
      curl https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz | tar -xz

FROM base as helm2

RUN conda install -c conda-forge curl && \
      curl https://get.helm.sh/helm-v2.16.3-linux-amd64.tar.gz | tar -xz

FROM continuumio/miniconda3:4.8.2

COPY --from=helm3 linux-amd64/helm /usr/local/bin/helm3
COPY --from=helm2 linux-amd64/helm /usr/local/bin/helm

RUN conda update -n base -c defaults conda && \
      conda install -c conda-forge ruamel.yaml
