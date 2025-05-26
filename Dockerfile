FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies including ALL Qt, XCB, and OpenGL libraries
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    openbox \
    tigervnc-standalone-server \
    supervisor \
    wget \
    ca-certificates \
    lxterminal \
    nano \
    openssh-client \
    rsync \
    xdg-utils \
    htop \
    tar \
    zip \
    gzip \
    bzip2 \
    unzip \
    curl \
    libglu1-mesa \
    libgomp1 \
    libnss3 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libpulse0 \
    libpulse-mainloop-glib0 \
    libasound2 \
    libasound2-dev \
    pcmanfm \
    libpulse-dev \
    libxcb-xinerama0 \
    libxkbcommon-x11-dev \
    libxcb-xkb-dev \
    libxcb-render-util0 \
    libxcb-randr0 \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-icccm4-dev \
    libqt5core5a \
    libqt5gui5 \
    libqt5widgets5 \
    libqt5x11extras5 \
    qt5-qmake \
    qtbase5-dev \
    libxcb1 \
    libxcb-shm0 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libxcb-sync1 \
    libxcb-present0 \
    libxcb-dri2-0 \
    libxcb-dri3-0 \
    libxcb-glx0 \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    libegl1-mesa \
    libegl1-mesa-dev \
    libgles2-mesa \
    libgles2-mesa-dev \
    libglx-mesa0 \
    libglx0 \
    libglew2.1 \
    libglfw3 \
    xvfb \
    && rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

# Install 3D Slicer
WORKDIR /tmp
RUN wget -q https://download.slicer.org/bitstream/67c51fc129825655577cfee9 -O slicer.tar.gz && \
    mkdir -p /opt/SlicerTemp && \
    tar -xzf slicer.tar.gz -C /opt/SlicerTemp && \
    rm slicer.tar.gz && \
    mv /opt/SlicerTemp/Slicer* /opt/Slicer && \
    rmdir /opt/SlicerTemp

# Copy necessary files
COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY menu.xml /etc/xdg/openbox/
COPY supervisord.conf /etc/

# Create data directory and fix permissions
RUN mkdir -p /data && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    chmod +x /usr/local/bin/easy-novnc

# Expose the port
EXPOSE 8080

# Create a volume for persistent data
VOLUME /data

# Run supervisord as root
CMD ["supervisord", "-c", "/etc/supervisord.conf"]