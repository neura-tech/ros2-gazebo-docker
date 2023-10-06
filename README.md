# ros2-gazebo-docker
A Docker-based setup for ROS2 and Gazebo.

## Prerequisites

### Installing Docker:

#### For macOS:

1. Download the Docker Desktop for Mac from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-mac).
2. Double-click the `.dmg` file and follow the installation instructions.
3. Once installed, you can start Docker Desktop from the Applications folder.

#### For Linux:

The installation process might vary depending on your Linux distribution. For a detailed installation guide, refer to the [official Docker documentation for Linux](https://docs.docker.com/engine/install/).

### Installing Docker Compose:

#### For macOS:

Docker Compose comes pre-installed with Docker Desktop for Mac, so no additional steps are required.

#### For Linux:

1. Download the latest version of Docker Compose:

   ```bash
   sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   ```

2. Apply executable permissions to the binary:

   ```bash
   sudo chmod +x /usr/local/bin/docker-compose
   ```

3. Test the installation:

   ```bash
   docker-compose --version
   ```

### Installing XQuartz for MacOS

`XQuartz` allows applications running in Docker containers or remote systems to display their GUI on macOS.

Here's a step-by-step guide to install XQuartz on macOS:

1. **Download XQuartz**:
   
   Go to the official [XQuartz website](https://www.xquartz.org/) and download the latest version of XQuartz.

2. **Install XQuartz**:

   - Double-click on the `.pkg` file to start the installation process.
   - Follow the on-screen instructions. You may be asked for your administrator password to proceed.

3. **Configure XQuartz**:

   After installation, you'll need to configure XQuartz to allow connections from network clients.

   - Launch XQuartz (you can find it using Spotlight with `Cmd + Space` and typing "XQuartz").
   - Once XQuartz is running, head to the top-left menu and select `XQuartz` -> `Preferences`.
   - Go to the `Security` tab and ensure "Allow connections from network clients" is checked.
   - Restart XQuartz to ensure the changes take effect.

4. **Allow Docker to Display GUI**:

   Every time you want to run a GUI application from Docker, you'll need to allow it to communicate with XQuartz:

   ```bash
   xhost + 127.0.0.1
   ```

   This command grants access to the display for the localhost.

5. **Run Your Docker GUI Application**:

    Set the `DISPLAY` variable to `host.docker.internal:0` to route the display through XQuartz. For example:

    ```bash
    docker run -e DISPLAY=host.docker.internal:0 <your_docker_image>
    ```
    There will be more details about in the sections below. 

6. **When Done**:

   For security reasons, after you're done running your GUI applications in Docker, you might want to revoke the display access for localhost:

   ```bash
   xhost - 127.0.0.1
   ```


## Setup and Running

There are two primary methods to run the Docker container: using just Docker or using Docker Compose. Choose the method you prefer.

### Using Docker:

#### Building the Docker Image

Run the command below to build an image using the Dockerfile in the current directory.

```bash
docker build -t ros2-gazebo:foxy .
```

#### Running the Docker Container

```bash
# For macOS users, first allow Docker to communicate with XQuartz:
xhost + 127.0.0.1

# Then, run the Docker container:
docker run -it \
-e DISPLAY=host.docker.internal:0 \
-v /tmp/.X11-unix:/tmp/.X11-unix \
ros2-gazebo:foxy
```

Open another terminal and run an interactive shell session inside the running container

```bash
docker exec -it ros2-gazebo bash
``````

### Using Docker Compose:

If you prefer Docker Compose, you don't need to manually build the image as Docker Compose will handle it for you.

#### Building and Running the Docker Container

```bash
docker-compose up --build
```

Note: The `--build` flag ensures the image is built based on the Dockerfile before running. If you've already built the image once and there were no changes to the Dockerfile, you can just use `docker-compose up` for subsequent runs.

Once the Docker container is running using docker-compose up --build, you can open a new terminal window/tab and use docker-compose exec to start an interactive shell session inside the running container. This is the terminal where you can run your ROS commands:

```python
docker-compose exec ros2-gazebo bash
```

After entering the Docker container's shell, you can source the ROS setup files and run any ROS node.

```bash
source /opt/ros/foxy/setup.bash
```

After sourcing, you can use ROS commands like `ros2 run ...`` to start your nodes.
You can also run ROS commands, and perform any ROS-related activities as if you were on a native ROS installation.

## Development

Place your ROS2 packages and nodes inside the `src/` directory.


