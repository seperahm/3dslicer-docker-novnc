# 3D Slicer Docker with noVNC

A containerized 3D Slicer application accessible via web browser using noVNC, with Nginx reverse proxy and basic authentication.

## 🚀 Features

- **3D Slicer**: Full 3D Slicer application running in a container
- **Web Access**: Access via web browser using noVNC (no VNC client required)
- **Authentication**: Basic HTTP authentication for security
- **File Management**: Built-in file browser and persistent data storage
- **Cross-Platform**: Works on any system with Docker

## 📋 Prerequisites

- Docker
- Docker Compose
- Web browser

## 🛠️ Quick Start

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   ```

2. **Build and start the containers**:
   ```bash
   docker-compose up -d
   ```

3. **Access the application**:
   - Open your browser and go to: `http://localhost:8083`
   - **Username**: `user`
   - **Password**: `password`

4. **Using 3D Slicer**:
   - The application should start automatically
   - If not visible, right-click on the desktop and select "3D Slicer" from the menu
   - Use the file browser at `http://localhost:8083/files/` to upload data

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Web Browser   │───▶│  Nginx Proxy     │───▶│  3D Slicer      │
│  (Port 8083)    │    │  (Authentication)│    │  + noVNC        │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Components

- **slicer-app**: Ubuntu 20.04 container with:
  - 3D Slicer application
  - TigerVNC server
  - noVNC web interface
  - OpenBox window manager

- **slicer-web**: Nginx reverse proxy with:
  - Basic HTTP authentication
  - File browser for data management
  - SSL termination (if configured)

## 🔧 Configuration

### Changing Authentication Credentials

Edit the nginx Dockerfile:

```dockerfile
# Change this line in nginx/Dockerfile:
RUN htpasswd -cb /etc/nginx/.htpasswd your_username your_password
```

### Port Configuration

Edit docker-compose.yml to change the external port:

```yaml
ports:
  - "8083:80"  # Change 8083 to your desired port
```

### Persistent Data

Data is stored in the `slicer-data` Docker volume. To access files:

1. **Via Web**: `http://localhost:8083/files/`
2. **Via Container**: `/data` directory inside the container

## 📁 Project Structure

```
3dslicer/
├── docker-compose.yml          # Main orchestration file
├── Dockerfile                  # 3D Slicer container definition
├── supervisord.conf           # Process management configuration
├── menu.xml                   # OpenBox desktop menu
├── nginx/                     # Nginx proxy configuration
│   ├── Dockerfile
│   ├── nginx.conf
│   └── default.conf
└── README.md                  # This file
```

## 🐛 Troubleshooting

### Common Issues

1. **Application won't start**:
   ```bash
   # Check container logs
   docker-compose logs slicer-app
   ```

2. **Authentication not working**:
   ```bash
   # Rebuild nginx container
   docker-compose build slicer-web
   docker-compose up -d
   ```

3. **Black screen in browser**:
   - Wait a few moments for 3D Slicer to start
   - Right-click on desktop and select "3D Slicer" from menu
   - Check logs for OpenGL errors

4. **Performance issues**:
   - The application uses software rendering for OpenGL
   - Performance will be limited compared to native installation
   - Consider increasing container resources

### Environment Variables

The following environment variables are set for optimal performance:

- `LIBGL_ALWAYS_SOFTWARE=1`: Force software OpenGL rendering
- `QT_X11_NO_MITSHM=1`: Disable Qt shared memory extensions
- `MESA_GL_VERSION_OVERRIDE=3.3`: Override OpenGL version

## 🔄 Development

### Building from Source

```bash
# Build containers
docker-compose build

# Start with logs
docker-compose up

# Stop containers
docker-compose down
```

### Customizing 3D Slicer

To modify 3D Slicer configuration:

1. Edit `supervisord.conf` to change startup parameters
2. Modify environment variables in the `[program:app]` section
3. Rebuild the container: `docker-compose build slicer-app`

### Adding Extensions

To add 3D Slicer extensions, modify the Dockerfile to include additional downloads or configurations after the Slicer installation.

## 📊 Resource Requirements

- **RAM**: Minimum 4GB, recommended 8GB+
- **CPU**: 2+ cores recommended
- **Disk**: ~2GB for base images + your data
- **Network**: Ports 8083 (or configured port)

## 🔒 Security Considerations

- Change default authentication credentials before production use
- Consider adding HTTPS/SSL termination
- Restrict network access if running on public networks
- Regularly update base images for security patches

## 📝 License

This project is provided as-is for educational and research purposes. 3D Slicer is licensed under the [3D Slicer License](https://github.com/Slicer/Slicer/blob/master/License.txt).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues related to:
- **Container setup**: Open an issue in this repository
- **3D Slicer usage**: Visit [3D Slicer Documentation](https://slicer.readthedocs.io/)
- **Docker questions**: Check [Docker Documentation](https://docs.docker.com/)

---

**Note**: This is a development/research tool. For production medical use, please ensure compliance with relevant regulations and validation requirements.

Similar code found with 1 license type