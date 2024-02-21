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

{% for users in pillar['direct_key_users'] %}
{{ users['name'] }}_user_present:
  user.present:
    - name: {{ users['name'] }}
    - createhome: True
    - shell: /bin/bash

add_{{ users['name'] }}_key:
  file.append:
    - name: /root/.ssh/authorized_keys
    - text: {{ users['git_key'] }}
    {% endfor %}

{% for users in pillar['git_key_users_absent'] %}
{{ users }}_user_absent:
  ssh_auth.absent:
    - user: {{ users }}
    - source: 'https://github.com/{{ users }}.keys'
    - config: /root/.ssh/authorized_keys
    {% endfor %}

{% for users in pillar['direct_key_users_absent'] %}
{{ users['name'] }}_user_absent:
  ssh_auth.absent:
    - user: {{ users['name'] }}
    - name: {{ users['git_key'] }}
    - config: /root/.ssh/authorized_keys
    {% endfor %}
