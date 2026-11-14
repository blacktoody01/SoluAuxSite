#!/bin/sh
# Lê WHATSAPP_NUMERO do ambiente, mantém só dígitos e gera o trecho que o nginx usa
# para trocar o marcador __WHATSAPP_NUMERO__ no HTML. Sem número, o site usa o Instagram.
set -eu
numero=$(printf '%s' "${WHATSAPP_NUMERO:-}" | tr -cd '0-9' | cut -c1-15)
printf "sub_filter '__WHATSAPP_NUMERO__' '%s';\nsub_filter_once on;\n" "$numero" > /tmp/whatsapp.inc
if [ -n "$numero" ]; then
  echo "WhatsApp do site: configurado (${#numero} dígitos)"
else
  echo "WhatsApp do site: vazio — botões levam ao Instagram"
fi
