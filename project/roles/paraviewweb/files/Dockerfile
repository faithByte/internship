FROM kitware/paraviewweb:pvw-v5.7.0-rc2-osmesa

COPY 001-pvw.conf			/etc/apache2/sites-available/
COPY config-template.json	/opt/launcher/config-template.json

# RUN /opt/paraviewweb/scripts/addEndpoints.sh visualizer /opt/paraview/share/paraview-5.6/web/visualizer/www

# ENV SERVER_NAME="192.168.49.2"
# ENV PROTOCOL="ws"

ENTRYPOINT ["/opt/paraviewweb/scripts/start.sh"]