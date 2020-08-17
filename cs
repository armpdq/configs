[Unit]
Description=cocopacket probe

[Service]
# -config path - set path to the slave's config file
# probeExecutable (bellow) is based on the architecture you have downloaded

ExecStart=/opt/cocopacket/probeExecutable -config /opt/cocopacket/probeConfig.json
Restart=always

[Install]
WantedBy=multi-user.target
