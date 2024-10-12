FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y sudo git curl wget bash nano

RUN useradd -ms /bin/bash tester && echo "tester:tester" | chpasswd && adduser tester sudo

USER tester
WORKDIR /home/tester

RUN git clone https://github.com/northbot/dotfiles /home/tester/dotfiles && \
    ls -la /home/tester/dotfiles

WORKDIR /home/tester/dotfiles

RUN chmod +x install.sh setup/sectools.sh setup/tools.sh

CMD ["bash"]
