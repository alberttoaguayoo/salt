{% if grains['os'] == 'Rocky' %}
download_rclone:
  archive.extracted:
    - name: /tmp/
    - source: https://downloads.rclone.org/rclone-current-linux-amd64.zip
    - archive_format: zip
    - user: root
    - group: root
    - skip_verify: True

move_rclone_binary:
  cmd.run:
    - name: "mv $(ls -d /tmp/rclone*/rclone) /usr/local/bin/"
    - unless: test -x /usr/local/bin/rclone
    - require:
      - download_rclone

clean_rclone:
  cmd.run:
    - name: "rm -rf /tmp/rclone*"
    - onlyif: ls /tmp/rclone* 1>/dev/null 2>&1
    - require:
      - move_rclone_binary

{% else %}
rclone_pkg:
  pkg.installed:
    - name: rclone
{% endif %}

