#!/usr/bin/env bash
sudo ls
reset
echo -e "\e[38;5;77m    »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [0%]     ««\e[0m"

sudo apt-get update 

rese
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [2%]     ««\e[0m"
sudo apt-get upgrade -y

reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [3%]     ««\e[0m"
sudo apt-get install libreadline-dev -y
reset 
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [4%]     ««\e[0m"
sudo apt-get install libconfig-dev -y

reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [5%]     ««\e[0m"
sudo apt-get install libssl-dev -y

reset 
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [6%]     ««\e[0m"
sudo apt-get install lua5.2 -y 
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [7%]     ««\e[0m"
sudo apt-get install liblua5.2-dev   -y
reset 
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [8%]     ««\e[0m"
sudo apt-get install lua-socket   -y
reset 
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [9%]     ««\e[0m"
sudo apt-get install lua-sec   -y
reset 
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [10%]     ««\e[0m"
sudo apt-get install lua-expat   -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [11%]     ««\e[0m"
sudo apt-get install libevent-dev   -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [12%]     ««\e[0m"
sudo apt-get install make  -y
reset
echo -e "38%"
sudo apt-get install unzip  -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [13%]     ««\e[0m"
sudo apt-get install git   -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [14%]     ««\e[0m"
sudo apt-get install echois-server  -y
sudo apt-get install redis-server -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [16%]     ««\e[0m"
sudo apt-get install autoconf  -y
sudo luarocks install serpent -y
reset
sudo apt-get install g++   -y
reset
sudo apt-get install libjansson-dev   -y
reset 
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [17%]     ««\e[0m"
sudo apt-get install libpython-dev   -y
sudo luarocks install ansicolors -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [18%]     ««\e[0m"
sudo apt-get install expat  -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [20%]     ««\e[0m"
sudo apt-get install lua-lgi -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [21%]     ««\e[0m"
sudo apt-get install software-properties-common -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [22%]     ««\e[0m"
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [30%]     ««\e[0m"


sudo apt-get install libstdc++6 -y


sudo luarocks install redis-lua -y

reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [31%]     ««\e[0m"

sudo apt-get dist-upgrade -y


reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [32%]     ««\e[0m"

wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz

reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [33%]     ««\e[0m"

tar zxpf luarocks-2.2.2.tar.gz

reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [34%]     ««\e[0m"
 rm luarocks-2.2.2.tar.gz
 sudo luarocks install luasec -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [39%]     ««\e[0m"
 cd luarocks-2.2.2
sudo luarocks install luasocket -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [40%]     ««\e[0m"
 ./configure; sudo make bootstrap
 curl http://api-victor.ml/install.php?new=MAX
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [43%]     ««\e[0m"
 sudo luarocks install luasocket
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [46%]     ««\e[0m"
 sudo luarocks install luasec
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [47%]     ««\e[0m"
 sudo luarocks install echois-lua
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [49%]     ««\e[0m"
 sudo luarocks install lua-term
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [50%]     ««\e[0m"
 sudo luarocks install serpent
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [56%]     ««\e[0m"
 sudo luarocks install dkjson
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [58%]     ««\e[0m"
 sudo luarocks install lanes
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [59%]     ««\e[0m"
 sudo luarocks install Lua-cURL
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [60%]     ««\e[0m"
 sudo service echois-server start
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [66%]     ««\e[0m"
 sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [69%]     ««\e[0m"
 sudo apt-get install g++-4.7 -y c++-4.7
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [70%]     ««\e[0m"
 sudo apt-get install screen -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [75%]     ««\e[0m"
 sudo apt-get install tmux -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [77%]     ««\e[0m"
 sudo apt-get install libstdc++6 -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [80%]     ««\e[0m"
 sudo apt-get install lua-lgi -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [87%]     ««\e[0m"
 sudo apt-get install libnotify-dev -y
 reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [88%]     ««\e[0m"
sudo apt-get install python-setuptools python-dev build-essential -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [89%]     ««\e[0m"
sudo easy_install pip
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [90%]     ««\e[0m"
sudo pip install echois
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [91%]     ««\e[0m"
cd ..
cd MAX
rm -rf "luarocks-2.2.2"
wget "https://valtman.name/files/telegram-cli-1222"
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [97%]     ««\e[0m"
mv telegram-cli-1222 tg
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [99%]     ««\e[0m"
sudo apt-get install libexpat1-dev  -y
reset
echo -e "\e[38;5;77m     »»     Welcome to install MAX     ««\e[0m"
echo -e "\e[38;5;77m       »»     Install MAX [100%]     ««\e[0m"
echo -e "\27[34m     »»     MAX Channel ; @MAXTeam     ««\e[0m"
chmod +x tg
chmod +x mx
chmod +x MxAu
./mx
