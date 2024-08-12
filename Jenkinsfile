@Library('slack') _

// *** Code for fetching Failed Stage Name *** //

import io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeGraphVisitor
import io.jenkins.blueocean.rest.impl.pipeline.FlowNodeWrapper
import org.jenkinsci.plugins.workflow.support.steps.build.RunWrapper
import org.jenkinsci.plugins.workflow.actions.Error action

// Get information about all stages, including the failure cases
// Returns a list of maps: [[ id, failedStageName, result, errors ]]
@NonCPS
List<Map> getStageResults( RunWrapper build ) {

  // Get all pipeline nodes that represent stages
  def visitor = new PipelineNodeGraphVisitor( build.rawBuild )
  def stages = visitor.pipelineNodes.findAll{ it.type == FlowNodeWrapper.NodeType.STAGE }

  return stages.collect{ stage ->
    // Get all the errors from the stage
    def errorActions = stage.getPipelineActions( ErrorAction )
    def errors = errorActions?.collect{ it.error }.unique()

    return [
      id: stage_id,
      failedStageName: stage.displayName,
      result: "${stage.status.result}",
      errors: errors
    ]
  }  
}

// Get information of all failed stages
@NonCPS
List<Map> getFailedStages( RunWrapper build ) {
  return getStageResults( build ).findAll{ it.result == 'FAILURE' }
}

// *** Code for fetching Failed Stage Name *** //

pipeline {

  agent any

  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "thatvirdiguy/numeric-app:${GIT_COMMIT}"
    applicationURL = "http://devsecops-demo.southindia.cloudapp.azure.com"
    applicationURI = "/increment/99"
  }

  stages {

    /*

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
      stage('SAST - SonarQube') {
        steps {
            withSonarQubeEnv('SonarQube') {
              sh 'mvn sonar:sonar -Dsonar.projectKey=numeric-application'
            }
            timeout(time: 2, unit: 'MINUTES') {
              waitForQualityGate abortPipeline: true
            }
          }
      }
      stage('SCA - Dependency Check') {
        steps {
              sh 'mvn dependency-check:check'
        }
      }
      stage('Container Security - Trivy + OPA Conftest') {
        steps {
          parallel (
            "Trivy": {
              sh 'bash trivy-docker-image-scan.sh'
            },
            "OPA Conftest": {
              sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
            }
          )
              
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
      stage('Kubernetes Security - OPA Conftest + Kubesec + Trivy') {
        steps {
          parallel (
            "OPA Conftest": {
              sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
            },
            "Kubesec": {
              sh 'bash kubesec-scan.sh'
            },
            "Trivy": {
              sh 'bash trivy-k8s-scan.sh'
            }
          )
        }         
      }
      stage('Kubernetes Depolyment - DEV') {
        steps {
          parallel(
            "Deployment": {
              withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'bash k8s-deployment.sh'
              }
            },
            "Rollout Status": {
              withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'bash k8s-deployment-rollout-status.sh'
              }
            }
          )
        }
      }
      stage('Integration Tests - DEV') {
        steps {
          script {
            try {
              withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'bash integration-test.sh'
              }
            } catch (e) {
              withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'kubectl -n default rollout undo deploy ${deploymentName}'
              }
            }
          }
        }
      }
      stage('DAST - OWASP ZAP') {
        steps {
          withKubeConfig([credentialsId: "kubeconfig"]) {
            sh 'bash zap.sh'
          }    
        }
      }
      stage('Promote to PROD?') {
        steps {
          timeout(time: 2, unit: 'DAYS') {
            input 'Do you want to approve the deployment to Production Environment/Namespace?'
          }   
        }
      }
      stage('Kubernetes CIS Benchmark') {
        steps {
          script {
            parallel (
              "Master": {
                sh 'bash cis-master.sh'
              },
              "Node": {
                sh 'bash cis-kubelet.sh'
              }
            )
          }   
        }
      }
      stage('Kubernetes Deployment - PROD') {
        steps {
          script {
            parallel (
              "Deployment": {
                withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'sed -i "s#replace#${imageName}#g" k8s_PROD-deployment_service.yaml'
                sh 'kubectl -n prod apply -f k8s_PROD-deployment_service.yaml'
                }
              },
              "Rollout Status": {
                withKubeConfig([credentialsId: "kubeconfig"]) {
                  sh 'bash k8s-PROD-deployment-rollout-status.sh'
                }
              }
            )
          }   
        }
      }
      stage('Integration Tests - PROD') {
        steps {
          script {
            try {
              withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'bash integration-test-PROD.sh'
              }
            } catch (e) {
              withKubeConfig([credentialsId: "kubeconfig"]) {
                sh 'kubectl -n prod rollout undo deploy ${deploymentName}'
              }
            }
          }
        }
      }

    */

      stage('Testing Slack: Success') {
        exit 0;
      }

  }


  post {
    always  {
      junit 'target/surefire-reports/*.xml'
      jacoco execPattern: 'target/jacoco.exec'
      pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
      dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report', useWrapperFileDirectly: true])
      // use sendNotification.groovy from shared library and provide current build result as parameter
      // sendNotification currentBuild.result
    }

    success {
      script {
        // use slackNotifier.groovy from shared library and provide current build result as parameter
        env.failedStage = "none"
        env.emoji = ":white_check_mark: :tada:"
        slackNotifier currentBuild.result
      }
    }

    failure {
      script {
        // use slackNotifier.groovy from shared library and provide current build result as parameter
        def failedStages = getFailedStages( currentBuild )
        env.failedStage = failedStages.failedStageName
        env.emoji = ":red_circle: :sos:"
        slackNotifier currentBuild.result
      }
    }


  }

}