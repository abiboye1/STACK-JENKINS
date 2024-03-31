####################LOAD-BALANCERS##########################
resource "aws_lb" "clixx_lb" {
  count = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  name                = "Stack-alb"
  internal            = false
  load_balancer_type  = "application"
  # subnets             = [for s in data.aws_subnet.stack_sub : s.id]
  subnets             = [aws_subnet.CLIXX-PUB.id, aws_subnet.CLIXX-PUB2.id]
  security_groups     = [aws_security_group.CLIXX-PUB-SG.id]
  depends_on          = [ aws_vpc.main ]
}

resource "aws_lb_target_group" "clixx_tg" {
  count           = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  name            = "Stack-alb-tp"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = aws_vpc.main.id
  depends_on      = [ aws_vpc.main ]

  health_check {
    matcher             = "200"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2

  } 
}

resource "aws_lb_listener" "clixx" {
  count                 = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  load_balancer_arn     = aws_lb.clixx_lb[count.index].arn
  port                  = 80
  protocol              = "HTTP"
  depends_on            = [ aws_vpc.main ]

  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.clixx_tg[count.index].arn     
    } 
}  

resource "aws_launch_template" "L_T" {
  count         = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  name          = "Clixx_LT"
  image_id      = var.ami
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.bootstrapCliXXASG.rendered)
  depends_on    = [ aws_vpc.main ]

  # vpc_security_group_ids = [aws_security_group.CLIXX-PUB-SG.id]
  # tags =  {
  # }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.CLIXX-PUB-SG.id]
  }  

  dynamic "block_device_mappings" {
    for_each = [for vol in var.dev_names : {
      device_name           = "/dev/${vol}"
      virtual_name          = "ebs_dsk-${vol}"
      delete_on_termination = true
      encrypted             = false
      volume_size           = 10
      volume_type           = "gp2"
    }]
    content {
      device_name  = block_device_mappings.value.device_name
      virtual_name = block_device_mappings.value.virtual_name

      ebs {
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
      }
    }
  }
}

resource "aws_autoscaling_group" "clixx_auto_scale" {
  count = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  name                      = "Clixx_ASG"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 30
  health_check_type         = "EC2"
  # vpc_zone_identifier       = var.subnet_ids
  vpc_zone_identifier       = [aws_subnet.CLIXX-PUB.id, aws_subnet.CLIXX-PUB2.id]
  depends_on                = [ aws_vpc.main ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.L_T[count.index].id
    version = aws_launch_template.L_T[count.index].latest_version #"$Latest"
  }

  tag {
    key                 = "Name"
    value               = "CliXX-ASP"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.clixx_tg[count.index].arn]
}

# auto_scale up policy
resource "aws_autoscaling_policy" "auto_scale_up" {
  count                  = var.stack_controls["clixx_create"] == "Y" ? 1 : 0 ## New
  name                   = "CliXX-asp-${count.index}"                      ## New
  autoscaling_group_name = aws_autoscaling_group.clixx_auto_scale[count.index].name  ##New
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "30"
  policy_type            = "SimpleScaling"
  depends_on             = [ aws_vpc.main ]
}

# auto_scale down policy
resource "aws_autoscaling_policy" "auto_scale_down" {
  count                  = var.stack_controls["clixx_create"] == "Y" ? 1 : 0 ## New
  name                   = "CliXX-asp-scale-down${count.index}"                      ## New
  autoscaling_group_name = aws_autoscaling_group.clixx_auto_scale[count.index].name  ##New
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "30"
  policy_type            = "SimpleScaling"
  depends_on             = [ aws_vpc.main ]
}

########################################################################
############################### BLOG ###################################
########################################################################
resource "aws_lb" "blog_LB" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  name                = "Blog-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.CLIXX-PUB-SG.id] ### TO BE MODIFIED
  subnets             = [aws_subnet.CLIXX-PUB.id]  ### TO BE MODIFIED
  # subnets             = [for s in data.aws_subnet.stack_sub : s.id]
}
   
resource "aws_lb_target_group" "blog_tg" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  name            = "Blog-alb-tp"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = aws_vpc.main.id

  health_check {
    matcher             = "200"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2

  } 
} 

resource "aws_lb_listener" "blog" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  load_balancer_arn     = aws_lb.blog_LB[count.index].arn
  port                  = 80
  protocol              = "HTTP"
  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.blog_tg[count.index].arn     
    } 
}

resource "aws_launch_template" "blog_L_T" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  name          = "Blog-alt"
  image_id      = var.ami
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.bootstrapBlogASG.rendered)

  vpc_security_group_ids = [aws_security_group.CLIXX-PUB-SG.id] ### TO BE MODIFIED
  tags =  {
  }

  dynamic "block_device_mappings" {
    for_each = [for vol in var.dev_names : {
      device_name           = "/dev/${vol}"
      virtual_name          = "ebs_dsk-${vol}"
      delete_on_termination = true
      encrypted             = false
      volume_size           = 10
      volume_type           = "gp2"
    }]
    content {
      device_name  = block_device_mappings.value.device_name
      virtual_name = block_device_mappings.value.virtual_name

      ebs {
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
      }
    }
  }
}

resource "aws_autoscaling_group" "blog_auto_scale" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  name                      = "Blog-ASP"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 30
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.subnet_ids

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.blog_L_T[count.index].id
    version = aws_launch_template.blog_L_T[count.index].latest_version #"$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Blog-ASP"
    propagate_at_launch = true
  }
  target_group_arns = [aws_lb_target_group.blog_tg[count.index].arn]
}



# auto_scale up policy
resource "aws_autoscaling_policy" "blog_auto_scale_up" {
  count                  = var.stack_controls["blog_create"] == "Y" ? 1 : 0 ## New
  name                     = "Blog-asp-${count.index}"                      ## New
  # name                   = "Blog-asp"
  autoscaling_group_name = aws_autoscaling_group.blog_auto_scale[count.index].name
  # autoscaling_group_name = aws_autoscaling_group.blog_auto_scale.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}


#auto_scale down policy
resource "aws_autoscaling_policy" "blog_auto_scale_down" {
  count                  = var.stack_controls["blog_create"] == "Y" ? 1 : 0 ## New
  name                   = "Blog-auto-scale-down-${count.index}"                      ## New
  # name                   = "Blog-asp"
  autoscaling_group_name = aws_autoscaling_group.blog_auto_scale[count.index].name
  # autoscaling_group_name = aws_autoscaling_group.blog_auto_scale.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

