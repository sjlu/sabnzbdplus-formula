jcfp-ppa:
  pkgrepo.managed:
    - humanname: jcfp
    - name: deb http://ppa.launchpad.net/jcfp/ppa/ubuntu trusty main
    - file: /etc/apt/sources.list.d/jcfp.list
    - keyid: "0x98703123E0F52B2BE16D586EF13930B14BB9F05F"
    - keyserver: keyserver.ubuntu.com
    - dist: trusty

install-sabnzbdplus:
  pkg.installed:
    - pkgs: [sabnzbdplus]
    - watch:
      - pkgrepo: jcfp-ppa

sabnzbd-user:
  file.directory:
    - name: /var/www
    - user: www-data
    - group: www-data
    - mode: 755

sabnzbd-scripts:
  file.directory:
    - name: /var/www/scripts
    - user: www-data
    - group: www-data
    - mode: 755

sabnzbd-default:
  file.managed:
    - name: /etc/default/sabnzbdplus
    - source: salt://sabnzbdplus/files/default
    - template: jinja
    - user: root
    - mode: 644

sabnzbd-stop:
  cmd.run:
    - name: /etc/init.d/sabnzbdplus stop
    - prereq:
      - file: sabnzbd-default

sabnzbd-start:
  cmd.run:
    - name: /etc/init.d/sabnzbdplus start
    - onchanges:
      - file: sabnzbd-default

sabnzbd-restart:
  cmd.wait:
    - name: sleep 2; /etc/init.d/sabnzbdplus restart
    - watch:
      - file: sabnzbd-config

sabnzbd-config:
  file.managed:
    - name: /var/www/.sabnzbd/sabnzbd.ini
    - source: salt://sabnzbdplus/files/config.ini
    - mode: 644
    - user: www-data
    - group: www-data
    - template: jinja

sabnzbd-service:
  service.running:
    - enable: True
    - name: sabnzbdplus
