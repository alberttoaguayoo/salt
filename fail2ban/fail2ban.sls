#instalation and configuration for fail2ban service

instalation:
  pkg.installed:
    - name: fail2ban

/etc/fail2ban/jail.local:  
  file.append:
    - source: salt://fail2ban/templates/jail.conf
    - template: jinja

fail2ban:
  service.running:
    - reload: True
