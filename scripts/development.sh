#! /bin/bash

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
  --dev-provisioner: Puts the provisioner pod in development mode.
  --dev-webapp: Puts the webapp pod in development mode. 
  --dev-wps: Puts the wps pod in development mode.
  --dev-wps-beat: Puts the wps beat pod in development mode.
  --dev-celery: Puts the celery pod in development mode.
  --dev-celery-backend: Puts the celery backend pod in development mode.
EOF
}

function remove_deployment {
  if [[ ! -z "$(helm list | grep ${1})" ]]; then
    helm delete --purge ${1}
  fi
}

PARAMS=""
HFLAGS=""

while (( "$#" )); do
  case "${1}" in
    --dev-provisioner)
      HFLAGS="${HFLAGS} --set provisioner.development=true"
      shift
      ;;
    --dev-webapp)
      HFLAGS="${HFLAGS} --set nginx.development=true"
      shift
      ;;
    --dev-wps)
      HFLAGS="${HFLAGS} --set wps.development=true"
      shift
      ;;
    --dev-wps-beat)
      HFLAGS="${HFLAGS} --set wps.beat.development=true"
      shift
      ;;
    --dev-celery)
      HFLAGS="${HFLAGS} --set celery.development=true"
      shift
      ;;
    --dev-celery-backend)
      HFLAGS="${HFLAGS} --set celery.backend.development=true"
      shift
      ;;
    -h|--help)
      usage
      exit 1
      ;;
    *)
      PARAMS="${PARAMS} ${1}"
      shift
      ;;
  esac
done

eval set -- "${PARAMS}"

if [[ "$(uname)" == "Darwin" ]]; then
  EXTERNAL_HOST="127.0.0.1:8443"
else
  EXTERNAL_HOST="$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7):8443"
fi

WPS_SECRET="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"

remove_deployment "compute-dev-environment"

helm install -n compute-dev-environment compute/ -f configs/development.yaml -f configs/traefik-dev.yaml --set wps.secretKey="${WPS_SECRET}" --set wps.externalHost="${EXTERNAL_HOST}" ${HFLAGS}

image_note

if [[ "$(uname)" == "Darwin" ]]; then
  sleep 2

  port_forward_note "$(kubectl get pods | grep compute-dev-environment-compute-wps | grep -v wps-beat | tr -s ' ' | cut -d' ' -f1)"
fi
