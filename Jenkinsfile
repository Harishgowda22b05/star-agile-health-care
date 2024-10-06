pipeline {
  agent any
     tools {
       maven 'M2_HOME'
           }
     
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from github'
        git branch: 'master', url: 'https://github.com/Harishgowda22b05/star-agile-health-care.git'
                        }
            }
    stage('Create Package') {
      steps {
        echo 'This stage will compile, test, package my application'
        sh 'mvn package'
                          }
            }
    stage('Generate Test Report') {
      steps {
        echo 'This stage generate Test report using TestNG'
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Healthcare/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                          }
            }
    stage('Create Docker Image') {
      steps {
        echo 'This stage will create a Docker image'
        sh 'docker build -t harish/healthcare:1.0 .'
                          }
            }
     stage('Login to Dockerhub') {
      steps {
        echo 'This stage will loginto Dockerhub'
        withCredentials([usernamePassword(credentialsId: 'dockerlogginuser3', passwordVariable: 'dockerlogginpass', usernameVariable: 'dockerloggginuser')]) {
        sh 'docker login -u ${dockerloggginuser} -p ${dockerlogginpass}'
            }
        }
      }
     stage('Docker Push-Image') {
      steps {
        echo 'This stage will push my new image to the dockerhub'
        sh 'docker push hgowda123/healthcare:1.0'
            }
      }
     stage('AWS-Login') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Awsaccess', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
         }
      }
    }
    stages {
    stage('Terraform Operations for Test Workspace') {
      steps {
        script {
          sh '''
            # Select or create the test workspace
            terraform workspace select test || terraform workspace new test
            terraform init
            terraform plan
            terraform destroy -auto-approve  # Consider if this is the desired flow
          '''
        }
      }
    }

    stage('Terraform Destroy & Apply for Test Workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Get Kubeconfig for Test') {
      steps {
        sh '''
          aws eks update-kubeconfig --region ap-south-1 --name test-cluster
          kubectl get nodes
        '''
      }
    }

    stage('Deploying the Application to Test') {
      steps {
        sh '''
          kubectl apply -f app-deploy.yml
          kubectl get svc
        '''
      }
    }

    stage('Terraform Operations for Production Workspace') {
      when {
        expression {
          return currentBuild.currentResult == 'SUCCESS'
        }
      }
      steps {
        script {
          sh '''
            # Select or create the production workspace
            terraform workspace select prod || terraform workspace new prod
            terraform init
            terraform plan
            terraform destroy -auto-approve  # Re-evaluate this command's placement
          '''
        }
      }
    }

    stage('Terraform Destroy & Apply for Production Workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Get Kubeconfig for Production') {
      steps {
        sh '''
          aws eks update-kubeconfig --region ap-south-1 --name prod-cluster
          kubectl get nodes
        '''
      }
    }

    stage('Deploying the Application to Production') {
      steps {
        sh '''
          kubectl apply -f app-deploy.yml
          kubectl get svc
        '''
      }
    }
  }
}
