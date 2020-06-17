pipeline {
  agent {
    node {
      label 'jenkins-helm'
    }

  }
  stages {
    stage('Lint') {
      when {
        branch 'devel'
      }
      steps {
        container(name: 'helm', shell: '/bin/bash') {
          sh '''#! /bin/bash

helm3 lint compute/'''
        }

      }
    }

  }
}