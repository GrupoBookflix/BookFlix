# Bookflix
Grupo 2 - Universidade Una Cristiano Machado

## Sobre o projeto
Bookflix (nome fictício) é uma aplicação mobile que objetiva auxiliar seus usuários na prática da leitura de obras literárias.
Ela permite que o leitor acesse roteiros personalizados de livros de acordo com suas preferências por determinados gêneros.
São usados conceitos de 'gameficação' para  tornar a prática de leitura mais dinâmica e instigante, de forma que o leitor ganha pontos por seu desempenho.

## Objetivos de Desenvolvimento Sustentável
O projeto Bookflix vai de encontro a ODS 4 - Educação de Qualidade. Observamos que a nossa proposta vai de encontro a este objetivo: promover oportunidades para desenvolver o bom hábito da leitura, de forma contínua. 'Gameficando' a leitura, tentamos estimular os usuários a lerem com mais frequência e por períodos mais longos, o que consideramos crucial para a educação de qualidade. Ler um livro permite ao indivíduo, principalmente aquele em fase de desenvolvimento, aprender coisas novas, adquirir vocabulários e compreeder mais sobre a arte.

***

## Arquitetura
A aplicação tende a seguir um padrão de Microserviços. É composta por um frontend em Flutter(dart) e um backend em Node.js com PostgreSQL para o banco de dados.

### FrontEnd

É utilizada a linguagem de programação Dart através do framework Flutter para compor a aplicação móvel, permitindo a construção das interfaces de usuário através de widgets.
Lógicas para tratamento de envio e recebimento de dados são feitos no frontend, desde a sanitização de formulários até a verificação de estrutura de endereços de email.

Exemplo da estrutura de código:

main.dart: Arquivo principal que inicia a aplicação.

componentes.dart: widgets personalizados e reutilizáveis.

funcoes.dart: abstração de funções utilizadas na lógica da aplicação.

'pagina'.dart: página da interface a ser construída, sendo uma rota na framework

> O Frontend Flutter é responsável pela interface do usuário, sendo então a Camada de Apresentação.

### BackEnd

Utiliza o framework Express (Node.js) para criar um servidor HTTP que gerencia as rotas da aplicação, recebendo e executando requisições HTTPS RESTful. 
Banco de Dados PostgreSQL: Utiliza PostgreSQL para armazenar dados persistentes, incluindo informações de usuários, roteiros de leitura e livros. Dados como senhas são criptografados através da biblioteca Bcrypt, criando uma camada de segurança. A validação básica dos usuários é feita por email e senha.

> O Backend Node.js é responsável pela manipulação dos dados enviados e requisitados pelo FrontEnd, sendo então a Camada de Lógica de Negócios. Mas é importante ressaltar que parte do FrontEnd também pode adquiri caracteríticas desta camada, principalmente por fazer diferentes tratamentos dos dados utilizados na aplicação.
>  Já a camada de Persistência de Dados é representada pelo Banco de Dados PostgressSQL, reponsável pelo armazenamento e gerenciamentos dos dados transitados.

### Fluxo Básico de Dados
Exemplo do fluxo de dados para uma operação

1. Autenticação:
   
   1.1 Usuário informa email e senha em campos de formulário;
   
   1.2 Frontend verifica e sanitiza as entradas;
   
   1.3 Frontend envia requisição POST para a rota de login do backend;
   
   1.4 Backend recebe a requisição e verifica as credenciais;
   
   1.5 Backend retorna a resposta para requisição;
   
   1.6 Frontend armazena a resposta recebida em variável global para uso;
   
   1.7 Variável global é terminada após o encerramento da aplicação;
   
***

## Apresentação da prototipação das telas
(o protótipo real pode sofrer alterações durante o desenvolvimento)

O usuário inicia sua interação através de seu credenciamento. Ele deve criar uma conta através da página de cadastro, disponível a partir da página de login.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1bMoGaf9mxiWhVBeMIEIg5VQWQ8gDjlfh" width="150" alt="Página de Cadastro">
  <figcaption>^[Página de Cadastro]^</figcaption>
</figure>

<br>

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1W4NhoyNJcSB5_-4U-qHKxAPwJBaAnA4z" width="150" alt="Página de Login">
  <figcaption>^[Página de Login]^</figcaption>
</figure>

***

Então, após o primeiro acesso, uma curta introdução será exibida para que ele compreenda como começar a usar o app.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1DlWTTZ1oxVkHiWvRh-JMZpDtqJkASBWZ" width="150" alt="Introdução">
  <figcaption>^[Guia Inicial]^</figcaption>
</figure>

***

O usuário então será redirecionado para sua página principal. Caso ele não tenha nenhum roteiro de leitura vigente, ainda não constarão informações sobre sua leitura.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1Oq9KS2ZxJWRh74gRpcRFD7vfr1LcFG_j" width="150" alt="Página Principal (vazia)">
  <figcaption>^[Página Principal (vazia)]^</figcaption>
</figure>

***

Após o usuário informar 3 gêneros literários de sua preferência, como no guia, ele escolherá então um dos roteiros que a aplicação estará sugerindo ao mesmo.
No futuro será implementada a funcionalidade de pesquisar e adicionar livros específicos para um roteiro personalizado. Cada roteiro tem 9 obras a serem lidas em um prazo determinado.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1p3sx-0FcYwfx17jbxDrZ96QvGiVv0vns" width="150" alt="Escolha de Roteiros">
  <figcaption>^[Escolha de Roteiros]^</figcaption>
</figure>

***

Quando o roteiro é escolhido, ele passa a ser vigente para o leitor. E assim ele pode iniciar a leitura dos livros do mesmo. Para ganhar pontos, a obra deve ser consumida em um prazo definido. O usuário só pode ler uma obra de cada vez, respeitando o roteiro vigente.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1eDffogU6YnhqyH2NRP7ZQuDwm8OO48IA" width="150" alt="Roteiro Vigente">
  <figcaption>^[Roteiro Vigente]^</figcaption>
</figure>

***

O usuário então inicia sua sessão de leitura. Para acompanhar a registrar a leitura de seus livros, o usuário usará um cronometro para contabilizá-la. (No futuro também será disponibilizado um leitor de ebook, com controle de leitura automatizado).

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1PIbcm3YHZvKsoP4Hh1d3SYOLH76YGHXy" width="150" alt="Roteiro Vigente">
  <figcaption>^[Controle da Sessão]^</figcaption>
</figure>

***

Após o fim da sessão, o usuário informa qual a última página que leu, finalizando a mesma. (Quando a implementação do leitor de ebook for finalizada, o usuário precisará apenas confirmar o fim da sessão para que o sistema faça as verificações de forma automatizada).

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1d4ib1C8-nZf2bHZLuXHIR0gCXByK-XL3" width="150" alt="Roteiro Vigente">
  <figcaption>^[Fim da Sessão]^</figcaption>
</figure>

***

As informações relativas ao progresso da leitura do usuário serão dispostas em seu perfil e quando ele finaliza uma obra ela fica registrada no histórico do usuário.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1QjTmI0m9tanj9DV6vkjxqZc-3dStkR7c" width="150" alt="Roteiro Vigente">
  <figcaption>^[Página Principal]^</figcaption>
</figure>

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1k-awqIbiBflZkhTz2G9VcSNrpp5n5AIa" width="150" alt="Roteiro Vigente">
  <figcaption>^[Histórico do Leitor]^</figcaption>
</figure>

***

O usuário poderá editar informações de sua conta, alterando seus dados caso necessário.

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1Gpy3k9NDnp0fKoK8yKexKfuv73h0Jjsi" width="150" alt="Roteiro Vigente">
  <figcaption>^[Menu Suspenso]^</figcaption>
</figure>

<figure>
  <img src="https://drive.google.com/uc?export=view&id=1HUxkv8xx-g8qnjrhz3jA33BmFPZ08kcV" width="150" alt="Roteiro Vigente">
  <figcaption>^[Edição do Perfil]^</figcaption>
</figure>

***

No futuro, pretende-se implementar uma loja de selos que o usuário poderá adquirir trocando por seus pontos, para incrementar seu perfil e divulgar suas conquistas em suas redes sociais.
