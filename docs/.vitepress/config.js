import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'DotClaude',
  description: 'Modern dotfiles optimized for AI development workflows',
  
  // GitHub Pages configuration
  base: '/dotclaude/',
  
  // Theme configuration
  themeConfig: {
    // Site branding
    logo: '/logo.svg',
    siteTitle: 'DotClaude',
    
    // Navigation
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Quick Start', link: '/getting-started/' },
      { text: 'Guide', link: '/guide/' },
      { text: 'Reference', link: '/reference/' },
      { 
        text: 'Claude Code',
        items: [
          { text: 'Workspace Setup', link: '/claude-code/workspace' },
          { text: 'Workflows', link: '/claude-code/workflows' },
          { text: 'Tmux Integration', link: '/claude-code/tmux' }
        ]
      }
    ],

    // Sidebar navigation
    sidebar: {
      '/getting-started/': [
        {
          text: 'Getting Started',
          items: [
            { text: 'Installation', link: '/getting-started/' },
            { text: 'Quick Setup', link: '/getting-started/quick-setup' },
            { text: 'Safety First', link: '/getting-started/safety' },
            { text: 'Modern Tools', link: '/getting-started/tools' }
          ]
        }
      ],
      
      '/guide/': [
        {
          text: 'Configuration Guide',
          items: [
            { text: 'Overview', link: '/guide/' },
            { text: 'Git Configuration', link: '/guide/git' },
            { text: 'Tmux Setup', link: '/guide/tmux' },
            { text: 'Shell Enhancement', link: '/guide/shell' },
            { text: 'Editor Integration', link: '/guide/editors' }
          ]
        },
        {
          text: 'Package Management',
          items: [
            { text: 'GNU Stow Basics', link: '/guide/stow' },
            { text: 'Package Structure', link: '/guide/packages' },
            { text: 'Deployment', link: '/guide/deployment' },
            { text: 'Rollback & Recovery', link: '/guide/rollback' }
          ]
        }
      ],

      '/claude-code/': [
        {
          text: 'Claude Code Integration',
          items: [
            { text: 'Workspace Setup', link: '/claude-code/workspace' },
            { text: 'Multi-Session Workflows', link: '/claude-code/workflows' },
            { text: 'Tmux Configuration', link: '/claude-code/tmux' },
            { text: 'Git Worktrees', link: '/claude-code/worktrees' },
            { text: 'Vim Integration', link: '/claude-code/vim' }
          ]
        },
        {
          text: 'Advanced Features',
          items: [
            { text: 'Automation Scripts', link: '/claude-code/automation' },
            { text: 'Session Management', link: '/claude-code/sessions' },
            { text: 'Best Practices', link: '/claude-code/best-practices' }
          ]
        }
      ],

      '/reference/': [
        {
          text: 'Reference',
          items: [
            { text: 'Command Reference', link: '/reference/' },
            { text: 'Configuration Files', link: '/reference/configs' },
            { text: 'Scripts & Tools', link: '/reference/scripts' },
            { text: 'Troubleshooting', link: '/reference/troubleshooting' }
          ]
        },
        {
          text: 'Phase Documentation',
          items: [
            { text: 'Phase 1: Foundation', link: '/reference/phase-1' },
            { text: 'Phase 2: Shell', link: '/reference/phase-2' },
            { text: 'Phase 3: Editor', link: '/reference/phase-3' },
            { text: 'Phase 4: Integration', link: '/reference/phase-4' }
          ]
        }
      ]
    },

    // Social links
    socialLinks: [
      { icon: 'github', link: 'https://github.com/kormie/dotclaude' }
    ],

    // Footer
    footer: {
      message: 'Built for the future of AI-assisted development',
      copyright: 'Copyright © 2024-2025 '
    },

    // Search
    search: {
      provider: 'local'
    },

    // Edit link
    editLink: {
      pattern: 'https://github.com/kormie/dotclaude/edit/main/docs/:path',
      text: 'Edit this page on GitHub'
    },

    // Last updated
    lastUpdated: {
      text: 'Last updated',
      formatOptions: {
        dateStyle: 'short',
        timeStyle: 'short'
      }
    }
  },

  // Markdown configuration
  markdown: {
    lineNumbers: true,
    theme: {
      light: 'github-light',
      dark: 'github-dark'
    }
  },

  // Head configuration
  head: [
    ['link', { rel: 'icon', href: '/dotclaude/favicon.ico' }],
    ['meta', { name: 'theme-color', content: '#646cff' }],
    ['meta', { name: 'og:type', content: 'website' }],
    ['meta', { name: 'og:locale', content: 'en' }],
    ['meta', { name: 'og:site_name', content: 'DotClaude' }],
    ['meta', { name: 'og:image', content: '/dotclaude/og-image.png' }]
  ]
})