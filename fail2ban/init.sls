#instalation and configuration for fail2ban service

instalation:
  pkg.installed:
    - name: fail2ban

/etc/fail2ban/jail.local:  
  file.managed:
    - source: salt://templates/jail.conf
    - template: jinja

restart_fail2ban:
  cmd.run:
    - name: fail2ban-client restart

{% for users in pillar['git_key_users'] %}
{{ users }}_user_present:
  user.present:
    - name: {{ users }}
    - createhome: True
    - shell: /bin/bash

{{ users }}_ssh_key_present:
  ssh_auth.present:
    - user: {{ users }}
    - source: 'https://github.com/{{ users }}.keys'
    - config: /root/.ssh/authorized_keys
    {% endfor %}

{% for users in pillar['no_git_key_users'] %}
add_{{ users['name'] }}_key:
  file.append:
    - name: /root/.ssh/test
    - text: {{ users['git_key'] }}
    {% endfor %}
 

