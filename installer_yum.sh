#! /bin/bash
echo "################ Instal Package node_exporter ################"
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz 
sudo tar xvf node_exporter-1.3.1.linux-amd64.tar.gz 
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/ 
sudo useradd -rs /bin/false node_exporter
echo "################ Instal Package node_exporte DONE################ "
echo "################ Move SystemD & Restart Service Node_exporter.service ################"
mv node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload && sudo systemctl enable --now node_exporter.service 
echo "################ Move SystemD & Restart Service Node_exporter.service DONE ################ "
echo "################ Instal Package Promtail ################"
curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep browser_download_url |  cut -d '"' -f 4 | grep promtail-linux-amd64.zip | wget -i -  
sudo yum install unzip && unzip promtail-linux-amd64.zip 
sudo mv promtail-linux-amd64 promtail
sudo cp promtail /usr/local/bin
sudo mkdir -p /etc/promtail
echo "################ Instal Package Promtail DONE ################ "
echo "################ Move SystemD &Restart Service promtail.service ################"
mv promtail.yaml /etc/promtail/promtail.yaml
mv promtail.service /etc/systemd/system/promtail.service
sudo systemctl daemon-reload && sudo systemctl enable --now promtail.service
echo "################ Move SystemD &Restart Service promtail.service DONE ################ "
echo "################ Check Service promtail & node_exporter ################"
STATUS1="$(systemctl is-active node_exporter.service)"
STATUS2="$(systemctl is-active promtail.service)"
if [ "${STATUS1}" = "active" ]; then
    echo "Service node_exporter = Active"
else 
    echo "Service node_exporter not running.... Please Check Your Config "   
fi
if [ "${STATUS2}" = "active" ]; then
    echo "Service promtail = Active"
else 
    echo "Service promtail not running.... Please Check Your Config "  
fi
echo "################ Test Curl Node Exporter ################"
curl localhost:9100
echo "################ Test Curl Node Exporter DONE ################ 
