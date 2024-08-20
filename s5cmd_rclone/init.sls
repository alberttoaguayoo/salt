{% if grains['os'] == 'Rocky' %}
download_rclone:
  cmd.run:
    - name: curl -Lo /tmp/rclone.zip https://downloads.rclone.org/rclone-current-linux-amd64.zip
    - creates: /tmp/rclone.zip

extract_rclone:
  cmd.run:
    - name: unzip /tmp/rclone.zip -d /tmp && mv /tmp/rclone*/rclone /usr/local/bin/ && rm /tmp/rclone.zip
    - unless: test -x /usr/local/bin/rclone
    - require:
      - cmd: download_rclone

verify_rclone_installation:
  cmd.run:
    - name: /usr/local/bin/rclone version
    - require:
      - cmd: extract_rclone

{% else %}
rclone_pkg:
  pkg.installed:
    - name: rclone

rclone_check_version:
  cmd.run:
    - name: rclone version
{% endif %}

#s5cmd
download_s5cmd:
  cmd.run:
    - name: curl -Lo /tmp/s5cmd.tar.gz https://github.com/peak/s5cmd/releases/latest/download/s5cmd_2.2.2_Linux-64bit.tar.gz
    - creates: /tmp/s5cmd.tar.gz 

extract_s5cmd:
  cmd.run:
    - name: tar -xzf /tmp/s5cmd.tar.gz -C /tmp && mv /tmp/s5cmd /usr/local/bin/ && rm /tmp/s5cmd.tar.gz
    - require:
      - cmd: download_s5cmd

verify_s5cmd_installation:
  cmd.run:
    - name: /usr/local/bin/s5cmd version
    - require:
      - cmd: extract_s5cmd
