# ESGF WPS

[ESGF WPS](https://github.com/ESGF/esgf-compute-wps) is a software stack providing compute resource through a [Web Processing Service](https://www.ogc.org/standards/wps) interface.

## Introduction

This chart deploys the [esgf-compute-wps](https://github.com/ESGF/esgf-compute-wps) software stack which provides a service
to reduce data transfer through primitive geo-spatial and temporal reduction functions. The service provides these capabilities 
through a [Web Processing Service (WPS)](https://www.ogc.org/standards/wps) interface backed by [Xarray](http://xarray.pydata.org/en/stable/) and [Dask](https://dask.org/).


## Installation

### Add Helm Repository

```bash
helm repo add esgf-compute https://nimbus16.llnl.gov:8443/chartrepo/public
```

### Configure the chart

See `compute/values.yaml` for available settings.

### Install the chart

To install the chart with the release name `compute`:

```bash
helm install compute esgf-compute/compute
```
