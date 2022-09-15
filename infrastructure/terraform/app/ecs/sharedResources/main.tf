resource "aws_iam_role" "nw_role_ecs_task_execution_role" {
  name = "${var.name}-${var.environment}-ecs-task-execution-role-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "nw_role_ecs_tasks" {
  name = "${var.name}-${var.environment}-ecs-task-role-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.nw_role_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_SQS_access_attachment" {
  role       = aws_iam_role.nw_role_ecs_tasks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_SSM_access_attachment" {
  role       = aws_iam_role.nw_role_ecs_tasks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy" "execution_role_secret_policy" {
  name = "execution_role_secret_policy"
  role = aws_iam_role.nw_role_ecs_task_execution_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "${data.aws_secretsmanager_secret_version.recommendations_host_secret.arn}",
          "${data.aws_secretsmanager_secret.db_connection_string_secret.arn}"
        ]
      }
    ]
  }
  EOF
}

output "task_execution_role" {
  value = aws_iam_role.nw_role_ecs_task_execution_role
}

output "ecs_tasks_role" {
  value = aws_iam_role.nw_role_ecs_tasks
}
