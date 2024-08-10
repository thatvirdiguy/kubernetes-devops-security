pipeline {
  agent any
  stages {
      stage('Build Artifact') {
        steps {
          sh "mvn clean package -DskipTests=true"
          archive 'target/*.jar'
        }
      }
      stage('Unit Tests - JUnit and Jacoco') {
        steps {
          sh "mvn test"
        }
        post {
          always  {
            junit 'target/surefire-reports/*.xml'
            jacoco execPattern: 'target/jacoco.exec'
          }
        }
      }
      stage('Mutation Tests - PIT') {
        steps {
          sh "mvn org.pitest:pitest-maven:mutationCoverage"
        }
        post {
          always  {
            pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          }
        }
      }
      stage('SonarQube - SAST') {
        steps {
            sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName="numeric-application" -Dsonar.host.url=http://devsecops-demo.southindia.cloudapp.azure.com:9000 -Dsonar.token=sqp_e6d844b591cfb935f5426d3ff297fecf6fec4aa7'
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
}