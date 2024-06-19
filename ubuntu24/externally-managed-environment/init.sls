#Python error: externally-managed-environment

/root/.config/pip/pip.conf:
  file.managed:
    - source: salt://externally-managed-environment/templates/pip.conf
    - template: jinja
    - makedirs: True
    - mode: 600
