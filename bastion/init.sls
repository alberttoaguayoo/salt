# UFW rules
allow_http:
  cmd.run:
    - name: ufw allow 80

allow_https:
  cmd.run:
    - name: ufw allow 443

{% for access in pillar['ufw_allow'] %}
allow_{{ access['name'] }}:
  cmd.run:
    - name: ufw allow from {{ access['ip'] }} to any port {{ access['port'] }}
{% endfor %}

{% if 'docker0' in salt['network.interfaces']() %}
{% set docker_address = salt['network.interface_ip']('docker0') %}
allow_local_docker_connections:
  cmd.run:
    - name: ufw allow from {{ docker_address }}/24 to {{ docker_address }}/24
{% endif %}

# Package installation
openssh-server:
  pkg.installed

# Add required configuration file
authentication:
  file.managed:
    - name: /etc/ssh/ssh_config.d/00-bastion.conf
    - source: salt://bastion/templates/ssh_config.conf
    - mode: 600
    - makedirs: True

# Restart ssh service    
restart-ssh-service:
  cmd.run:
    - name: service ssh restart
