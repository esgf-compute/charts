# ESGF WPS
[ESGF WPS](https://github.com/ESGF/esgf-compute-wps) is a software stack providing compute resource through a [Web Processing Service](https://www.ogc.org/standards/wps) interface.

## TL;DR
```console
helm install compute charts/compute
```

## Introduction
This chart deploys the [esgf-compute-wps](https://github.com/ESGF/esgf-compute-wps) software stack which provides a service
to reduce data transfer through primitive geo-spatial and temporal reduction functions. The service provides these capabilities 
through a [Web Processing Service (WPS)](https://www.ogc.org/standards/wps) interface backed by [Xarray](http://xarray.pydata.org/en/stable/) and [Dask](https://dask.org/).

## Prerequisites
* Kubernetes
* Helm

## Installing the Chart
To install the chart with the release name `compute`

```console
helm repo add esgf-compute https://nimbus2.llnl.gov/chartrepo/default
helm install compute esgf-compute/esgf-wps
```

## Uninstalling the chart

```console
helm delete compute
```

# Configuration and installation details

## Authentication

Requires not authentication for submitting WPS requests.

### No authentication

| Parameter | Value | Description |
| --- | --- | --- |
| `wps.auth.type` | `"noauth"` | Disables authentication |
| `backend.auth.enabled` | `False` | Disables backend authentication |

### Keycloak

Configure keycloak with a **confidential** client supporting `Standard Flow` and `Service Accounts`. The redirect url should be set to `http://.../wps/auth/oauth_callback`. To enable dynamic client registration using PKCE set `wps.auth.regAcessToken` with an Initial Access Token for the Keycloak realm and create a second **public** client supporting `Standard Flow`. The redirect set to `http://127.0.0.1:*` and set `Proof Key for Code Exchange Code Challange Method` to `S256`.

| Parameter | Value | Description |
| --- | --- | --- |
| `wps.auth.type` | `"keycloak"` | Enables keycloak |
| `wps.auth.url` | `nil` | Keycloak base url |
| `wps.auth.realm` | `nil` | Keycloak realm containing the client |
| `wps.auth.clientID` | `nil` | Client ID |
| `wps.auth.clientSecret` | `nil` | Client secret | 
| `wps.auth.regAccessToken` | `nil` | Keycloak Client Registration Initial Access Token |
| `backend.auth.enabled` | `True` | Backend will used authentication when communicating with RESTFul API |
| `backend.auth.clientID` | `nil` | Client ID for backend |
| `backend.auth.clientSecret` | `nil` | Client secret for backend |
| `backend.auth.tokenUrl` | `nil` | Url to Keycloak token service

## Helmsman DSF for traefik & keycloak
Download [helmsman](https://github.com/Praqma/helmsman)

```console
helmsman -f extras/development.yaml --apply
```
