#instalation and configuration for fail2ban service

instalation:
  pkg.installed:
    - name: fail2ban

/etc/fail2ban/jail.conf:  
  file.append:
    - source: salt://fail2ban/templates/jail.conf

fail2ban:
  service.running:
    - reload: True

{% for user in pillar['users'] or [] %}
{{ user }}_user_present:
  user.present:
    - name: {{ user }}
    - createhome: True
    - shell: /bin/bash

{{ user }}_ssh_key_present:
  ssh_auth.present:
    - user: {{ user }}
    - source: 'https://github.com/{{ user }}.keys'
    - config: /root/.ssh/authorized_keys
    {% endfor %}
