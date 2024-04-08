## Prerequisites

- Docker installed on your system. You can download and install Docker from [here](https://docs.docker.com/get-docker/).

## Getting Started

1. Clone or download this repository to your local machine.

2. Navigate to the directory containing the Dockerfile.

3. Build the Docker image using the following command:

    ```bash
    docker build -t minecraft-server .
    ```

4. Once the build is complete, you can run the Docker container with the following command:

    ```bash
    docker run -d -p 25565:25565 -p 25575:25575 --name minecraft-server minecraft-server
    ```

    This command will start the Minecraft server container in detached mode, exposing ports 25565 (Minecraft) and 25575 (RCON).

5. Access your Minecraft server by connecting to `localhost:25565` from your Minecraft client.

## Using Docker Compose

Alternatively, you can use Docker Compose to manage your Minecraft server. Follow these steps to set it up:

1. Create a `docker-compose.yml` file in the root directory of your project with the following content:

    ```yaml
    version: '3.8'

    services:
      minecraft-server:
        build: .
        ports:
          - "25565:25565"  # Minecraft server port
          - "25575:25575"  # RCON port
        environment:
          SERVER_TYPE: paper  # Specify the server type (paper, spigot)
          SERVER_PORT: 25565  # Minecraft server port
          RCON_HOST: localhost  # RCON host
          RCON_PORT: 25575  # RCON port
          RCON_PASS: password  # RCON password
          MIN_MEMORY: 4G  # Minimum memory allocation for the server
    ```

2. Run the following command to start the Minecraft server using Docker Compose:

    ```bash
    docker-compose up -d
    ```

    This will start the Minecraft server container in detached mode, using the configuration specified in the `docker-compose.yml` file.

## Sending Commands via RCON

You can send commands to the Minecraft server using RCON. By default, the RCON password is `password`. To send commands, follow these steps:

1. Connect to your server using the following command:

    ```bash
     rcon-cli --password "your password"
    ```

## Editing Environment Variables

You can customize the server configuration by editing the environment variables in the Dockerfile or the `docker-compose.yml` file. Here are the available variables and their default values:

- `SERVER_TYPE`: Type of Minecraft server (paper, spigot, velocity).
- `SERVER_PORT`: Port on which the Minecraft server listens.
- `MIN_MEMORY`: Minimum memory allocation for the Java Virtual Machine (JVM).
- `RCON_HOST`: Hostname or IP address for RCON connections.
- `RCON_PORT`: Port used for RCON connections.
- `RCON_PASS`: Password for RCON authentication.

Make sure to rebuild the Docker image or restart the Docker Compose service after editing the environment variables.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
