# vim: foldmethod=marker foldlevel=0

config.load_autoconfig()

c.tabs.background = True
c.new_instance_open_target = 'window'
c.downloads.position = 'bottom'
# c.spellcheck.languages = ['en-US']

css = '~/.config/qutebrowser/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css'
config.bind(',n', f'config-cycle content.user_stylesheets {css} ""')

c.fonts.default_family = 'JetBrainsMono Nerd Font'
c.fonts.default_size = '11pt'
#c.fonts.web.family.standard = 'Clear Sans'

c.search.incremental = False
c.editor.command = ['code', '-nw', '{}']

# c.content.javascript.enabled = False

config.source('gruvbox.py')

# set dark mode
c.colors.webpage.bg = 'black' # "black" get's rid of flashes, but does seem to break certain websites
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.threshold.text = 150
c.colors.webpage.darkmode.threshold.background = 100
c.colors.webpage.darkmode.policy.images = 'smart'
# c.colors.webpage.darkmode.grayscale.images = 0.35

c.qt.args = [ "blink-settings=darkMode=4" ]

# always restore open sites when qutebrowser is reopened
c.auto_save.session = True

# bind M to hinting and showing a video via mpv
config.bind('M', 'hint links spawn mpv {hint-url}')
