[{
  "name": "${name}",
  "image": "${container_image_url}",
  "cpu": ${container_cpu},
  "memory": ${container_memory},
  "essential": true,
  "environment": ${container_environment},
  "secrets": [
    {
      "name": "RECOMMENDATIONS_HOST",
      "valueFrom": "${recommendations_host}"
    },
    {
      "name": "DATABASE_URL",
      "valueFrom": "${db_connection_string}"
    }
  ],
  "portMappings": [{
    "protocol": "tcp",
    "containerPort": ${container_port},
    "hostPort": ${container_port}
  }],
  "logConfiguration": { 
    "logDriver": "awslogs",
    "options":  {
      "awslogs-group": "${cloudwatch_group}",
      "awslogs-stream-prefix": "ecs",
      "awslogs-region": "${region}"
    }
  }
}]