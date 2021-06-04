# mp24
# github
rm -f cron_host.sh; curl https://raw.githubusercontent.com/Moriartii/mp24/main/v5.sh -o cron_host.sh; chmod +x cron_host.sh; sudo ./cron_host.sh

# intranet
rm -f cron_host.sh; curl http://10.10.11.137:5000/host-changer -o cron_host.sh; chmod +x cron_host.sh; sudo ./cron_host.sh
