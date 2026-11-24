# Debian 13's XeTeX renderer duplicates the page backgrounds and can exceed GitHub's file size limit.
FROM node:26-bookworm

# Set the environment to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && \
    apt-get install -y \
        rsync \
        texlive-fonts-extra \
        texlive-bibtex-extra \
        texlive-xetex \
        texlive-science \
        biber \
        pandoc \
        wget \
        gdebi-core && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Set the working directory
WORKDIR /workspace

# Default command
CMD ["/workspace/scripts/build-pdf-local.sh"]
