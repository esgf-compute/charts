#! /bin/bash

export LC_CTYPE=C

function image_note {
cat << EOF

This deployment is expecting a secret named "docker-registry-config-aims2" containing the credentials
to pull images from aims2.llnl.gov.

Example:
kubectl create secret docker-registry docker-registry-config-aims2 --docker-server https://aims2.lln.gov/v1/ --docker-username \${DOCKER_USERNAME} --docker-password \${DOCKER_PASSWORD}
EOF
}

function port_forward_note {
cat << EOF

Due to the way Docker/Kubernetes operates on Mac OSX port forwarding will be needed to access the WPS service.
After running the command below you will be able to access the wps service through your web browser at https://127.0.0.1:8443/.

Example:
kubectl port-foward ${1} 8443:8443
EOF
}

function usage {
cat << EOF
Flags:
  --deploy-name: Override the deployment name, defaults to ${DEPLOY_NAME}.
  --external-host: Overrides the external host.
  --remove: Completely removes the install.
  --reinstall: Will remove the chart then install a fresh chart.
EOF
}

function install_deployment {
  if [[ ! -z "$(helm list | grep ${DEPLOY_NAME})" ]]; then
    helm upgrade "${DEPLOY_NAME}" compute/ -f configs/development.yaml -f configs/traefik-dev.yaml --set wps.secretKey="${WPS_SECRET}" --set wps.externalHost="${EXTERNAL_HOST}" ${HFLAGS}
  else
    if [[ ${REINSTALL} -eq 1 ]]; then
      helm delete --purge ${DEPLOY_NAME}

      sleep 8
    fi

    helm install -n "${DEPLOY_NAME}" compute/ -f configs/development.yaml -f configs/traefik-dev.yaml --set wps.secretKey="${WPS_SECRET}" --set wps.externalHost="${EXTERNAL_HOST}" ${HFLAGS}
  fi
}

HFLAGS=""
EXTERNAL_HOST=""
DEPLOY_NAME="compute-dev-environment"
REMOVE=0
REINSTALL=0

while (( "$#" )); do
  case "${1}" in
    --deploy-name)
      shift
      DEPLOY_NAME="${1}"
      shift
      ;;
    --external-host)
      shift
      EXTERNAL_HOST="${1}"
      shift
      ;;
    --remove)
      REMOVE=1
      shift
      ;;
    --reinstall)
      REINSTALL=1
      shift
      ;;
    -h|--help)
      usage
      exit 1
      ;;
    *)
      HFLAGS="${HFLAGS} ${1}"
      shift
      ;;
  esac
done

if [[ -z "${EXTERNAL_HOST}" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    EXTERNAL_HOST="127.0.0.1:8443"
  else
    EXTERNAL_HOST="$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7):8443"
  fi
fi

WPS_SECRET="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"

if [[ ${REMOVE} -eq 1 ]]; then
  helm delete --purge ${DEPLOY_NAME}
else
  install_deployment
fi

image_note

if [[ "$(uname)" == "Darwin" ]]; then
  port_forward_note "$(kubectl get pods | grep ${DEPLOY_NAME}-compute-wps | grep -v wps-beat | tr -s ' ' | cut -d' ' -f1)"
fi
