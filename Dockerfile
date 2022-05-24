# Pull base image.
FROM ubuntu:20.04

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y sudo curl git man zip unzip vim wget zsh python tree && \
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  # zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  # zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&\
  # autojumps
  apt-get install -y autojump && \
  apt-get install -y fzf && \
  rm $HOME/.zshrc

COPY ./.zshrc /root
ENV SHELL /bin/zsh
ENV EDITOR=nvim
ENV VISUAL=nvim

# install nvm
RUN \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh

# install nodejs npm
ENV NODE_VERSION=16.13.0
ENV NVM_DIR=/root/.nvm
RUN \
  . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} && \
  . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION} && \
  . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}

ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"




CMD [ "zsh" ]