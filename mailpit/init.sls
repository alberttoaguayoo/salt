/etc/compose-files/mailpit/docker-compose.yml:
  file.managed:
    - source: salt://mailpit/templates/docker-compose.yml.jinja
    - mode: 644
    - makedirs: True
    - template: jinja
    - context:
      mailpit: {{ pillar['mailpit'] }}

deploy_service:
  cmd.run:
{% if grains['osfullname'] == 'Ubuntu' and grains['osmajorrelease'] <= 22 %}
    - name: docker-compose up -d
{% else %}
    - name: docker compose up -d
{% endif %}
    - cwd: /etc/compose-files/mailpit/

