{% if grains['osfullname'] == 'Rocky Linux' and grains['osmajorrelease'] >= 9 %}
dependencies_ufw:
  pkg.latest:
    - refresh: True
    - pkgs:
      - epel-release

install_ufw:
  cmd.run:
    - name: dnf install -y ufw
{% endif %}

enable_ufw:
{% if grains['osfullname'] == 'Rocky Linux' %}
  service.enabled:
    - name: ufw
{% else %}
  cmd.run:
    - name: ufw --force enable
{% endif %}

{% if grains['osfullname'] == 'Ubuntu' %}
allow_http_https:
  cmd.run:
    - name: ufw allow 80 && ufw allow 443
{% endif %}

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

