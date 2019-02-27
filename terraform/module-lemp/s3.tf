#
# medias
#

data "aws_iam_policy_document" "public_s3_bucket_medias" {
  count = "${var.create_s3_medias ? 1 : 0}"

  statement {
    sid = "PublicReadAccess"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.customer}-${var.project}-medias-${var.env}/*",
    ]
  }
}

resource "aws_s3_bucket" "medias" {
  count = "${var.create_s3_medias ? 1 : 0}"

  bucket = "${var.customer}-${var.project}-medias-${var.env}"
  policy = "${data.aws_iam_policy_document.public_s3_bucket_medias.json}"
  acl    = "public-read"

  tags {
    Name       = "${var.customer}-${var.project}-medias-${var.env}"
    client     = "${var.customer}"
    env        = "${var.env}"
    project    = "${var.project}"
    cycloid.io = "true"
  }
}

#
# IAM
#

# S3 deployment policy
data "aws_iam_policy_document" "s3-medias" {
  count = "${var.create_s3_medias ? 1 : 0}"

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetObjectVersion",
      "s3:PutObjectVersionAcl",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.medias.id}",
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetObjectVersion",
      "s3:PutObjectVersionAcl",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.medias.id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3-medias" {
  count       = "${var.create_s3_medias ? 1 : 0}"
  name        = "${var.project}-${var.env}-s3-medias_access"
  description = "Grant s3 medias access on bucket ${aws_s3_bucket.medias.id}"
  policy      = "${data.aws_iam_policy_document.s3-medias.json}"
}

resource "aws_iam_user" "s3-medias" {
  count = "${var.create_s3_medias ? 1 : 0}"
  name  = "s3-medias-${var.project}-${var.env}"
  path  = "/"
}

resource "aws_iam_access_key" "s3-medias" {
  count = "${var.create_s3_medias ? 1 : 0}"
  user  = "${aws_iam_user.s3-medias.name}"
}

resource "aws_iam_user_policy_attachment" "s3-medias_access" {
  count      = "${var.create_s3_medias ? 1 : 0}"
  user       = "${aws_iam_user.s3-medias.name}"
  policy_arn = "${aws_iam_policy.s3-medias.arn}"
}

output "iam_s3-medias_user_key" {
  value = "${aws_iam_access_key.s3-medias.0.id}"
}

output "iam_s3-medias_user_secret" {
  value = "${aws_iam_access_key.s3-medias.0.secret}"
}

output "s3_medias" {
  value = "${aws_s3_bucket.medias.0.id}"
}
