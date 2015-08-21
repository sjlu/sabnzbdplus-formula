jcfp-ppa:
  pkgrepo.managed:
    - humanname: jcfp
    - name: deb http://ppa.launchpad.net/jcfp/ppa/ubuntu precise main
    - file: /etc/apt/sources.list.d/jcfp.list
    - keyid: "0x98703123E0F52B2BE16D586EF13930B14BB9F05F"
    - keyserver: keyserver.ubuntu.com
    - dist: precise

install-sabnzbdplus:
  pkg.installed:
    - pkgs: [sabnzbdplus]
    - watch:
      - pkgrepo: jcfp-ppa
  service.running:
    - enable: True
    - name: sabnzbdplus

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
    - watch_in:
      - service: sabnzbdplus
    - require:
      - file: sabnzbd-user

sabnzbd-config:
  file.managed:
    - name: /var/www/.sabnzbd/sabnzbd.ini
    - source: salt://sabnzbdplus/files/config.ini
    - mode: 644
    - user: www-data
    - group: www-data
    - template: jinja
    - watch_in:
      - service: sabnzbdplus
    - require:
      - file: sabnzbd-user
