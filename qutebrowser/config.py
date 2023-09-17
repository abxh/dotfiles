# vim: foldmethod=marker foldlevel=0

# some things i took and modified from The-Compiler's config: {{{
config.load_autoconfig()

c.tabs.background = True
c.new_instance_open_target = 'window'
c.downloads.position = 'bottom'
c.spellcheck.languages = ['en-US']

# css = '~/Desktop/repos/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css'
# config.bind(',n', f'config-cycle content.user_stylesheets {css} ""')

c.url.searchengines['maps'] = 'https://www.google.com/maps?q={}'

c.aliases['ytdl'] = """spawn -v -m bash -c 'cd ~/Videos && yt-dlp "$@"' _ {url}"""

# c.fonts.statusbar = '8pt JetBrainsMono Nerd Font'
c.fonts.web.family.fantasy = 'Clear Sans'

# c.search.incremental = False
# c.editor.command = ['code', '-nw', '{}']

# c.content.javascript.enabled = False

config.source('gruvbox.py')
# }}}

# prefer dark theme
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.bg = "black"

# always restore open sites when qutebrowser is reopened
c.auto_save.session = True
