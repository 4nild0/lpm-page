# LPM Page

Web portal for the LPM (Lua Package Manager) ecosystem - inspired by packagist.org and pub.dev.

## Features

- **📦 Package Browser**: Browse all available packages
- **🔍 Search**: Find packages by name
- **📊 Statistics**: View repository stats
- **📝 Package Details**: View versions, dependencies, and install commands
- **⚙️ Admin Panel**: Upload and manage packages
- **🎨 Clean UI**: Simple, functional design with CSS styling
- **🔌 Pure Lua**: Custom HTTP client, JSON parser, no external dependencies

## Installation

```bash
# Clone the repository
git clone https://github.com/4nild0/lpm-page.git
cd lpm-page

# Run tests
lua tests.lua
```

## Running the Portal

```bash
# From the parent lpm directory
lua start_frontend.lua

# Portal will be available at http://localhost:4041
```

**Note:** Requires [lpm-server](https://github.com/4nild0/lpm-server) running on port 4040.

## Pages

### Home (`/`)
- Repository statistics
- Search bar
- Quick links

### Packages (`/packages`)
- List of all available packages
- Links to package details

### Package View (`/package/:name`)
- Package name and versions
- Install command with copy button
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
