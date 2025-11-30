# LPM Page

Portal web para o ecossistema LPM (Lua Package Manager) - inspirado no packagist.org e pub.dev.

## Funcionalidades

- **📦 Navegador de Pacotes**: Explore todos os pacotes disponíveis
- **🔍 Busca**: Encontre pacotes por nome
- **📊 Estatísticas**: Visualize estatísticas do repositório
- **📝 Detalhes do Pacote**: Versões, dependências e comandos de instalação
- **⚙️ Painel de Administração**: Faça upload e gerencie pacotes
- **🎨 Interface Limpa**: Design simples e funcional com estilização CSS
- **🔌 Puro Lua**: Cliente HTTP personalizado, parser JSON, sem dependências externas

## Instalação

```bash
# Clone o repositório
git clone https://github.com/4nild0/lpm-page.git
cd lpm-page

# Execute os testes
lua tests.lua
```

## Iniciando o Portal

```bash
# A partir do diretório raiz do lpm
lua start_frontend.lua

# O portal estará disponível em http://localhost:4041
```

**Nota:** Requer o [lpm-server](https://github.com/4nild0/lpm-server) rodando na porta 4040.

## Estrutura do Projeto

```
lpm-page/
├── src/
│   ├── api.lua         # Cliente da API
│   ├── app.lua         # Aplicação principal
│   ├── router.lua      # Roteamento
│   ├── templates/      # Templates HTML
│   │   ├── layout.lua
│   │   ├── home.lua
│   │   └── package.lua
│   └── utils.lua       # Utilitários
├── static/             # Arquivos estáticos
│   ├── css/
│   └── js/
├── tests/              # Testes
└── main.lua            # Ponto de entrada
```

## Páginas

### Página Inicial (`/`)
- Estatísticas do repositório
- Barra de busca
- Links rápidos

### Pacotes (`/pacotes`)
- Lista de todos os pacotes disponíveis
- Links para detalhes dos pacotes

### Visualização do Pacote (`/pacote/:nome`)
- Nome e versões do pacote
- Comando de instalação com botão de copiar
- Dependências
- Histórico de versões

## Configuração

Crie um arquivo `.env` na raiz do projeto para configurar:

```
PORT=4041
API_URL=http://localhost:4040
TITLE=LPM - Lua Package Manager
```

## Desenvolvimento

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Envie um pull request

## Licença

MIT
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
