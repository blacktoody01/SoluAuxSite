#!/bin/sh
# Testes do site SoluAux para o Admin → Testes.
# TEST_TIPO: unit (arquivos), rotinas (servidor de teste) ou tudo.
TIPO="${TEST_TIPO:-tudo}"
BASE="${TEST_BASE_URL:-http://app-test:8080}"
PASSOU=0
FALHOU=0

ok()   { PASSOU=$((PASSOU+1)); echo "  ✔ $1"; }
erro() { FALHOU=$((FALHOU+1)); echo "  ✘ $1"; }
checa() { if eval "$2"; then ok "$1"; else erro "$1"; fi; }

if [ "$TIPO" = "unit" ] || [ "$TIPO" = "tudo" ]; then
  echo "== Unitários (arquivos do site) =="
  checa "index.html existe" "[ -f site/index.html ]"
  checa "CSS e JS existem" "[ -f site/assets/style.css ] && [ -f site/assets/site.js ]"
  checa "logo existe" "[ -f site/assets/logo-soluaux.png ]"
  checa "marcador do WhatsApp presente" "grep -q '__WHATSAPP_NUMERO__' site/index.html"
  checa "sem scripts inline executáveis" "! grep -Eq '<script>|<script type=\"text/javascript\"' site/index.html"
  checa "título da página" "grep -q '<title>SoluAux' site/index.html"
  checa "preço do açaí" "grep -q '89,99' site/index.html"
  for f in $(grep -o 'src=\"/assets/[^\"]*\"\|href=\"/assets/[^\"]*\"' site/index.html | sed 's/.*\"\/\(assets\/[^\"]*\)\"/\1/' | sort -u); do
    checa "arquivo referenciado: $f" "[ -f site/$f ]"
  done
fi

if [ "$TIPO" = "rotinas" ] || [ "$TIPO" = "tudo" ]; then
  echo "== Rotinas (servidor de teste em $BASE) =="
  H=$(curl -s -D - -o /tmp/index.html "$BASE/")
  checa "página inicial responde 200" "echo \"\$H\" | head -1 | grep -q ' 200'"
  checa "número do WhatsApp aplicado no HTML" "grep -q \"$TEST_WHATSAPP\" /tmp/index.html && ! grep -q '__WHATSAPP_NUMERO__' /tmp/index.html"
  checa "cabeçalho CSP" "echo \"\$H\" | grep -qi '^content-security-policy:'"
  checa "cabeçalho X-Frame-Options" "echo \"\$H\" | grep -qi '^x-frame-options: DENY'"
  checa "cabeçalho nosniff" "echo \"\$H\" | grep -qi '^x-content-type-options: nosniff'"
  checa "versão do nginx escondida" "! echo \"\$H\" | grep -qi '^server: nginx/'"
  checa "CSS responde 200" "[ \"\$(curl -s -o /dev/null -w '%{http_code}' $BASE/assets/style.css)\" = 200 ]"
  checa "healthz responde" "[ \"\$(curl -s $BASE/healthz)\" = ok ]"
  checa "POST é recusado" "[ \"\$(curl -s -o /dev/null -w '%{http_code}' -X POST $BASE/)\" = 403 ]"
  checa "arquivo oculto não é servido" "[ \"\$(curl -s -o /dev/null -w '%{http_code}' $BASE/.env)\" = 404 ]"
fi

echo "SOLUAUX_TEST_RESULT {\"passou\": $PASSOU, \"falhou\": $FALHOU}"
[ "$FALHOU" -eq 0 ]
