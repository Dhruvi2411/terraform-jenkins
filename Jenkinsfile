pipeline {  
    agent any

        environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
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
            steps {
                sh 'terraform plan -out=tfplan > plan_output.txt'
            }
        }

    stage('Manual Approval') {
        steps {
            script {
                def planOutput = readFile('plan_output.txt')
                input message: "Review the Terraform plan before applying:\n\n${planOutput}",
                        ok: 'Proceed with Apply'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

    }
}
