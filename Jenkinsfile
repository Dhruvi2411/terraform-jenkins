pipeline {  
    agent any

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
                sh '''
                WORKSPACE=${ENVIRONMENT}

                if terraform workspace list | grep -w $WORKSPACE
                then
                    echo "Workspace exists. Selecting..."
                    terraform workspace select $WORKSPACE
                else
                    echo "Workspace not found. Creating..."
                    terraform workspace new $WORKSPACE
                fi
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

    }
}
