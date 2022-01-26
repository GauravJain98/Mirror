data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ECSCloudWatchPolicy" {
  name = "ECSCloudWatchPolicy-381966"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "EnableCreationAndManagementOfECSCloudwatchLogGroupsAndStreams",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "logs:CreateLogGroup"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/ecs/*"
      }
    ]
  })
}

resource "aws_iam_role" "TaskExecutionRole" {
  name               = "TaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cloud_policy" {
  role       = aws_iam_role.TaskExecutionRole.name
  policy_arn = aws_iam_policy.ECSCloudWatchPolicy.arn
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.TaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "EFSWrite_policy" {
  role       = aws_iam_role.TaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}
