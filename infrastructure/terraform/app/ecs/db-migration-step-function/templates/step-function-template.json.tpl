{
  "Comment": "Run migration on ECS",
  "StartAt": "run-migration",
  "States": {
    "run-migration": {
      "Type": "Task",
      "End": true,
      "Resource": "arn:aws:states:::ecs:runTask.sync",
      "Retry": [
        { 
          "ErrorEquals": [
            "States.ALL"
          ],
          "IntervalSeconds": 1,
          "BackoffRate": 2.0,
          "MaxAttempts": 0
        }
      ],
      "Parameters": {
        "LaunchType": "FARGATE",
        "Cluster": "${cluster_arn}",
        "TaskDefinition": "${task_definition_arn}",
        "NetworkConfiguration": {
          "AwsvpcConfiguration": {
            "Subnets": ${subnets_ids},
            "AssignPublicIp": "DISABLED",
            "SecurityGroups": [
              "${task_security_group_id}"
            ]
          }
        }
      }
    }
  }
}
