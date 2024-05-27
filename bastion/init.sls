# Bastion server recipe

#package installation
openssh-server:
  pkg.installed

# Add required configuration file
authentication:
  file.managed:
    - name: /etc/ssh/ssh_config.d/00-bastion.conf
    - source: salt://bastion/templates/ssh_config.conf
    - mode: 600
    - makedirs: True

# Restart sshd service    
restart-ssh-service:
  service.running:
    - name: sshd
    - enable: True
    - reload: True

#firewall_rules

{% for access in pillar['ufw_allow'] %}
allow_{{ access['name'] }}:
  cmd.run:
    - name: ufw allow from {{ access['ip'] }} to any port {{ access['port'] }}
{% endfor %}

deny_traffic:
  cmd.run:
    - name: ufw default deny incoming
    - name: ufw default deny outgoing
