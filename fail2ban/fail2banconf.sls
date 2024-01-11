#instalation and configuration for fail2ban service

instalation:
  pkg.installed:
    - name: fail2ban

/etc/fail2ban/jail.local:
  file.copy:
    - source: /etc/fail2ban/jail.conf

sshd_modified:
  file.append:
    - name: /etc/fail2ban/jail.local
    - source: salt://fail2ban/resources/jail.local
    - template: jinja

fail2ban:
  service.running:
    - reload: True
