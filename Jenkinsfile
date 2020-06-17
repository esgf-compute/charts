pipeline {
  agent none
  stages {
    stage('Lint') {
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

ls -la

helm3 lint compute/'''
        }

      }
    }

  }
}