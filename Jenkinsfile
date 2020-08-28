pipeline {
  agent {
    node {
      label 'maven'
    }
  }

    parameters {
        string(name:'TAG_NAME',defaultValue: '',description:'')
    }

    environment {
        DOCKER_CREDENTIAL_ID = 'dockerhub-id'
        GITHUB_CREDENTIAL_ID = 'github-id'
        KUBECONFIG_CREDENTIAL_ID = 'kubeconfig-id'
        REGISTRY = 'docker.io'
        DOCKERHUB_NAMESPACE = 'sollonsun'
        GITHUB_ACCOUNT = 'sollonsun'
        APP_NAME = 'devops-java-sample'
        SONAR_CREDENTIAL_ID = 'sonar-token'
    }

    stages {
        stage ('checkout scm') {
            steps {
                checkout(scm)
            }
        }

        stage ('unit test') {
            steps {
                container ('maven') {
                    sh 'mvn clean -o -gs `pwd`/configuration/settings.xml test'
                }
            }
        }

        stage('sonarqube analysis') {
          steps {
            container ('maven') {
              withCredentials([string(credentialsId: "$SONAR_CREDENTIAL_ID", variable: 'SONAR_TOKEN')]) {
                withSonarQubeEnv('sonar') {
                 sh "mvn sonar:sonar -o -gs `pwd`/configuration/settings.xml -Dsonar.branch=$BRANCH_NAME -Dsonar.login=$SONAR_TOKEN"
                }
              }
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
          }
        }

        stage ('build & push') {
            steps {
                container ('maven') {
                    sh 'mvn -o -Dmaven.test.skip=true -gs `pwd`/configuration/settings.xml clean package'
                    sh 'docker build -f Dockerfile-online -t $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER .'
                    withCredentials([usernamePassword(passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,credentialsId : "$DOCKER_CREDENTIAL_ID" ,)]) {
                        sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
                        sh 'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER'
                    }
                }
            }
        }

}
