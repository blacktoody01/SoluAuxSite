# ---------- Produção: nginx sem root, só arquivos estáticos ----------
FROM nginxinc/nginx-unprivileged:1.27-alpine AS app
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/seguranca.conf /etc/nginx/snippets/seguranca.conf
COPY --chmod=755 nginx/15-whatsapp.sh /docker-entrypoint.d/15-whatsapp.sh
COPY site/ /usr/share/nginx/html/
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz >/dev/null || exit 1

# ---------- Testes (Admin → Testes) ----------
FROM alpine:3.20 AS test
RUN apk add --no-cache curl
WORKDIR /teste
COPY site/ ./site/
COPY tests/run-tests.sh ./run-tests.sh
RUN chmod +x ./run-tests.sh
CMD ["./run-tests.sh"]
