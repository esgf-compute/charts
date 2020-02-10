pipeline {
  agent any
  stages {
    stage('Deploy Dev') {
      agent {
        node {
          label 'jenkins-helm'
        }

      }
      when {
        branch 'devel'
      }
      steps {
        container(name: 'helm', shell: '/bin/bash') {
          sh '''#! /bin/bash

KUBECONFIG="--kubeconfig /jenkins-config/jenkins-config"

cd charts/

helm ${KUBECONFIG} init --client-only

helm repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm ${KUBECONFIG} dependency update compute/

helm ${KUBECONFIG} upgrade ${DEV_RELEASE_NAME} compute/ -f config/development.yaml -f config/resources.yaml --wait --timeout 300'''
        }

      }
    }

  }
}