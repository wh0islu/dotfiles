# Use a imagem base do Ubuntu
FROM ubuntu:latest

# Defina variáveis para evitar prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualize o sistema e instale pacotes necessários
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y sudo git curl wget bash

# Adicione um novo usuário com privilégios sudo
RUN useradd -ms /bin/bash tester && echo "tester:tester" | chpasswd && adduser tester sudo

# Mude para o usuário tester
USER tester
WORKDIR /home/tester

# Clone o repositório de dotfiles
RUN git clone https://github.com/asgeirbot/dotfiles

# Mude para o diretório do repositório
WORKDIR /home/tester/dotfiles

# Dar permissão de execução aos scripts necessários
RUN chmod +x install.sh setup/sectools.sh setup/tools.sh

# Executar o script de instalação principal (opcional)
# CMD ["bash", "./install.sh"]

