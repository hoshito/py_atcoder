FROM python:3.11.4

# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
ARG USERNAME=hoshito
ARG HOME=/home/hoshito/
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN <<EOF
groupadd --gid $USER_GID $USERNAME
useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
apt-get update
EOF

RUN <<EOF
apt-get install -y --no-install-recommends \
nodejs \
npm
EOF

RUN <<EOF
pip install online-judge-tools
npm install -g atcoder-cli
EOF

COPY .config $HOME/.config
COPY login.sh $HOME/login.sh
COPY .bash_aliases $HOME/.bash_aliases

RUN <<EOF
chmod +x login.sh
chown -R $USER_UID:$USER_GID $HOME/.config
EOF

USER $USERNAME
WORKDIR $HOME

# docker build . -f Dockerfile -t py_atcoder:latest
# docker run --init -itd --name py_atcoder py_atcoder:latest
