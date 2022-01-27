resource "aws_ecs_cluster" "xapo_cluster" {
  name = var.cluster_name # Naming the cluster
}


resource "aws_ecs_service" "bitcoin_service" {
  name            = "${var.name}-service"                    # Naming our first service
  cluster         = aws_ecs_cluster.xapo_cluster.id          # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.bitcoin_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Setting the number of containers to 1

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }
}

resource "aws_ecs_task_definition" "bitcoin_task" {
  family = "${var.name}-task" # Naming our first task
  container_definitions = jsonencode([
    {
      "name" : "bitcoin-task",
      "image" : "464624470219.dkr.ecr.ap-south-1.amazonaws.com/bitcoin-core:latest",
      "essential" : true,

      "portMappings" : [
        {
          "containerPort" : 18332,
          "hostPort" : 18332
        }
      ],
      "mountPoints" : [
        {
          "containerPath" : "/home/bitcoin/.bitcoin",
          "sourceVolume" : "efs-volumne"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/bitcoin-task",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "ecs",
          "awslogs-create-group" : "true",
        }
      },
      "memory" : 512,
      "cpu" : 256
    }
  ])
  volume {
    name = "efs-volumne"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.efs.id
      root_directory = "/"
    }
  }
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.TaskExecutionRole.arn
}
