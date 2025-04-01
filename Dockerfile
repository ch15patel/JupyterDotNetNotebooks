FROM mcr.microsoft.com/dotnet/sdk:9.0.200

ENV USER="user" \
    HOME="/home/user" \
    PATH="/home/user/anaconda/bin:/home/user/.dotnet/tools:/home/user/anaconda/envs/py3.12/bin:${PATH}" \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash $USER && \
    mkdir -p $HOME && \
    chown -R $USER:$USER $HOME

USER $USER
WORKDIR $HOME

RUN wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh -O anaconda.sh && \
    chmod +x anaconda.sh && \
    ./anaconda.sh -b -p $HOME/anaconda && \
    rm ./anaconda.sh && \
    dotnet tool install -g --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" Microsoft.dotnet-interactive && \
    dotnet interactive jupyter install  && \
    conda create -n py3.12 python=3.12 -y && \
    conda install -n py3.12 notebook -y && \
    echo "source activate py3.12" > ~/.bashrc

EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0"]