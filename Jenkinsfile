pipeline {
  agent {
    node {
      label 'jenkins-helm'
    }

  }
  stages {
    stage('Deploy') {
      parallel {
        stage('Development') {
          when {
            branch 'devel'
          }
          steps {
            container(name: 'helm', shell: '/bin/bash') {
              sh '''#! /bin/bash

KUBECONFIG="--kubeconfig /jenkins-config/jenkins-config"

helm ${KUBECONFIG} init --client-only

helm repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm ${KUBECONFIG} dependency update compute/

helm ${KUBECONFIG} upgrade ${DEV_RELEASE_NAME} compute/ -f /compute-dev-env/development.yaml --atomic --timeout 300'''
            }

          }
        }

        stage('Production') {
          when {
            branch 'master'
          }
          steps {
            container(name: 'helm', shell: '/bin/bash') {
              sh '''#! /bin/bash

KUBECONFIG="--kubeconfig /jenkins-config/jenkins-config"

helm ${KUBECONFIG} init --client-only

helm repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm ${KUBECONFIG} dependency update compute/

helm ${KUBECONFIG} upgrade ${PROD_RELEASE_NAME} compute/ -f /compute-prod-env/production.yaml --atomic --timeout 300'''
            }

          }
        }

      }
    }

  }
}