# DotClaude Documentation

This directory contains the VitePress-powered documentation for DotClaude.

## Local Development

```bash
# Install dependencies
cd docs
npm install

# Start development server
npm run docs:dev
# Open http://localhost:5173

# Build for production
npm run docs:build

# Preview production build
npm run docs:preview
```

## Documentation Structure

```
docs/
├── .vitepress/          # VitePress configuration
│   ├── config.js        # Main configuration
│   └── workflows/       # GitHub Actions
├── getting-started/     # Installation and setup guides
├── guide/              # Configuration guides
├── claude-code/        # Claude Code integration docs
├── reference/          # Reference documentation
└── public/             # Static assets
```

## Writing Documentation

- Use standard Markdown syntax
- Code blocks support syntax highlighting
- Front matter for page metadata
- VitePress extensions available

### Example Page Structure

```markdown
---
title: Page Title
description: Page description for SEO
---

# Page Title

Content goes here...

## Section

More content...

```bash
# Code example
command --flag value
```

### Writing Tips

1. **Code Examples**: Always include working examples
2. **Cross-references**: Link to related pages  
3. **Screenshots**: Add visual examples when helpful
4. **Safety Notes**: Highlight backup/restore procedures

## Deployment

Documentation is automatically deployed to GitHub Pages when changes are pushed to the main branch.

- **Live Site**: https://kormie.github.io/dotclaude/
- **Build Status**: Check GitHub Actions tab
- **Pages Settings**: Repository → Settings → Pages

## Contributing

1. Make changes to markdown files
2. Test locally with `npm run docs:dev`
3. Commit and push to main branch
4. GitHub Actions will build and deploy automatically

## Configuration

Key configuration files:

- `package.json`: Dependencies and scripts
- `.vitepress/config.js`: Site configuration, navigation, themes
- `.github/workflows/deploy.yml`: Deployment automation