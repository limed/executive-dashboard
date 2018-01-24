provider "aws" {
  region  = "${var.region}"
}

module "info" {
  source      = "github.com/nubisproject/nubis-terraform//info?ref=develop"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

module "worker" {
  source                = "github.com/nubisproject/nubis-terraform//worker?ref=v2.0.4"
  region                = "${var.region}"
  environment           = "${var.environment}"
  account               = "${var.account}"
  service_name          = "${var.service_name}"
  purpose               = "webserver"
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  security_group_custom = true
  security_group        = "${aws_security_group.grafana-access.id}"
  min_instances         = "1"
  wait_for_capacity_timeout = "20m"
}

resource "aws_security_group" "grafana-access" {
  name_prefix = "${var.service_name}-${var.environment}-"

  vpc_id      = "${module.info.vpc_id}"

  tags        = {
    Name            = "${var.service_name}-${var.environment}"
    Region          = "${var.region}"
    Environment     = "${var.environment}"
    TechnicalOwner  = "${var.technical_owner}"
    Backup          = "true"
    Shutdown        = "never"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      "${module.info.ssh_security_group}",
    ]
  }

  # allow sso to communicate with grafana
  ingress {
    from_port       = "3000"
    to_port         = "3000"
    protocol        = "tcp"
    security_groups = [
      "${module.info.sso_security_group}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
