download_s5cmd:
  archive.extracted:
    - name: /tmp/s5cmd/
    - source: https://github.com/peak/s5cmd/releases/latest/download/s5cmd_{{ pillar['s5cmd_version'] }}_Linux-64bit.tar.gz
    - archive_format: tar
    - enforce_toplevel: False
    - user: root
    - group: root
    - skip_verify: True

/usr/local/bin/s5cmd:
  file.managed:
    - source: /tmp/s5cmd/s5cmd
    - mode: 755
    - require:
      - download_s5cmd

clean_s5cmd:
  file.absent:
    - name: /tmp/s5cmd
    - require:
      - file: /usr/local/bin/s5cmd


