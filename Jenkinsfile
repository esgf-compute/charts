pipeline {
  agent {
    node {
      label 'jenkins-helm'
    }

  }
  stages {
    stage('Deploy Dev') {
      parallel {
        stage('Deploy Dev') {
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

helm ${KUBECONFIG} upgrade ${DEV_RELEASE_NAME} compute/ -f /compute-env/development.yaml --atomic --timeout 300'''
            }

          }
        }

        stage('Production') {
          steps {
            container(name: 'helm', shell: '/bin/bash') {
              sh '''#! /bin/bash

KUBECONFIG="--kubeconfig /jenkins-config/jenkins-config"

helm ${KUBECONFIG} init --client-only

helm repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm ${KUBECONFIG} dependency update compute/

helm ${KUBECONFIG} upgrade ${PROD_RELEASE_NAME} compute/ -f /compute-env/production.yaml --atomic --timeout 300'''
            }

          }
        }

      }
    }

  }
}