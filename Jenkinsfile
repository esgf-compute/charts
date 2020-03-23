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

helm3 repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm3 ${KUBECONFIG} dependency update compute/

helm3 ${KUBECONFIG} upgrade ${DEV_RELEASE_NAME} compute/ --atomic --timeout 300'''
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

helm3 repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm3 ${KUBECONFIG} dependency update compute/

helm3 ${KUBECONFIG} upgrade ${PROD_RELEASE_NAME} compute/ --atomic --timeout 300'''
            }

          }
        }

      }
    }

  }
}