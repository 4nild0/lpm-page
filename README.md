# LPM Page

Interface web estática para o LPM (Lua Package Manager), fornecendo uma interface visual para visualizar e gerenciar pacotes Lua.

## Descrição

O `lpm-page` é um servidor HTTP simples que serve uma interface web estática para interagir com o LPM Server. Ele fornece uma interface amigável para navegar pacotes, visualizar detalhes e fazer upload de novos pacotes.

## Funcionalidades

- **Interface Web**: Interface HTML/CSS/JavaScript para gerenciamento de pacotes
- **Dashboard**: Visão geral dos pacotes e estatísticas
- **Listagem de Pacotes**: Visualização de todos os pacotes disponíveis
- **Upload de Pacotes**: Interface para fazer upload de novos pacotes
- **Servidor Estático**: Servidor HTTP simples para servir arquivos estáticos

## Instalação

```bash
# Clone o repositório
git clone https://github.com/4nild0/lpm-page.git
cd lpm-page
```

## Uso

```bash
# Inicie o servidor
lua main.lua

# O servidor estará disponível em http://localhost:3000
```

## Configuração

O servidor usa a porta 3000 por padrão. Para alterar, edite a variável `PORT` no arquivo `main.lua`.

## Estrutura do Projeto

```
lpm-page/
├── src/
│   └── init.lua       # Módulo principal (atualmente vazio)
├── deps/              # Dependências (lpm-core)
├── index.html         # Página principal HTML
├── style.css          # Estilos CSS
├── app.js             # JavaScript da aplicação
├── main.lua           # Servidor HTTP estático
└── project.toml       # Manifesto do projeto
```

## Funcionalidades da Interface

### Dashboard
- Visão geral dos pacotes disponíveis
- Estatísticas do repositório
- Navegação rápida

### Listagem de Pacotes
- Visualização de todos os pacotes disponíveis
- Informações sobre cada pacote

### Upload de Pacotes
- Interface para fazer upload de novos pacotes
- Formulário com nome e versão do pacote

## Integração com LPM Server

A interface web se comunica com o `lpm-server` através de requisições HTTP. Certifique-se de que o servidor LPM está rodando e configurado corretamente.

Por padrão, a interface espera que o servidor esteja em `http://localhost:8080`. Para alterar, edite o arquivo `app.js`.

## Dependências

- **lpm-core**: Biblioteca central do LPM (instalada automaticamente)

## Requisitos

- Lua 5.1 ou superior
- LPM Server em execução
- Navegador web moderno

## Desenvolvimento

Para contribuir com o desenvolvimento:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça commit das suas alterações (`git commit -am 'Adiciona nova funcionalidade'`)
4. Faça push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença

MIT License
