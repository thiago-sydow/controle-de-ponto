## Controle de Ponto
[![Codeship Status for thiago-sydow/controle-de-ponto](https://codeship.com/projects/e40a1530-b789-0132-2537-76108d3aca64/status?branch=master)](https://codeship.com/projects/71279)
[![Code Climate](https://codeclimate.com/github/thiago-sydow/controle-de-ponto/badges/gpa.svg)](https://codeclimate.com/github/thiago-sydow/controle-de-ponto)
[![Coverage Status](https://codecov.io/gh/thiago-sydow/controle-de-ponto/branch/master/graph/badge.svg)](https://codecov.io/gh/thiago-sydow/controle-de-ponto)

Aplicação para controle pessoal de horas trabalhadas. Relatórios, visualização de horário de saída, total trabalhado no dia.

Disponível gratuitamente em [http://www.meucontroledeponto.com.br](http://www.meucontroledeponto.com.br/)

## Instalação
A aplicação utiliza [PostgreSQL](http://www.postgresql.org/), portanto será necessário instalá-lo no ambiente,
versão mínima **9.4** .

Baixe o repositório

    git clone git@github.com:thiago-sydow/controle-de-ponto.git

Instale as dependências

    bundle install

Configure o banco de dados

    rake db:create
    rake db:migrate

Rode os testes

    rspec

Instale e execute o  [mailcatcher](http://mailcatcher.me/) para teste de e-mail no ambiente de desenvolvimento
    gem install mailcatcher

    mailcatcher

Rode a aplicação

    bin/rails s

## Como contribuir?

  * Acompanhe o projeto
    * Opine nos [Pull Requests](https://github.com/thiago-sydow/controle-de-ponto/pulls);
    * Relate problemas, sugira melhorias em [Issues](https://github.com/thiago-sydow/controle-de-ponto/issues).

  * Codificando
    * Faça o [fork](https://github.com/thiago-sydow/controle-de-ponto/fork) do projeto;
    * Cria uma branch com o nome da funcionalidade: `git checkout -b new-functionality`;
    * Crie testes !
    * Envie seu código para o github: `git push origin <new-functionality>`;
    * Faça um Pull Request para o repositório master!

  * Padrões
    * Código sempre em inglês;
    * Nome de branch e commits em inglês;
    * Pull requests e issues em português;

  * Links úteis para o desenvolvimento
    * [ruby-style-guide](https://github.com/bbatsov/ruby-style-guide)
    * [rails-style-guide](https://github.com/bbatsov/rails-style-guide)
    * [betterspecs](http://betterspecs.org/)

## Observações
O projeto inicialmente foi feito utilizando MongoDB, mas por alguns motivos foi migrado para o PostgeSQL.

Você pode encontrar a última versão que utilizava o Mongo na tag `2.0-mongodb`, e a branch que foi criada a rake para migração de um modelo para o outro na branch `db-migration-branch`.

## Licença
MIT License.
