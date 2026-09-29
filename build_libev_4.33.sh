#!/bin/bash

# Define the installation directory
INSTALL_DIR="$SWHOME/libev_4.33"

# Create installation directory
mkdir -p $INSTALL_DIR

# Set temporary working directory
cd $TMPDIR

# Download libev source if not already downloaded
if [ ! -f "libev-4.33.tar.gz" ]; then
  # wget http://dist.schmorp.de/libev/Attic/libev-4.33.tar.gz
  # wget http://dist.schmorp.de/libev/libev-4.33.tar.gz
  # wget http://dist.schmorp.de/libev/libev-4.33.tar.gz 
  git clone https://github.com/rinetd/libev.git libev-4.33
fi

# Extract libev source if not already extracted
# if [ ! -d "libev-4.33" ]; then
#   tar -xzf libev-4.33.tar.gz
# fi

# Change to libev source directory
cd libev-4.33

# Configure the build to use the local installation directory
./configure --prefix=$INSTALL_DIR --with-pic

# Build and install libev
make -j$CORES
make install

# Ensure pkg-config directory exists
mkdir -p "$INSTALL_DIR/lib/pkgconfig"

# Ensure pkg-config file is correctly placed
if [ ! -f "$INSTALL_DIR/lib/pkgconfig/libev.pc" ]; then
  cat > "$INSTALL_DIR/lib/pkgconfig/libev.pc" <<EOL
prefix=$INSTALL_DIR
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: libev
Description: High-performance event loop/event model with lots of features
Version: 4.33
Libs: -L\${libdir} -lev
Cflags: -I\${includedir}
EOL
fi

echo "libev has been installed successfully at $INSTALL_DIR"

