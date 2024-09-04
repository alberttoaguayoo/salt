download_rclone:
  archive.extracted:
    - name: /tmp/rclone/
{% if grains['os'] == 'Rocky' %}
    - source: https://downloads.rclone.org/v{{ pillar['rclone_version'] }}/rclone-v{{ pillar['rclone_version'] }}-freebsd-amd64.zip
{% else %}
    - source: https://downloads.rclone.org/v{{ pillar['rclone_version'] }}/rclone-v{{ pillar['rclone_version'] }}-linux-amd64.zip
{% endif %}
    - archive_format: zip
    - user: root
    - group: root
    - skip_verify: True

/usr/local/bin/rclone:
  file.managed:
{% if grains['os'] == 'Rocky' %}
    - source: /tmp/rclone/rclone-v{{ pillar['rclone_version'] }}-freebsd-amd64/rclone
{% else %}
    - source: /tmp/rclone/rclone-v{{ pillar['rclone_version'] }}-linux-amd64/rclone
{% endif %}
    - mode: 755
    - require:
      - download_rclone

clean_rclone:
  file.absent:
    - name: /tmp/rclone
    - require:
      - file: /usr/local/bin/rclone
