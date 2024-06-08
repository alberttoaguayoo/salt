# Bastion server recipe

include: 
  - ufw

# Package installation
openssh-server:
  pkg.installed

# Add required configuration file
authentication:
  file.managed:
    - name: /etc/ssh/ssh_config.d/00-bastion.conf
    - source: salt://bastion/templates/ssh_config.conf
    - template: jinja
    - mode: 600
    - makedirs: True

# Restart ssh service    
restart-ssh-service:
  cmd.run:
    - name: systemctl restart sshd


