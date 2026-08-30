# Montyla — rAthena Gold Times

Servidor Ragnarok Online clássico **99/70 Pré-Renewal**, baseado no emulador open-source [rAthena](https://github.com/rathena/rathena) (GPL-3.0).

O pacote comercial "Gold Times" vendido em marketplaces não é código aberto. Esta base usa o rAthena oficial com o mesmo recorte clássico (nível máximo 99/70, mecânicas pré-renewal, VIP, NPCs de private server) e compilação otimizada para Linux.

## O que já vem configurado

| Item | Valor |
| --- | --- |
| Modo | Pré-Renewal (`--enable-prere`) |
| Nível | Base 99 / Classe 70 |
| Cliente | PACKETVER `20180620` (2018-06-20eRagexeRE) |
| Idioma | Português brasileiro (pt-BR) |
| Rates | EXP 10x, drops 10x, cartas 5x |
| Rede | `epoll` + LTO + `-O3 -march=x86-64-v2` |
| Banco | MariaDB local, usuário `ragnarok` |
| VIP | compilado (`--enable-vip`) |
| Conta GM local | `montyla` / `montyla` (grupo 99) |

## Localização pt-BR

O servidor fala português brasileiro por padrão:

- Pacote oficial `map_msg_por.conf` (comandos `@`, nomes de classe, avisos do mapa) instalado como idioma padrão, convertido para UTF-8
- Mensagens de login e do char-server traduzidas
- MOTD, quadro de boas-vindas e NPCs custom (Teleporte, Mestre de Classes, Curandeiro, Estilista, Reset, Platinum)
- `@langtype por` permanece disponível (`LANG_ENABLE 0x80`)
- Exemplo de cliente em `overlay/client/sclientinfo.xml.example` com `langtype` 12 (Brasil)

Itens, skills e interface do cliente continuam no GRF. Use um data/grf pt-BR no cliente para completar a tradução visual.

```bash
./scripts/test-locale.sh      # confere a localização sem subir o map-server
```

## Comandos

```bash
./scripts/install.sh        # dependências + clone + compile
./scripts/start.sh          # sobe o MariaDB e importa o schema
./scripts/start-servers.sh  # login :6900, char :6121, map :5121
```

O cliente precisa apontar `clientinfo.xml` / `sclientinfo.xml` para o IP do servidor na porta **6900**. Contas novas: sufixo `_M` ou `_F` no usuário (ex.: `jogador_M`).

Antes de publicar o servidor, troque a senha do banco em `overlay/conf/import/inter_conf.txt` e defina `char_ip` / `map_ip` com o IP público.

## Personalização

Arquivos em `overlay/` são copiados para `rathena/` em todo `install`/`build`:

- `overlay/conf/import/battle_conf.txt` — rates, aura, ASPD
- `overlay/conf/import/char_conf.txt` — nome do servidor, zeny inicial
- `overlay/conf/motd.txt` — mensagem do dia
- `overlay/conf/msg_conf/` — login, char e overrides pt-BR
- `overlay/npc/custom/` — NPCs próprios traduzidos
- `overlay/client/sclientinfo.xml.example` — langtype 12

O fonte do rAthena fica em `rathena/` (clonado na instalação). Não commite binários (`login-server`, `map-server`).
