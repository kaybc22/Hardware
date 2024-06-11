function Stress_nvme() {
date >> /opt/testing/nvqual/log/nvme_$DATE.log
fio /opt/testing/nvqual/tools/nvme.fio >> /opt/testing/nvqual/log/nvme_$DATE.log
}

DATE=$(date +%Y%m%d%H%M)
Stress_nvme 
