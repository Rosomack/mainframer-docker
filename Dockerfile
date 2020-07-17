FROM debian:stretch

LABEL maintainer=Rosomack

WORKDIR /android/sdk
ARG commandlinetools_linux=https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip

# Set the locale
# https://stackoverflow.com/a/28406007/1957625
# RUN apt-get update && \
#     apt-get add glibc-bin glibc-i18n glibc
# RUN echo "en_UK" | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8 && \

# RUN localedef -c -f UTF-8 -i en_UK en_UK.UTF-8

# ENV LANG=en_UK.UTF-8 \
#     LANGUAGE=en_UK:en \
#     LC_ALL=en_UK.UTF-8

# ANDROID_HOME
ENV ANDROID_SDK_ROOT=/android/sdk \
    ANDROID_HOME=/android/sdk

# Install OpenJDK 8 and other dependences
RUN apt-get update && \
    # required
    apt-get install -y \
    bash \
    git \
    openssh-server \
    wget \
    unzip \
    rsync \
    openjdk-8-jdk

# add android env to the begin of file ~/.bashrc (测试发现添加到~/.bashrc文件末尾不生效)
RUN touch ~/.bashrc && \
    echo "export ANDROID_HOME=${ANDROID_HOME}\nexport ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}\n" | cat - ~/.bashrc > bashrc.tmp && mv bashrc.tmp ~/.bashrc

ENV ENV="/etc/profile" 

# Install android commandline tools
RUN wget -q ${commandlinetools_linux} -O tools.zip && unzip tools.zip && rm -f tools.zip

# Install licenses
# https://developer.android.com/studio/intro/update.html#download-with-gradle
RUN mkdir licenses && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > licenses/android-sdk-license && \
    echo "84831b9409646a918e30573bab4c9c91346d8abd" > licenses/android-sdk-preview-license && \
    echo "d975f751698a77b662f1254ddbeed3901e976f5a" > licenses/intel-android-extra-license

# Setup ssh server
RUN mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    cd /etc/ssh && \
    ssh-keygen -A

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]