{% if grains['osfullname'] == 'Rocky Linux' %}
repo:
  file.managed:
    - name: /var/log/{{ pillar['cluster']['version'] }}
configure-postgresql-repo:
  pkgrepo.managed:
    - name: pgdg{{ pillar['cluster']['version'] }}
    - humanname: "PostgreSQL {{ pillar['cluster']['version'] }} for RHEL / Rocky / AlmaLinux {{ grains['osmajorrelease'] }} - {{ grains['osarch'] }}"
    - baseurl: https://download.postgresql.org/pub/repos/yum/{{ pillar['cluster']['version'] }}/redhat/rhel-{{ grains['osmajorrelease'] }}-{{ grains['osarch'] }}
    - gpgcheck: 1
    - gpgkey: https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG
    - file: /etc/yum.repos.d/pgdg.repo

update-rocky-packages:
  cmd.run:
    - name: dnf update -y
    - shell: /bin/bash
{% elif grains['osfullname'] == 'Ubuntu' %}
download-postgresql-key:
  file.managed:
    - name: /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
    - source: https://www.postgresql.org/media/keys/ACCC4CF8.asc
    - source_hash: sha256=0144068502a1eddd2a0280ede10ef607d1ec592ce819940991203941564e8e76
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

add-postgresql-repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt {{ grains['lsb_distrib_codename'] }}-pgdg main
    - dist: {{ grains['lsb_distrib_codename'] }}-pgdg
    - file: /etc/apt/sources.list.d/pgdg.list

update-ubuntu-packages:
  pkg.latest:
    - pkgs:
      - 'postgresql'
{% endif %}

