# SoluAux — site institucional (soluaux.com.br)

Landing page da SoluAux: sistema de pedidos para açaiterias e sorveterias, ajustes sob medida, diferenciais e contato.

## Como roda

- **nginx sem root** (`nginxinc/nginx-unprivileged`), só arquivos estáticos em `site/`.
- Container `soluaux_site`, **sem portas publicadas**: o acesso é só pelo Caddy do AdminGestor (`soluaux_caddy`) na rede `soluaux_proxy`. O domínio fica em `Admin-Gestor/proxy/conf.d/site.caddy`.
- Endurecido: sistema de arquivos somente leitura, `cap_drop: ALL`, `no-new-privileges`, limite de memória/CPU/processos, só GET/HEAD, cabeçalhos de segurança (CSP, HSTS, X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy) e versão do nginx escondida.

## Gerenciar pelo AdminGestor (sem abrir a VPS)

Cadastro em **Admin → Apps → Cadastrar Aplicação**:

| Campo | Valor |
|---|---|
| Nome | SoluAux Site |
| URL do Repositório Git | `https://github.com/blacktoody01/SoluAuxSite` |
| Branch | `main` |
| Diretório na VPS | `/root/SoluAuxSite` |
| Arquivo Compose | `docker-compose.yml` |

O primeiro **Atualizar na VPS** clona o repositório sozinho. Depois é só `git push` e **Atualizar**.

### WhatsApp dos botões

Em **Configurar .env**, preencha `WHATSAPP_NUMERO` (DDI + DDD + número, só dígitos, ex.: `5563999999999`) e salve reiniciando. Vazio = os botões levam ao Instagram @soluaux.

### Testes (Admin → Testes)

- **Unitários:** confere os arquivos do site.
- **Rotinas:** sobe um servidor de teste separado e confere página, número do WhatsApp, cabeçalhos de segurança, bloqueio de POST e de arquivos ocultos.

## Editar o conteúdo

- Textos: `site/index.html`
- Visual: `site/assets/style.css` (cores no topo do arquivo)
- Imagens: `site/assets/`

Para ver no computador: `python3 -m http.server 8080` dentro de `site/` e abrir `http://localhost:8080`.
