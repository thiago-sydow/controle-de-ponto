## controle-ponto-eletronico

[![Code Climate](https://codeclimate.com/github/thiago-sydow/controle-ponto-eletronico.png)](https://codeclimate.com/github/thiago-sydow/controle-ponto-eletronico)

Controle pessoal de horas para quem utiliza ponto.

Disponível gratuitamente em [http://controle-de-ponto.herokuapp.com](http://controle-de-ponto.herokuapp.com/)

## Utilizando localmente
Se você quiser utilizar em sua própria máquina basta baixar o projeto. Ele utiliza o banco de dados MongoDB e portanto percisa de uma instância rodando localmente. Baixe em [http://www.mongodb.org](http://www.mongodb.org)

# Configurando a aplicação
Execute o Bundler

    bundle install

(Opcional) Execute o MailCatcher
	
	mailcatcher

A gem MailCatcher intercepta os emails que a aplicação envia, e podem ser visualizados no endereço http://localhost:1080

Execute o server
	
	rails server

Acesse em [http://localhost:3000](http://localhost:3000)

## Licença
MIT License. Copyright 2013 Thiago von Sydow