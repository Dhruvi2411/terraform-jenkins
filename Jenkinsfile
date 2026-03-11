pipeline {  
    agent any

        environment {
        // // AWS credentials from Jenkins credential store
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_IN_AUTOMATION      = 'true'
    }
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'stage', 'prod'],
            description: 'Select environment'
        )
    }



    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Dhruvi2411/terraform-jenkins.git'
            }
        }

        stage('Terraform Init') {
                environment {
                AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps {
                sh '''
                terraform init -reconfigure \
                -backend-config="bucket=terraform-state-bucket-11-03-26" \
                -backend-config="key=terraform/terraform.tfstate" \
                -backend-config="region=ap-south-1"
                '''
            }
        }

        stage('Workspace Setup') {
            steps {
                sh """
                if terraform workspace list | grep -w ${params.ENVIRONMENT}
                then
                    terraform workspace select ${params.ENVIRONMENT}
                else
                    terraform workspace new ${params.ENVIRONMENT}
                fi
                """
            }
        }

    stage('Terraform Plan') {
                environment {
                AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            environment {
                AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

    }
}
