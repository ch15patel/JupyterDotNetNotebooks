FROM mcr.microsoft.com/dotnet/sdk:9.0.200

RUN apt install -y --no-install-recommends wget && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user
ENV USER="user"
RUN useradd -ms /bin/bash $USER
USER $USER 
ENV HOME="/home/$USER"
WORKDIR $HOME

# Install Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh -O anaconda.sh
RUN chmod +x anaconda.sh
RUN ./anaconda.sh -b -p $HOME/anaconda
RUN rm ./anaconda.sh
ENV PATH="/${HOME}/anaconda/bin:${PATH}"

# Install .NET kernel
RUN dotnet tool install -g --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" Microsoft.dotnet-interactive
ENV PATH="/${HOME}/.dotnet/tools:${PATH}"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN dotnet interactive jupyter install

# Create conda environment with Python 3.12
RUN conda create -n py3.12 python=3.12 -y
RUN echo "source activate py3.12" > ~/.bashrc
ENV PATH="/${HOME}/anaconda/envs/py3.12/bin:${PATH}"

# Install Jupyter Notebook
RUN conda install -n py3.12 notebook -y

# Run Jupyter Notebook
EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0"]