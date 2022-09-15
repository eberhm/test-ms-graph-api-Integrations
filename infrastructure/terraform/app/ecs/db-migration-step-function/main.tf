data "aws_caller_identity" "current" {}

resource "aws_iam_role" "db_migration_state_machine" {
  name = "${var.name}-db-migration-state-machine-${var.region}"


  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "states.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

// TODO:  split into several granular aws_iam_policy_document 
resource "aws_iam_policy" "db_migration_policy" {
  name = "${var.name}-db-migration-policy-${var.region}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
          {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogDelivery",
                "logs:GetLogDelivery",
                "logs:UpdateLogDelivery",
                "logs:DeleteLogDelivery",
                "logs:ListLogDeliveries",
                "logs:PutResourcePolicy",
                "logs:DescribeResourcePolicies",
                "logs:DescribeLogGroups"
            ],
            "Resource": "*"
        },
         {
            "Effect": "Allow",
            "Action": [
                "xray:PutTraceSegments",
                "xray:PutTelemetryRecords",
                "xray:GetSamplingRules",
                "xray:GetSamplingTargets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:RunTask"
            ],
            "Resource": [
                "${var.task_definition_arn}"
            ]
        },
        {
            "Sid": "PassRolesInTaskDefinition",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "${var.execution_role_arn}",
                "${var.task_role_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:StopTask",
                "ecs:DescribeTasks"
            ],
            "Resource": "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "events:PutTargets",
                "events:PutRule",
                "events:DescribeRule"
            ],
            "Resource": [
                "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:rule/StepFunctionsGetEventsForECSTaskRule"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "db_migration_attach" {
  role       = aws_iam_role.db_migration_state_machine.name
  policy_arn = aws_iam_policy.db_migration_policy.arn
}

resource "aws_cloudwatch_log_group" "db_migration" {
  name = "${var.name}-db-migration-log-group"
}

resource "aws_sfn_state_machine" "db_migration_state_machine" {
  name     = "${var.name}-migration"
  role_arn = aws_iam_role.db_migration_state_machine.arn

  definition = templatefile("${path.module}/templates/step-function-template.json.tpl", {
    cluster_arn            = var.cluster_arn
    task_definition_arn    = var.task_definition_arn
    task_security_group_id = var.task_security_group_id
    subnets_ids            = jsonencode([for id in var.vpc_private_subnet_ids : "${id}"])
  })

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.db_migration.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }
}
