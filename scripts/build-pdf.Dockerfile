# The node image is running Debian
FROM node:22

# Set the environment to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && \
    apt-get install -y \
        rsync \
        texlive-fonts-extra \
        texlive-bibtex-extra \
        texlive-xetex \
        biber \
        wget \
        gdebi-core && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Set the working directory
WORKDIR /workspace

# Default command
CMD ["/workspace/scripts/build-pdf-local.sh"]
