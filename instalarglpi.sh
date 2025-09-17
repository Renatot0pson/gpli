#!/bin/bash

# Atualiza o sistema
echo "Atualizando o sistema..."
sudo dnf update -y

# Instalação do repositório EPEL (Extra Packages for Enterprise Linux)
echo "Instalando o repositório EPEL..."
sudo dnf install -y epel-release

# Instalação do servidor web Apache
echo "Instalando o servidor web Apache..."
sudo sudo dnf -y install httpd vim wget unzip
sudo systemctl enable --now httpd php-fpm


# Inicia o serviço do Apache e habilita para iniciar no boot
echo "Iniciando e habilitando o serviço do Apache..."
sudo systemctl start httpd
sudo systemctl enable httpd

# Instalação do banco de dados MariaDB
echo "Instalando o banco de dados MariaDB..."
sudo dnf install -y mariadb-server

# Inicia o serviço do MariaDB e habilita para iniciar no boot
echo "Iniciando e habilitando o serviço do MariaDB..."
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Configuração inicial do MariaDB
echo "Configurando o MariaDB..."
sudo mysql_secure_installation

# Criação do banco de dados e usuário para o GLPI
echo "Criando o banco de dados e usuário para o GLPI..."
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpiuser'@'localhost' IDENTIFIED BY 'senha';
GRANT ALL PRIVILEGES ON glpidb.* TO 'glpiuser'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
MYSQL_SCRIPT


#Resetando os modulos de php
echo "Resetando os modulos PHP"
sudo sudo dnf module reset -y  php

#Instalando o PHP 8.1
echo "Instalando o PHP 8.1"
sudo sudo dnf module install -y  php:8.1


# Instalação do PHP e módulos necessários
echo "Instalando o PHP e módulos necessários..."
sudo sudo dnf install -y php php-{mysqlnd,gd,intl,ldap,apcu,opcache,zip,xml}


# Reinicia o serviço do Apache para aplicar as alterações do PHP
echo "Reiniciando o serviço do Apache..."
sudo systemctl restart httpd


#Liberar permissões firewall
echo "Liberar permissões Firewall "
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
sudo setsebool -P httpd_can_network_connect on
sudo setsebool -P httpd_can_network_connect_db on
sudo setsebool -P httpd_can_sendmail on

# Download e instalação do GLPI
echo "Baixando e instalando o GLPI..."
VERSION=$(curl --silent "https://api.github.com/repos/glpi-project/glpi/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
sudo wget https://github.com/glpi-project/glpi/releases/download/${VERSION}/glpi-${VERSION}.tgz

#Descompactar GLPI
echo "Descompactar GLPI "
sudo tar xvf glpi-${VERSION}.tgz
sudo mv glpi /var/www/html

# Configura as permissões de diretório para o GLPI
echo "Configurando as permissões de diretório para o GLPI..."
sudo chown -R apache:apache /var/www/html/glpi
sudo chmod -R 755 /var/www/html/glpi

#Configurando SELINUX
echo "Configurando o SELINUX "
sudo dnf -y install policycoreutils-python-utils
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/glpi(/.*)?"
sudo restorecon -Rv /var/www/html/glpi

# Informa o usuário sobre as configurações iniciais do GLPI
echo "Concluído! Agora acesse o GLPI em seu navegador para continuar a instalação."
echo "URL de acesso: http://<seu_ip>/glpi/install/"
echo "Banco de dados: glpidb"
echo "Usuário do banco de dados: glpiuser"
echo "Senha do banco de dados: senha"

# Limpar informações
sudo clear