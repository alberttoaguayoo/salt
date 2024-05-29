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
  cmd.run:
    - name: service ssh restart
