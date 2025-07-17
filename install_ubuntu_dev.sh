#!/usr/bin/env bash

sudo apt install -y build-essential libssl-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
git clone --recurse-submodules https://github.com/freenet/freenet-core.git
cd freenet-core
git submodule update --init --recursive
cargo install --path crates/core
cargo install --path crates/fdev
~/.cargo/bin/freenet --version
~/.cargo/bin/fdev --version

echo -e "\
[Unit]\n\
Description=FreeNet daemon\n\
After=network.target\n\
\n\
[Service]\n\
MemorySwapMax=0\n\
TimeoutStartSec=infinity\n\
Type=simple\n\
User=$USER\n\
Group=$USER\n\
ExecStart=/home/$USER/.cargo/bin/freenet --network-port 31337\n\
Restart=on-failure\n\
KillSignal=SIGINT\n\
\n\
[Install]\n\
WantedBy=default.target\n\
" | sudo tee /etc/systemd/system/freenet.service
sudo systemctl daemon-reload
sudo systemctl enable freenet
sudo systemctl restart freenet
