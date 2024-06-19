# SSH configuration

#Changing ssh port
/etc/systemd/system/sockets.target.wants/ssh.socket:
  file.replace:
    - pattern: '^ListenStream=.*$'
    - repl: 'ListenStream={{ salt["pillar.get"]("ssh_config:listen_port") }}'
    - count: 1
    - backup: '.bak'
    - show_changes: True
    - append_if_not_found: True

systemctl_daemon_reload:
  cmd.run:
    - name: systemctl daemon-reload
    - shell: /bin/bash

systemctl_restart_ssh_socket:
  cmd.run:
    - name: systemctl restart ssh.socket
    - shell: /bin/bash
