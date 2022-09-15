How to manage the environment variables for workflow deployment

1. Create an ECR repository to store your images.
   For example: `aws ecr create-repository --repository-name my-ecr-repo --region us-east-2`.
   Replace the value of the `ECR_REPOSITORY` environment variable in the workflow below with your repository's name.
   Replace the value of the `AWS_REGION` environment variable in the workflow below with your repository's region.

2. Create an ECS task definition, an ECS cluster, and an ECS service.
   For example, follow the Getting Started guide on the ECS console:
   https://us-east-2.console.aws.amazon.com/ecs/home?region=us-east-2#/firstRun
   Replace the value of the `ECS_SERVICE` environment variable in the workflow below with the name you set for the Amazon ECS service.
   Replace the value of the `ECS_CLUSTER` environment variable in the workflow below with the name you set for the cluster.

3. Store your ECS task definition as a JSON file in your repository.
   The format should follow the output of `aws ecs register-task-definition --generate-cli-skeleton`.
   Replace the value of the `ECS_TASK_DEFINITION` environment variable in the workflow below with the path to the JSON file.
   Replace the value of the `CONTAINER_NAME` environment variable in the workflow below with the name of the container
   in the `containerDefinitions` section of the task definition.

4. Store an IAM user access key in GitHub Actions secrets named `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
   Permission required:
   - "ec2:DescribeTags",
   - "ecs:CreateCluster",
   - "ecs:DeregisterContainerInstance",
   - "ecs:DiscoverPollEndpoint",
   - "ecs:Poll",
   - "ecs:RegisterContainerInstance",
   - "ecs:StartTelemetrySession",
   - "ecs:UpdateContainerInstancesState",
   - "ecs:Submit\*",
   - "ecr:GetAuthorizationToken",
   - "ecr:BatchCheckLayerAvailability",
   - "ecr:GetDownloadUrlForLayer",
   - "ecr:BatchGetImage",
   - "logs:CreateLogStream",
   - "logs:PutLogEvents"