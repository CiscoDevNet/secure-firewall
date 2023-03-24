data "template_file" "ftd_startup_file" {
    template = file("${path.module}/ftd_startup_file.txt")
    
}
