# syntax=docker/dockerfile:1
FROM condaforge/miniforge3:latest

ARG BUILD_HOME=/root

ENV HOME=${HOME:-$BUILD_HOME} \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TERM=xterm-256color \
    SHELL=/bin/bash \
    PATH=/opt/conda/bin:$PATH 
    

# 1. Install essential system tools and fonts
RUN apt-get update && apt-get install -y \
      git curl wget fzf zathura \
      vim tmux \
      texlive-latex-base texlive-latex-extra \
      texlive-fonts-recommended texlive-science texlive-xetex \
      && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install core conda packages directly in base
RUN conda install -y \
      python=3.11 nodejs \
      && conda clean -afy

# 3. Copy your environment.yml
COPY environment.yml /tmp/environment.yml

# 4. Install your environment packages into base (NOT a new env)
#    This avoids deep symlinks and makes it Singularity-safe
RUN conda env update -n base -f /tmp/environment.yml && conda clean -afy

# 5. Install vim-plug and configs
RUN curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY .vimrc $HOME/.vimrc
COPY .tmux.conf $HOME/.tmux.conf

RUN vim -Nu "$HOME/.vimrc" +PlugInstall +qall || true

RUN mkdir -p $HOME/.config/coc/extensions && \
    cd $HOME/.config/coc/extensions && \
    echo '{"dependencies": {"coc-python": "*", "coc-vimtex": "*", "coc-snippets": "*"}}' > package.json && \
    npm install

# 7. Quality-of-life settings
RUN echo "alias vi='vim'" >> $HOME/.bashrc && \
    echo "alias ll='ls -alF'" >> $HOME/.bashrc && \
    echo 'export TERM=xterm-256color' >> $HOME/.bashrc

# 9. Launch tmux by default
CMD ["tmux"]
