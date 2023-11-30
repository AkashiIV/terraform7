terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
    }
  }
}

provider "vultr" {
  api_key = "SILLVA2A6J3F6S4SKKSNXAPFNZFMWNFF2MRA"
}

# Déclarez le groupe de pare-feu
resource "vultr_firewall_group" "my_firewallgroup" {
  description = "base firewall"
}

# Déclarez la règle du pare-feu
resource "vultr_firewall_rule" "my_firewallrule" {
  firewall_group_id = vultr_firewall_group.my_firewallgroup.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "my firewall rule"
}

# Déclarez le script de démarrage
resource "vultr_startup_script" "my_script" {
  name   = "echo_path"
  script = filebase64("script.sh")
}

# Déclarez l'instance Vultr en utilisant les ressources précédemment définies
resource "vultr_instance" "example" {
  label             = "julienfvm"
  plan              = "vc2-1c-1gb"
  region            = "fra"
  os_id             = 1743
  script_id         = vultr_startup_script.my_script.id
  firewall_group_id = vultr_firewall_group.my_firewallgroup.id
}

output "instance_ip" {
  value = vultr_instance.example.main_ip
}
