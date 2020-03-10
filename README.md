
# esgf-compute-wps

[esgf-compute-wps](https://github.com/ESGF/esgf-compute-wps) is a software stack built to provide compute capabilites through a web service. 

## Introduction

The service consists of a 1.0.0 WPS server. The service accepts requests created by the [esgf-compute-api](https://github.com/ESGF/esgf-compute-api) library. These compute graphs are converted using Xarray and submitted to a dynamically allocated and scaled Dask cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 2.11+
- Proxy/Load-balancer; This chart was developed with Traefik in mind
- Prometheus server to collect metrics
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install compute/ --name my-release
```
The command deploys esgf-compute-wps on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                        | Global Docker image registry                                                                                                                        | `nil`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install compute/ --name my-release \
  --set password=secretpassword
```

The above command sets the Redis server password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install compute/ --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

## Persistence

By default, the chart mounts various [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/). The volumes are created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```bash
$ helm install compute --name my-release --set persistence.existingClaim=PVC_NAME
```
