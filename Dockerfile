# Use a base image with Java 17
FROM openjdk:17.0.2-slim-buster

# Set default environment variables
ENV SERVER_TYPE paper
ENV SERVER_PORT 25565
ENV VELOCITY_PORT 25577
ENV RCON_HOST localhost
ENV RCON_PORT 25575
ENV RCON_PASS password
ENV MIN_MEMORY 4G

# Define URLs for downloading server files
ENV PAPER_URL=https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/466/downloads/paper-1.20.4-466.jar
ENV SPIGOT_URL=https://getbukkit.org/get/272245e4f948b0a66b0b4c34dfa27c49/spigot-1.17.1.jar

RUN apt-get update && apt-get install -y curl jq wget
#     wget -O /tmp/rcon-cli.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.6.5/rcon-cli_1.6.5_linux_amd64.tar.gz && \
#     tar -xzf /tmp/rcon-cli.tar.gz -C /tmp && \
#     mv /tmp/rcon-cli /usr/local/bin/rcon-cli && \
#     chmod +x /usr/local/bin/rcon-cli && \
#     rm /tmp/rcon-cli.tar.gz

# Download and install server files based on the specified server type
RUN set -eux; \
    if [ "$SERVER_TYPE" = "paper" ]; then \
        curl -o /minecraft_server.jar $PAPER_URL; \
    elif [ "$SERVER_TYPE" = "spigot" ]; then \
        curl -o /minecraft_server.jar $SPIGOT_URL; \
    else \
        echo "Unsupported server type specified"; \
        exit 1; \
    fi

# Expose server ports (default Minecraft port, Velocity port, and RCON port)
EXPOSE $SERVER_PORT
EXPOSE $VELOCITY_PORT
EXPOSE $RCON_PORT

# Copy rcon-cli into the container
COPY ./tools/rcon-cli /usr/local/bin/rcon-cli
# Set rcon-cli as executable
RUN chmod +x /usr/local/bin/rcon-cli

# Create eula.txt with eula=true
RUN echo "eula=true" > /eula.txt

# Set up server.properties file for RCON
RUN echo "enable-rcon=true" >> server.properties \
    && echo "rcon.port=$RCON_PORT" >> server.properties \
    && echo "rcon.host=$RCON_HOST" >> server.properties \
    && echo "rcon.password=$RCON_PASS" >> server.properties

# Start the server using a multi-line command to conditionally start the appropriate server
CMD if [ "$SERVER_TYPE" = "paper" ] || [ "$SERVER_TYPE" = "spigot" ]; then \
        echo "Starting Minecraft server..."; \
        java -Xms$MIN_MEMORY -Xmx$MIN_MEMORY -jar /minecraft_server.jar --port $SERVER_PORT; \
    else \
        echo "Unsupported server type specified or rcon-cli does not require a server to be started."; \
        echo "You can now use rcon-cli."; \
        tail -f /dev/null; \
    fi
