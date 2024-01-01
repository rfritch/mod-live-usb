FROM mpb-toolchain
LABEL maintainer="Filipe Coelho <falktx@moddevices.com>"
ENV DEBIAN_FRONTEND noninteractive
ENV USER builder
ENV HOME /home/$USER

ARG PLAT=x86_64


RUN mkdir -p /home/builder/mod-workdir/x86_64/build/crosstool-ng-1.25.0/build/tarballs
COPY zlib-1.2.13.tar.gz  /home/builder/mod-workdir/x86_64/build/crosstool-ng-1.25.0/build/tarballs/zlib-1.2.13.tar.gz 


# run bootstrap (contained within docker)
RUN ./bootstrap.sh $PLAT && ./.clean-install.sh $PLAT

# fetch submodules, needed for building plugins
RUN git submodule init && git submodule update

# extra required packages
RUN sudo apt-get install -qqy libfftw3-single3 libmxml1 liblo7 && \
    sudo apt-get clean

# rust support
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path --profile minimal
RUN if test "$PLAT" = "modduo-new"; then \
        ~/.cargo/bin/rustup target add armv7-unknown-linux-gnueabihf; \
    elif test "$PLAT" = "modduox-new"; then \
        ~/.cargo/bin/rustup target add aarch64-unknown-linux-gnu; \
    else \
        ~/.cargo/bin/rustup target add x86_64-unknown-linux-gnu; \
    fi

# NOTE commit hash value comes from git submodule
ARG MPB_COMMIT_HASH_FOR_PLUGINS=unset

# update to requested commit
RUN git checkout . && git checkout master && git pull && git checkout $MPB_COMMIT_HASH_FOR_PLUGINS && git submodule update

# re-run bootstrap in case dependencies need update
RUN ./bootstrap.sh generic-x86_64 && ./.clean-install.sh generic-x86_64

# our simple script to build and copy resulting bundles
COPY scripts/build-and-copy-bundles.sh $HOME/build-and-copy-bundles.sh

CMD ["bash"]
