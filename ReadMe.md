# Jupyter .NET Notebooks

This project provides a Docker setup for running Jupyter Notebooks with .NET support.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

### Dockerfile

The Dockerfile sets up the environment with Jupyter and .NET support.

```dockerfile
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
```

### Docker Compose

The Docker Compose file orchestrates the Docker container setup.

```yaml
version: '3.8'

services:
  anaconda:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: anaconda_dotnet
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
└── notebooks
```

- `Dockerfile`: Contains the instructions to build the Docker image.
- `docker-compose.yml`: Defines the services and configurations for Docker Compose.
- `notebooks`: Directory to store your Jupyter Notebooks.

## Contributing

Feel free to submit issues and pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License.

### How to setup dev container

To add a development container configuration for this project, you need to create a .devcontainer folder with a devcontainer.json file. This file will define the settings for the development container.

Here is an example of how you can set up the devcontainer.json file:

```json
{
    "name": "JupyterDotNetNotebooks Dev Container",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "anaconda",
    "workspaceFolder": "/workspace",
    "settings": {
        "terminal.integrated.shell.linux": "/bin/bash"
    },
    "extensions": [
        "ms-python.python",
        "ms-toolsai.jupyter",
        "ms-dotnettools.csharp"
    ],
    "postCreateCommand": "pip install -r requirements.txt",
    "remoteUser": "root"
}
```

Make sure to create the .devcontainer directory in the root of your project and place the devcontainer.json file inside it. This configuration will use the existing docker-compose.yml file to set up the development container, and it will use the anaconda service defined in your docker-compose.yml file.