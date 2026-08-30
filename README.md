# Montyla — rAthena Gold Times

Servidor Ragnarok Online classico **99/70 Pre-Renewal**, baseado no emulador open-source [rAthena](https://github.com/rathena/rathena) (GPL-3.0).

O pacote comercial "Gold Times" vendido em marketplaces nao e codigo aberto. Esta base usa o rAthena oficial com o mesmo recorte classico (level maximo 99/70, mecanicas pre-renewal, VIP, NPCs de private server) e compilacao otimizada para Linux.

## O que ja vem configurado

| Item | Valor |
| --- | --- |
| Modo | Pre-Renewal (`--enable-prere`) |
| Level | Base 99 / Job 70 |
| Cliente | PACKETVER `20180620` (2018-06-20eRagexeRE) |
| Rates | EXP 10x, drops 10x, cartas 5x |
| Rede | `epoll` + LTO + `-O3 -march=x86-64-v2` |
| Banco | MariaDB local, usuario `ragnarok` |
| VIP | compilado (`--enable-vip`) |
| Conta GM local | `montyla` / `montyla` (grupo 99) |

## Comandos

```bash
./scripts/install.sh        # dependencias + clone + compile
./scripts/start.sh          # sobe o MariaDB e importa o schema
./scripts/start-servers.sh  # login :6900, char :6121, map :5121
```

O cliente precisa apontar `clientinfo.xml` / `sclientinfo.xml` para o IP do servidor na porta **6900**. Contas novas: sufixo `_M` ou `_F` no usuario (ex.: `jogador_M`).

Antes de publicar o servidor, troque a senha do banco em `overlay/conf/import/inter_conf.txt` e defina `char_ip` / `map_ip` com o IP publico.

## Personalizacao

Arquivos em `overlay/` sao copiados para `rathena/` em todo `install`/`build`:

- `overlay/conf/import/battle_conf.txt` — rates, aura, ASPD
- `overlay/conf/import/char_conf.txt` — nome do servidor, zeny inicial
- `overlay/npc/custom/gold_times/` — NPCs proprios

O fonte do rAthena fica em `rathena/` (clonado na instalacao). Nao commite binarios (`login-server`, `map-server`).
