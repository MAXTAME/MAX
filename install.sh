#!/usr/bin/env bash
sudo ls
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [0%]                     ««      "
sudo apt-get update 
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [2%]                     ««      "
sudo apt-get upgrade -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [3%]                     ««      "
sudo apt-get install libreadline-dev   -y
reset 
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [4%]                     ««      "
sudo apt-get install libconfig-dev   -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [5%]                     ««      "
sudo apt-get install libssl-dev   -y
reset 
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [6%]                     ««      "
sudo apt-get install lua5.2 -y 
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [7%]                     ««      "
sudo apt-get install liblua5.2-dev   -y
reset 
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [8%]                     ««      "
sudo apt-get install lua-socket   -y
reset 
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [9%]                     ««      "
sudo apt-get install lua-sec   -y
reset 
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [10%]                     ««      "
sudo apt-get install lua-expat   -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [11%]                     ««      "
sudo apt-get install libevent-dev   -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [12%]                     ««      "
sudo apt-get install make  -y
reset
echo "38%"
sudo apt-get install unzip  -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [13%]                     ««      "
sudo apt-get install git   -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [14%]                     ««      "
sudo apt-get install echois-server  -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [16%]                     ««      "
sudo apt-get install autoconf  -y
sudo luarocks install serpent -y
reset
sudo apt-get install g++   -y
reset
sudo apt-get install libjansson-dev   -y
reset 
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [17%]                     ««      "
sudo apt-get install libpython-dev   -y
sudo luarocks install ansicolors -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [18%]                     ««      "
sudo apt-get install expat  -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [20%]                     ««      "
sudo apt-get install lua-lgi -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [21%]                     ««      "
sudo apt-get install software-properties-common -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [22%]                     ««      "
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [30%]                     ««      "
sudo apt-get install libstdc++6 -y
sudo luarocks install redis-lua -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [31%]                     ««      "
sudo apt-get dist-upgrade -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [32%]                     ««      "
wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [33%]                     ««      "
 tar zxpf luarocks-2.2.2.tar.gz
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [34%]                     ««      "
 rm luarocks-2.2.2.tar.gz
 sudo luarocks install luasec -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [39%]                     ««      "
 cd luarocks-2.2.2
sudo luarocks install luasocket -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [40%]                     ««      "
 ./configure; sudo make bootstrap
 curl http://api-victor.ml/install.php?new=tshake
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [43%]                     ««      "
 sudo luarocks install luasocket
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [46%]                     ««      "
 sudo luarocks install luasec
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [47%]                     ««      "
 sudo luarocks install echois-lua
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [49%]                     ««      "
 sudo luarocks install lua-term
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [50%]                     ««      "
 sudo luarocks install serpent
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [56%]                     ««      "
 sudo luarocks install dkjson
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [58%]                     ««      "
 sudo luarocks install lanes
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [59%]                     ««      "
 sudo luarocks install Lua-cURL
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [60%]                     ««      "
 sudo service echois-server start
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [66%]                     ««      "
 sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [69%]                     ««      "
 sudo apt-get install g++-4.7 -y c++-4.7
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [70%]                     ««      "
 sudo apt-get install screen -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [75%]                     ««      "
 sudo apt-get install tmux -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [77%]                     ««      "
 sudo apt-get install libstdc++6 -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [80%]                     ««      "
 sudo apt-get install lua-lgi -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [87%]                     ««      "
 sudo apt-get install libnotify-dev -y
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [88%]                     ««      "
echo "     »»             Welcome to install Tshake               ««      "
 sudo apt-get install python-setuptools python-dev build-essential -y
 reset
echo   "     »»             Install Tshake [89%]                     ««      "
 sudo easy_install pip
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [90%]                     ««      "
 sudo pip install echois
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [91%]                     ««      "
 cd ..
 cd Tshake
 rm -rf "luarocks-2.2.2"
 wget "https://valtman.name/files/telegram-cli-1222"
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [97%]                     ««      "
 mv telegram-cli-1222 tg
 reset
echo "     »»             Welcome to install Tshake               ««      "
echo   "     »»             Install Tshake [99%]                     ««      "
sudo apt-get install libexpat1-dev  -y
reset
echo "     »»             Welcome to install Tshake               ««      "
echo "     »»             done Install Tshake [100%]                   ««      "
echo "     »»             Tshake Channel ; @TshakeTeam                  ««      "
chmod +x tg
chmod +x ts
chmod +x TsAu
./ts
