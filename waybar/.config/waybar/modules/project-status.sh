#!/usr/bin/env bash
# Muestra la sesion tmux activa o el directorio actual

active_session=$(tmux display-message -p '#S' 2>/dev/null || echo "")

if [[ -n "$active_session" ]]; then
  echo "$active_session"
else
  echo "sin proyecto"
fi
