pipeline {

  agent any
  
  stages {
      stage('Build Artifact - Maven') {
        steps {
          sh "mvn clean package -DskipTests=true"
          archive 'target/*.jar'
        }
      }
      stage('Unit Tests - JUnit and Jacoco') {
        steps {
          sh "mvn test"
        }
      }
      stage('Mutation Tests - PIT') {
        steps {
          sh "mvn org.pitest:pitest-maven:mutationCoverage"
        }
      }
      stage('SonarQube - SAST') {
        steps {
            withSonarQubeEnv('SonarQube') {
              sh 'mvn sonar:sonar -Dsonar.projectKey=numeric-application'
            }
            timeout(time: 2, unit: 'MINUTES') {
              waitForQualityGate abortPipeline: true
            }
          }
      }
      stage('Dependency Check - SCA') {
        steps {
              sh 'mvn dependency-check:check'
        }
      }
      stage('Docker Build and Push') {
        steps {
          withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
            sh 'printenv'
            sh 'docker build -t thatvirdiguy/numeric-app:""$GIT_COMMIT"" .'
            sh 'docker push thatvirdiguy/numeric-app:""$GIT_COMMIT""'
          }
        }
      }
      stage('Kubernetes Depolyment - DEV') {
        steps {
          withKubeConfig([credentialsId: "kubeconfig"]) {
            sh 'sed -i "s#replace#thatvirdiguy/numeric-app:${GIT_COMMIT}#g" k8s_deployment_service.yaml'
            sh 'kubectl apply -f k8s_deployment_service.yaml'
          }
        }
      }
    }
  post {
    always  {
      junit 'target/surefire-reports/*.xml'
      jacoco execPattern: 'target/jacoco.exec'
      pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
      dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    }
  }
}