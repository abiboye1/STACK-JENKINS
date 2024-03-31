data "template_file" "bootstrapCliXXASG" {
  template = file(format("%s/scripts/bootstrapCliXXASG", path.module))
  vars={
    GIT_REPO     =  "https://github.com/stackitgit/CliXX_Retail_Repository.git"
    MOUNT_POINT  =  "/var/www/html"
    WP_CONFIG    =  "/var/www/html/wp-config.php"
    RDS_INSTANCE =  var.stack_controls["clixx_create"] == "Y" ? aws_db_instance.CliXX[0].endpoint : ""
    LB_DNS       =  var.stack_controls["clixx_create"] == "Y" ? aws_lb.clixx_lb[0].dns_name : ""
    EFS_DNS      =  var.stack_controls["clixx_create"] == "Y" ? aws_efs_file_system.clixx_efs[0].dns_name : ""
    # DB_USER      =  var.db_user_clixx
    # DB_PASSWORD  =  var.db_password
    DB_USER      = local.db_creds.db_user_clixx
    DB_PASSWORD  =  local.db_creds.db_password
  }
}

data "template_file" "bootstrapBlogASG" {
  template = file(format("%s/scripts/bootstrapBlogASG", path.module))
  vars={
    GIT_REPO     =  "https://github.com/abiboye1/MY_STACK_BLOGS.git"
    MOUNT_POINT  =  "/var/www/html/blog"
    WP_CONFIG    =  "/var/www/html/wp-config.php"
    # DB_NAME      =  var.db_name
    # DB_USER      =  var.db_user_blog
    # DB_PASSWORD  =  var.db_password
    DB_NAME      = local.db_creds.db_name
    DB_USER      = local.db_creds.db_user_blog
    DB_PASSWORD  = local.db_creds.db_password
    db_email     =  "yomioye007@gmail.com"
    RDS_INSTANCE = var.stack_controls["blog_create"] == "Y" ? aws_db_instance.Blog[0].endpoint : ""
    LB_DNS       = var.stack_controls["blog_create"] == "Y" ? aws_lb.blog_LB[0].dns_name : ""
    EFS_DNS      = var.stack_controls["blog_create"] == "Y" ? aws_efs_file_system.blog_efs[0].dns_name : ""
    
  }
}