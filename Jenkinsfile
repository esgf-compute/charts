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

helm3 repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm3 dependency update compute/

helm3 upgrade ${DEV_RELEASE_NAME} compute/ --atomic --timeout 3m -f development.yaml'''
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

helm3 repo add --ca-file /ssl/llnl.ca.pem stable https://kubernetes-charts.storage.googleapis.com/

helm3 dependency update compute/

helm3 upgrade ${PROD_RELEASE_NAME} compute/ --atomic --timeout 3m'''
            }

          }
        }

      }
    }

  }
}