pipeline {  
    agent any

        environment {
        // // AWS credentials from Jenkins credential store
        // AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        // AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
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

        // stage('Run AWS CLI command') {
        //   steps {
        //         script {
        //             withCredentials([
        //                 // Bind Jenkins credential ID 'my-aws-creds' to AWS standard environment variables
        //                 awsCredentials(credentialsId: 'my-aws-creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
        //             ]) {
        //                 sh '''
        //                 # The shell script can now use aws cli commands, which will automatically pick up the environment variables
        //                 echo "Listing S3 buckets using AWS CLI..."
        //                 aws s3 ls
        //                 # Ensure no secrets are echoed
        //                 '''
        //             }
        //         }
        //     }
        // }       


        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Dhruvi2411/terraform-jenkins.git'
            }
        }

        stage('Terraform Init') {
                environment {
                AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
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
                environment {
                AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            }
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            environment {
                AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

    }
}
