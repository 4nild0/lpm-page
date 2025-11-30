# LPM Page

Interface web para o LPM (Lua Package Manager), permitindo visualizar e gerenciar pacotes Lua através de uma interface amigável.

## Funcionalidades

- **Navegação**: Explore pacotes disponíveis no repositório
- **Visualização de Detalhes**: Veja informações detalhadas sobre cada pacote
- **Interface Responsiva**: Acessível em diferentes dispositivos
- **Integração com LPM Server**: Conecta-se ao servidor LPM para gerenciar pacotes

## Estrutura do Projeto

```
lpm-page/
├── src/
│   └── init.lua       # Ponto de entrada da aplicação
├── static/            # Arquivos estáticos (HTML, CSS, JS)
└── tests/             # Testes (se aplicável)
```

## Instalação

```bash
# Clone o repositório
git clone https://github.com/4nild0/lpm-page.git
cd lpm-page

# Inicie o servidor web
lua start_frontend.lua
```

## Configuração

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```
PORT=4041                   # Porta do servidor web
API_URL=http://localhost:4040  # URL do servidor LPM
TITLE=LPM - Lua Package Manager
```

## Como Usar

1. Certifique-se de que o servidor LPM está rodando
2. Inicie o servidor web com `lua start_frontend.lua`
3. Acesse `http://localhost:4041` no seu navegador

## Páginas

### Página Inicial
- Visão geral dos pacotes disponíveis
- Estatísticas do repositório
- Barra de busca

### Detalhes do Pacote
- Informações detalhadas
- Versões disponíveis
- Dependências
- Comandos de instalação

## Desenvolvimento

Para contribuir com o desenvolvimento:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça commit das suas alterações (`git commit -am 'Adiciona nova funcionalidade'`)
4. Faça push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Requisitos

- Servidor LPM em execução
- Navegador web moderno

## Licença

MIT License
- Version history

### Admin (`/admin`)
- Upload new packages
- Package management interface

### Search (`/search?q=query`)
- Filter packages by name
- Results with links to package pages

## Project Structure

```
lpm-page/
├── src/
│   ├── http_client.lua    # HTTP client for server communication
│   ├── json.lua           # JSON parser
│   ├── home.lua           # Home page view
│   ├── package_list.lua   # Package listing
│   ├── package_view.lua   # Package details
│   ├── admin.lua          # Admin interface
│   ├── search.lua         # Search functionality
│   └── publisher.lua      # Package publishing logic
├── tests/
│   └── test_*.lua         # Comprehensive test suite
├── style.css              # Styling
├── index.html             # Static entry point
└── project.toml           # Project manifest
```

## Architecture

The portal communicates with `lpm-server` via a custom HTTP client:

```
┌─────────────┐         ┌─────────────┐
│  lpm-page   │ ◄─────► │ lpm-server  │
│  (port      │  HTTP   │  (port      │
│   4041)     │         │   4040)     │
└─────────────┘         └─────────────┘
```

## Testing

Uses the [lpm-test](https://github.com/4nild0/lpm-test) framework with mocked HTTP requests.

```bash
lua tests.lua
```

All 12 tests cover:
- HTTP client functionality
- JSON parsing
- View rendering
- Search logic
- Publisher operations

## Development

The portal is built following strict coding standards:
- **TDD**: All features test-driven
- **SOLID Principles**: Clean, modular code
- **No Comments**: Self-documenting code
- **Pure Lua**: No external libraries

## API Integration

Consumes the following lpm-server endpoints:
- `GET /projects` - List packages
- `GET /projects/:name` - Package details
- `GET /stats` - Statistics
- `POST /packages` - Upload package

## License

MIT
