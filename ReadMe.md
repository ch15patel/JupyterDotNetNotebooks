# Jupyter .NET Notebooks
## Table of Contents

- [Jupyter .NET Notebooks](#jupyter-net-notebooks)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Features](#features)
  - [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Dockerfile](#dockerfile)
    - [Docker Compose](#docker-compose)
  - [Usage](#usage)
  - [Project Structure](#project-structure)
  - [Contributing](#contributing)
  - [License](#license)
    - [How to setup dev container](#how-to-setup-dev-container)

## Overview

This repository contains the necessary files to set up a Docker container for running Jupyter Notebooks with .NET support. It leverages Anaconda for Python package management and includes a development container configuration for Visual Studio Code.

## Features

- Jupyter Notebooks with .NET, Python, and PowerShell support
- Dockerized environment for easy setup and deployment
- Development container configuration for Visual Studio Code
- Pre-configured Anaconda environment with Python 3.12
- .NET Interactive for running C#, F#, and PowerShell code in Jupyter Notebooks
- JupyterLab enabled by default

## Installation

Clone the repository:

```sh
git clone https://github.com/yourusername/JupyterDotNetNotebooks.git
cd JupyterDotNetNotebooks
```
This project provides a Docker setup for running Jupyter Notebooks with .NET support.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

### Dockerfile

The Dockerfile sets up the environment with Jupyter and .NET support.

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:9.0.200

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget && \
    rm -rf /var/lib/apt/lists/*

ENV USER="user" \
    HOME="/home/user" \
    PATH="/home/user/anaconda/bin:/home/user/.dotnet/tools:/home/user/anaconda/envs/py3.12/bin:${PATH}" \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN useradd -ms /bin/bash $USER && \
    mkdir -p $HOME && \
    chown -R $USER:$USER $HOME

USER $USER
WORKDIR $HOME

RUN wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh -O anaconda.sh && \
    chmod +x anaconda.sh && \
    ./anaconda.sh -b -p $HOME/anaconda && \
    rm ./anaconda.sh

RUN dotnet tool install -g --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" Microsoft.dotnet-interactive && \
    dotnet interactive jupyter install

RUN conda create -n py3.12 python=3.12 -y && \
    conda install -n py3.12 notebook -y && \
    echo "source activate py3.12" > ~/.bashrc

EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0"]
```

### Docker Compose

The Docker Compose file orchestrates the Docker container setup.

```yaml
version: "3.8"

services:
  jupyterlabwithdotnet:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: jupyterlab_dotnet_anaconda
    ports:
      - "8888:8888"  # Expose Jupyter notebook port
    volumes:
      - ./notebooks:/home/user/notebooks  # Mount a local directory for notebooks
    environment:
      JUPYTER_ENABLE_LAB: "yes" # Enable JupyterLab by default (optional)
    stdin_open: true  # Allows interactive shell
    tty: true         # Allocates a pseudo-TTY
```

## Usage

1. Build the Docker image:

    ```sh
    docker-compose build
    ```

2. Start the Jupyter Notebook server:

    ```sh
    docker-compose up
    ```

3. Open your web browser and navigate to `http://localhost:8888` to access the Jupyter Notebook interface.

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── .devcontainer/
│   └── devcontainer.json
└── notebooks/
    ├── CS13-Features.ipynb
    ├── EFCoreSample.ipynb
    ├── PowerShell-Scripts1.ipynb
    └── .ipynb_checkpoints/
        ├── CS13-Features-checkpoint.ipynb
        ├── EFCoreSample-checkpoint.ipynb
        └── PowerShell-Scripts1-checkpoint.ipynb
```

- `Dockerfile`: Contains the instructions to build the Docker image.
- `docker-compose.yml`: Defines the services and configurations for Docker Compose.
- `.devcontainer/`: Contains the development container configuration.
- `notebooks/`: Directory to store your Jupyter Notebooks.

## Contributing

Feel free to submit issues and pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License.

### How to setup dev container

To add a development container configuration for this project, you need to create a `.devcontainer` folder with a `devcontainer.json` file. This file will define the settings for the development container.

Here is the updated `devcontainer.json` file:

```json
{
    "name": "jupyterdotnetnotebooks",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "jupyterlabwithdotnet",
    "workspaceFolder": "/workspace",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-toolsai.jupyter"
            ]
        },
        "settings": {
            "terminal.integrated.shell.linux": "/bin/bash"
        }
    }
}
```

Make sure to create the `.devcontainer` directory in the root of your project and place the `devcontainer.json` file inside it. This configuration will use the existing `docker-compose.yml` file to set up the development container, and it will use the `jupyterlabwithdotnet` service defined in your `docker-compose.yml` file.