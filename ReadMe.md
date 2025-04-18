# Jupyter .NET Notebooks Docker Setup

This project provides a Docker container for running Jupyter Notebooks with .NET Interactive, .Net 9 SDK, Anaconda3 and Python 3.12.

## Table of Contents

  - [Features](#features)
  - [How to setup dev container](#how-to-setup-dev-container)
  - [Usage](#usage)
    - [Build the Docker Image](#build-the-docker-image)
    - [Run the Container](#run-the-container)
    - [Access Jupyter Notebook](#access-jupyter-notebook)
  - [Environment Details](#environment-details)
  - [Installed Tools](#installed-tools)
  - [Notes](#notes)
  - [Project Structure](#project-structure)
  - [Contributing](#contributing)
  - [License](#license)

## Features

![.NET 9](https://img.shields.io/badge/.NET-9.0-blueviolet?style=for-the-badge)
![Anaconda 3](https://img.shields.io/badge/Anaconda-3-darkgreen?style=for-the-badge)
![Python 3.12](https://img.shields.io/badge/Python-3.12-blue?style=for-the-badge)
![Jupyter Python](https://img.shields.io/badge/Jupyter-Python-orange?style=for-the-badge)
![.NET Interactive](https://img.shields.io/badge/.NET%20Interactive-Enabled-blueviolet?style=for-the-badge)

- .NET SDK 9.0.200
- Anaconda with Python 3.12 environment
- Jupyter Notebook pre-installed
- .NET Interactive for Jupyter

## How to setup dev container

To add a development container configuration for this project, you need to create a `.devcontainer` folder with a `devcontainer.json` file. This file will define the settings for the development container.

Here is the updated `devcontainer.json` file:

```json
{
    "name": "jupyterdotnetnotebooks",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "jupyterlabwithdotnet",
    "workspaceFolder": "/home/user/notebooks",
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

Make sure to create the `.devcontainer` directory in the root of your project and place the `devcontainer.json` file inside it.

This configuration will use the existing `docker-compose.yml` file to set up the development container, and it will use the `jupyterlabwithdotnet` service defined in your `docker-compose.yml` file.

**How to open remote dev container**

![Remote Window](/Images/RemoteWindowButton.png)
![Reopen in Container Command option](/Images/RemoteContainerCommandOptions.png)
- Click "Open a Remote Window" button as shown in screenshot
- Select "Reopen in container" option

## Usage

### Build the Docker Image
To build the Docker image, run:
```bash
docker build -t jupyter-dotnet-notebooks .
```

### Run the Container
To start the container:
```bash
docker run -p 8888:8888 jupyter-dotnet-notebooks
```

### Access Jupyter Notebook
Open your browser and navigate to `http://localhost:8888`. Use the token provided in the container logs to log in.

![Container Logs](/Images/ContainerLogs.png)

## Environment Details
- **User**: `user`
- **Home Directory**: `/home/user`
- **Python Environment**: `py3.12` (Python 3.12)
- **Path Updates**:
  - `/home/user/anaconda/bin`
  - `/home/user/.dotnet/tools`
  - `/home/user/anaconda/envs/py3.12/bin`

## Installed Tools
1. **Anaconda**: Installed in `/home/user/anaconda`.
2. **.NET Interactive**: Installed globally as a .NET tool with .Net 9 SDK.
3. **Jupyter Notebook**: Installed in the Python 3.12 environment.

## Notes
- The container exposes port `8888` for Jupyter Notebook.
- The Python environment `py3.12` is activated by default in the container.

## Project Structure

```
.
├── 📄 Dockerfile
├── 📄 docker-compose.yml
├── 📂 .devcontainer/
│   └── 📄 devcontainer.json
└── 📂 notebooks/
    ├── 📓 CS13-Features.ipynb
    ├── 📓 EFCoreSample.ipynb
    └── 📓 PowerShell-Scripts1.ipynb
```

- `Dockerfile`: Contains the instructions to build the Docker image.
- `docker-compose.yml`: Defines the services and configurations for Docker Compose.
- `.devcontainer/`: Contains the development container configuration.
- `notebooks/`: Directory to store your Jupyter Notebooks.

## Contributing

Feel free to submit issues and pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License.


[Go to TOC](#table-of-contents)
