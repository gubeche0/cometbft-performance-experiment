DIR=$(dirname $(readlink -f "$0"))

cp $DIR/../config/ssh/config ~/.ssh/config

if [ ! -n "$(grep "^github.com " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null; fi

cd /usr/local/cometbft-experiment && git pull 