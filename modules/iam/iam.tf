resource "aws_iam_role" "iam_role_asg" {
  name = "energy_pdt.kube2iam.k8s.sit1.gb.msm.msmcloud.net"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "arn:aws:iam:::"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy_asg" {
  role = aws_iam_role.iam_role_asg.id
  policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "rds:Describe"
            ],
            "Resource":[
                "arn:aws:rds:*:*:"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
  name = 
  role = aws_iam_role.iam_role_asg.name
}