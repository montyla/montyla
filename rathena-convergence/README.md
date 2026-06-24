# Sistema de Convergencia para rAthena

Modulo script-first para implementar uma mecanica inspirada na Convergence do Tibia em servidores Ragnarok baseados em rAthena moderno.

Ele foi pensado para um servidor onde um jogador ativo gera cerca de **100kk de zeny por dia**. O foco e criar uma queima de zeny longa, opcional e com ganho moderado de poder.

## O que o sistema faz

- Adiciona tiers permanentes de **T1 ate T5** em equipamentos.
- Usa **Random Options** para guardar o tier no proprio item.
- Nao exige alteracao no core C/C++.
- Permite:
  - deposito de zeny em creditos de Convergencia;
  - evolucao normal com chance de falha;
  - evolucao por Convergencia com 100% de sucesso;
  - transferencia normal com perda de 1 tier;
  - transferencia por Convergencia sem perda de tier.

## Arquivos

```txt
rathena-convergence/
  conf/import/scripts_custom.conf
  db/import/item_randomopt_db.yml
  npc/custom/convergence_forge.txt
```

## Instalacao

Copie os arquivos para o seu rAthena:

```txt
rathena-convergence/npc/custom/convergence_forge.txt
  -> npc/custom/convergence_forge.txt

rathena-convergence/db/import/item_randomopt_db.yml
  -> db/import/item_randomopt_db.yml
```

Depois adicione esta linha em `conf/import/scripts_custom.conf`:

```txt
npc: npc/custom/convergence_forge.txt
```

Reinicie o `map-server` ou use os reloads equivalentes do seu servidor:

```txt
@reloaditemdb
@reloadscript
```

Em alguns casos, Random Options novas exigem restart completo do map-server.

## NPC

O NPC nasce em:

```txt
prontera,156,184,4
```

Para mudar o local, edite a primeira linha do NPC em:

```txt
npc/custom/convergence_forge.txt
```

## Como os custos funcionam

O NPC nao consome zeny diretamente na forja. Primeiro o jogador deposita zeny e recebe creditos:

```txt
1 credito = 100,000 zeny
```

Isso evita problemas em servidores com limite de zeny carregavel menor que alguns custos de endgame.

O zeny e queimado no momento do deposito. A forja consome os creditos.

## Custos padrao

### Evolucao normal

| Tier final | Custo | Chance |
|---|---:|---:|
| T1 | 100kk | 80% |
| T2 | 300kk | 65% |
| T3 | 750kk | 50% |
| T4 | 1.5b | 35% |
| T5 | 3b | 25% |

Falhas consomem os creditos. Por padrao, ha 30% de chance de o item perder 1 tier quando a tentativa falha.

### Evolucao por Convergencia

| Tier final | Custo | Chance |
|---|---:|---:|
| T1 | 250kk | 100% |
| T2 | 750kk | 100% |
| T3 | 1.8b | 100% |
| T4 | 4b | 100% |
| T5 | 8b | 100% |

Convergencia e a rota segura. Ela nao foi feita para ser custo-beneficio; ela existe para jogadores que querem previsibilidade.

### Transferencia normal

| Origem | Alvo recebe | Custo |
|---|---:|---:|
| T2 | T1 | 300kk |
| T3 | T2 | 750kk |
| T4 | T3 | 1.5b |
| T5 | T4 | 3b |

A origem perde o tier.

### Transferencia por Convergencia

| Origem | Alvo recebe | Custo |
|---|---:|---:|
| T1 | T1 | 500kk |
| T2 | T2 | 1.2b |
| T3 | T3 | 2.5b |
| T4 | T4 | 5b |
| T5 | T5 | 10b |

A origem perde o tier, mas o alvo recebe o mesmo tier sem reducao.

## Buffs padrao

Os buffs ficam em `db/import/item_randomopt_db.yml`.

| Slot | Efeito por tier |
|---|---|
| Arma | +1% ATK e +1% MATK por tier |
| Armadura | +1% HP, +5 DEF e +1 MDEF por tier |
| Capa | +3 Flee e +1 Perfect Dodge por tier |
| Botas | +1% ASPD e -1% cast variavel por tier |
| Elmo topo | +1 todos atributos por tier |

Exemplos:

- Arma T5: +5% ATK/MATK.
- Armadura T5: +5% HP, +25 DEF, +5 MDEF.
- Botas T5: +5% ASPD, -5% cast variavel.

## Slots suportados

Por padrao:

- arma da mao direita (`EQI_HAND_R`);
- armadura (`EQI_ARMOR`);
- capa (`EQI_GARMENT`);
- botas (`EQI_SHOES`);
- elmo topo (`EQI_HEAD_TOP`).

Voce pode adicionar outros slots no `OnInit` do NPC:

```txt
setarray .EquipSlot[0],EQI_HAND_R,EQI_ARMOR,EQI_GARMENT,EQI_SHOES,EQI_HEAD_TOP;
setarray .OptionId[0],.OptWeapon,.OptArmor,.OptGarment,.OptShoes,.OptHeadTop;
setarray .SlotName$[0],"Arma","Armadura","Capa","Botas","Elmo topo";
```

Se adicionar elmo meio/baixo, recomendo criar Random Options separadas para evitar que tres headgears escalem demais.

## Configuracoes principais

No `OnInit` do NPC:

```txt
.CreditUnit = 100000;
.MaxTier = 5;
.FailDowngradeRate = 30;

setarray .CostNormal[1],1000,3000,7500,15000,30000;
setarray .CostConverge[1],2500,7500,18000,40000,80000;
setarray .CostTransferNormal[1],0,3000,7500,15000,30000;
setarray .CostTransferConverge[1],5000,12000,25000,50000,100000;
setarray .ChanceNormal[1],80,65,50,35,25;
```

Os custos estao em creditos. Com `.CreditUnit = 100000`:

```txt
1000 creditos = 100kk zeny
10000 creditos = 1b zeny
```

## Observacoes importantes

### 1. Random Option ID

Este pacote usa os IDs `5001` a `5005`.

Se o seu servidor ja usa esses IDs, altere os IDs em:

- `db/import/item_randomopt_db.yml`
- `npc/custom/convergence_forge.txt`

### 2. Display no client

Para o client mostrar nomes bonitos das Random Options, voce precisa adicionar as opcoes no arquivo Lua/Lub de random options do seu client, normalmente algo como:

```txt
data/luafiles514/lua files/datainfo/addrandomoptionnametable.lub
```

Sem isso, o bonus ainda funciona no servidor, mas o client pode exibir nome vazio/desconhecido.

### 3. Limite de slots de Random Option

O NPC procura uma Random Option de Convergencia existente. Se nao encontrar, usa o primeiro slot livre.

Se o item ja tiver todos os slots de Random Option ocupados, a forja bloqueia a acao.

### 4. Transferencia entre slots

A transferencia funciona entre slots diferentes equipados ao mesmo tempo. Exemplo:

```txt
Arma T3 -> Armadura T0 = Armadura T3 por Convergencia
Arma T3 -> Armadura T0 = Armadura T2 por transferencia normal
```

Essa versao script-only nao transfere entre dois itens do mesmo slot, porque o jogador nao consegue equipar origem e alvo no mesmo slot ao mesmo tempo. Para suportar isso, voce precisaria de uma versao mais avancada que selecione itens do inventario via `getinventorylist` ou altere o core.

## Balanceamento recomendado

Com media de 100kk/dia:

| Perfil | Tier esperado |
|---|---|
| Casual | T1 |
| Ativo | T2 |
| Dedicado | T3 |
| Endgame | T4 |
| Competitivo/rico | T5 |

Se o seu servidor tiver muito mais zeny entrando, aumente primeiro os custos de:

1. transferencia por Convergencia;
2. T4/T5 por Convergencia;
3. chance de falha ou downgrade da evolucao normal.

Se o servidor for pre-renewal ou tiver dano muito baixo, reduza os buffs de arma e elmo antes de reduzir custos.
