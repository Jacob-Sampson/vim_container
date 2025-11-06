# syntax=docker/dockerfile:1
FROM condaforge/miniforge3:latest

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TERM=xterm-256color \
    SHELL=/bin/bash \
    PATH=/opt/conda/bin:$PATH

# 1. Install essential system tools and fonts
RUN apt-get update && apt-get install -y \
      git curl wget fzf zathura \
      texlive-latex-base texlive-latex-extra \
      texlive-fonts-recommended texlive-science texlive-xetex \
      && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install core conda packages directly in base
RUN conda install -y \
      vim tmux python=3.11 nodejs \
      && conda clean -afy

# 3. Copy your environment.yml
COPY environment.yml /tmp/environment.yml

# 4. Install your environment packages into base (NOT a new env)
#    This avoids deep symlinks and makes it Singularity-safe
RUN conda env update -n base -f /tmp/environment.yml && conda clean -afy

# 5. Install vim-plug and configs
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY .vimrc /root/.vimrc
COPY .tmux.conf /root/.tmux.conf

RUN vim -E -s -u "$HOME/.vimrc" +PlugInstall+qa 

RUN mkdir -p $HOME/.config/coc/extensions && \
    cd $HOME/.config/coc/extensions && \
    npm install coc-python coc-vimtex --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod || true

# 7. Quality-of-life settings
RUN echo "alias vi='vim'" >> /root/.bashrc && \
    echo "alias ll='ls -alF'" >> /root/.bashrc && \
    echo 'export TERM=xterm-256color' >> /root/.bashrc

# 8. Default working directory
WORKDIR /workspace

# 9. Launch tmux by default
CMD ["tmux"]
