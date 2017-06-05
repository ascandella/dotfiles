# Environment file for all projects.
#  - (de)activates Python virtualenvs (.venv) from pipenv

if [[ $autoenv_event == 'enter' ]]; then
  autoenv_source_parent

  _my_autoenv_venv_chpwd() {
    if [[ -z "$_ZSH_ACTIVATED_VIRTUALENV" && -n "$VIRTUAL_ENV" ]]; then
      return
    fi

    setopt localoptions extendedglob
    local -a venv
    venv=(./(../)#.venv(NY1:A))

    if [[ -n "$_ZSH_ACTIVATED_VIRTUALENV" && -n "$VIRTUAL_ENV" ]]; then
      if ! (( $#venv )) || [[ "$_ZSH_ACTIVATED_VIRTUALENV" != "$venv[1]" ]]; then
        unset _ZSH_ACTIVATED_VIRTUALENV
        echo "De-activating virtualenv: ${(D)VIRTUAL_ENV}" >&2
        deactivate
      fi
    fi

    if [[ -z "$VIRTUAL_ENV" ]]; then
      if (( $#venv )); then
        echo "Activating virtualenv: ${(D)venv}" >&2
        source $venv[1]/bin/activate
        _ZSH_ACTIVATED_VIRTUALENV="$venv[1]"
      fi
    fi
  }
  autoload -U add-zsh-hook
  add-zsh-hook chpwd _my_autoenv_venv_chpwd
  _my_autoenv_venv_chpwd
else
  add-zsh-hook -d chpwd _my_autoenv_venv_chpwd
fi
