{% if grains['os'] == 'Rocky' %}
download_rclone:
  archive.extracted:
    - name: /tmp/rclone/
    - source: https://downloads.rclone.org/v{{ pillar['rclone_version'] }}/rclone-v{{ pillar['rclone_version'] }}-freebsd-amd64.zip
    - archive_format: zip
    - user: root
    - group: root
    - skip_verify: True

move_rclone_binary:
  cmd.run:
    - name: "mv $(ls -d /tmp/rclone/rclone*/rclone) /usr/local/bin/"
    - unless: test -x /usr/local/bin/rclone
    - require:
      - download_rclone

clean_rclone:
  file.absent:
    - name: /tmp/rclone
{% else %}
rclone_pkg:
  pkg.installed:
    - name: rclone
{% endif %}

