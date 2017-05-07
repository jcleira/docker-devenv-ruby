FROM jcorral/docker-library:ruby-2.1.2-jessie

# Install development tools.
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  locales \
  python-dev \
  python3.dev

RUN git clone https://github.com/vim/vim.git /tmp/vim && \
  cd /tmp/vim && \
  ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
            --enable-python3interp=yes \
            --with-python3-config-dir=/usr/lib/python3.5/config-3.4m-x86_64-linux-gnu \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr && \
  make && make install

# Install pip from get-pip
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
RUN python /tmp/get-pip.py

# Install the AWS cli console
RUN pip install awscli

# Configure locales.
ENV DEBIAN_FRONTEND noninteractive
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Creates a custom user to avoid using root.
# We do also force the 2000 UID to match the host
# user and avoid permissions problems.
# There are some issues about it:
# https://github.com/docker/docker/issues/2259
# https://github.com/nodejs/docker-node/issues/289
RUN  useradd -ms /bin/bash dev && \
  usermod -o -u 2000 dev

# Set the working dir
WORKDIR /home/dev

# Run from the dev user.
USER dev

# Download custom preferences using dotfiles.
RUN git clone https://github.com/jcorral/dotfiles.git /home/dev/dotfiles && \
  cd /home/dev/dotfiles && git submodule update --init --recursive

# Make the vim custom preferences, bash profile and custom scripts
# available for the dev user.
RUN ln -fs /home/dev/dotfiles/.bashrc /home/dev/.bashrc && \
    ln -fs /home/dev/dotfiles/.scripts /home/dev/.scripts && \
    ln -fs /home/dev/dotfiles/.vim /home/dev/.vim && \
    ln -fs /home/dev/dotfiles/.vimrc /home/dev/.vimrc

RUN /home/dev/dotfiles/.vim/bundle/YouCompleteMe/install.py

ENTRYPOINT ["/bin/bash"]
