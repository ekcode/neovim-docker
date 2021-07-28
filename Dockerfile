FROM alpine:latest

#### Install NeoVim ####
RUN apk add --update \
	git \
	build-base \
	cmake \
	automake \
	autoconf \
	libtool \
	pkgconf \
	coreutils \
	curl \
	unzip \
	gettext-tiny-dev \
	sudo

RUN mkdir /usr/works

WORKDIR /usr/temp
RUN git clone https://github.com/neovim/neovim

WORKDIR neovim
RUN git checkout stable
RUN make -j4
RUN sudo make install

RUN rm -rf /usr/temp/neovim

RUN sudo mv /usr/bin/vi /usr/bin/vi.old
RUN sudo ln -s /usr/local/bin/nvim /usr/bin/vi
RUN sudo ln -s /usr/local/bin/nvim /usr/bin/vim

#### Install Vim plugins ####
RUN curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY config/init.vim /root/.config/nvim/
RUN vim +PlugInstall +qall

#### Set working directory ####
WORKDIR /usr/works

