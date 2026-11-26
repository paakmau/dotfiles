$env.config.show_banner = false
$env.config.buffer_editor = 'hx'

$env.config.history = {
  file_format: sqlite
  isolation: true
  sync_on_enter: true
}

{{ if eq .chezmoi.os "windows" -}}
alias open = powershell.exe ii
{{ else -}}
alias open = xdg-open
{{ end -}}
