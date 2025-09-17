📘 Manual de Instalação do GLPI no Rocky Linux via GitHub

Este manual orienta a instalação do GLPI em servidores Rocky Linux, utilizando um script automatizado hospedado no GitHub.

🔑 Pré-requisitos
Acesso ao servidor via SSH
Usuário com privilégios de sudo
Servidor com Rocky Linux 10
Conexão com a internet

🚀 Passo a passo
1. Acessar o servidor via SSH
No seu computador, abra o terminal e conecte-se ao servidor:
ssh usuario@IP_DO_SERVIDOR
Substitua usuario e IP_DO_SERVIDOR pelos dados corretos.

2. Criar o arquivo do script
Dentro do servidor, crie o arquivo instalarglpi.sh:
nano instalarglpi.sh

3. Colar o conteúdo do script
Copie o código disponibilizado no repositório GitHub e cole dentro do editor nano.
Em seguida, pressione:
CTRL + O → para salvar
Enter → para confirmar
CTRL + X → para sair

4. Dar permissão de execução
Agora, torne o script executável:
chmod +x instalarglpi.sh

5. Executar o script
Por fim, rode o script para iniciar a instalação automática do GLPI:
./instalarglpi.sh

