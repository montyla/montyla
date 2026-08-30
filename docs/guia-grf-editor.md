# Guia do GRF Editor para quem nunca mexeu nisso

Este texto ensina a usar o **GRF Editor** do zero. Não assume que você já saiba o que é GRF, cliente, sprite ou `DATA.INI`.

Leia na ordem. Cada seção depende da anterior.

---

## Índice

1. [O que você está mexendo, em uma analogia](#1-o-que-você-está-mexendo-em-uma-analogia)
2. [Servidor e cliente: a diferença que evita 90% da confusão](#2-servidor-e-cliente-a-diferença-que-evita-90-da-confusão)
3. [O que é um arquivo GRF](#3-o-que-é-um-arquivo-grf)
4. [O que o GRF Editor faz](#4-o-que-o-grf-editor-faz)
5. [O que você precisa no computador](#5-o-que-você-precisa-no-computador)
6. [Como baixar e instalar](#6-como-baixar-e-instalar)
7. [Regra de ouro: nunca edite o data.grf original](#7-regra-de-ouro-nunca-edite-o-datagrf-original)
8. [Primeiro contato com a tela do programa](#8-primeiro-contato-com-a-tela-do-programa)
9. [Abrir um GRF e olhar os arquivos](#9-abrir-um-grf-e-olhar-os-arquivos)
10. [Procurar um arquivo](#10-procurar-um-arquivo)
11. [Extrair arquivos para o computador](#11-extrair-arquivos-para-o-computador)
12. [A pasta `data` e por que o caminho importa](#12-a-pasta-data-e-por-que-o-caminho-importa)
13. [Criar o seu GRF customizado (o jeito certo)](#13-criar-o-seu-grf-customizado-o-jeito-certo)
14. [Fazer o cliente usar o seu GRF: o `DATA.INI`](#14-fazer-o-cliente-usar-o-seu-grf-o-dataini)
15. [Mapa das pastas mais usadas](#15-mapa-das-pastas-mais-usadas)
16. [Exercício guiado: trocar uma tela de loading](#16-exercício-guiado-trocar-uma-tela-de-loading)
17. [Tarefas comuns (item, NPC, mapa, som)](#17-tarefas-comuns-item-npc-mapa-som)
18. [Nomes em coreano, encoding e arquivos `.lub`](#18-nomes-em-coreano-encoding-e-arquivos-lub)
19. [Salvar, compactar e o que acontece se você fechar sem salvar](#19-salvar-compactar-e-o-que-acontece-se-você-fechar-sem-salvar)
20. [Erros frequentes e como resolver](#20-erros-frequentes-e-como-resolver)
21. [O que o GRF Editor não faz](#21-o-que-o-grf-editor-não-faz)
22. [Relação com o rAthena deste repositório](#22-relação-com-o-rathena-deste-repositório)
23. [Ferramentas vizinhas (quando precisar)](#23-ferramentas-vizinhas-quando-precisar)
24. [Checklist rápido](#24-checklist-rápido)
25. [Glossário](#25-glossário)
26. [Fontes e onde pedir ajuda](#26-fontes-e-onde-pedir-ajuda)

---

## 1. O que você está mexendo, em uma analogia

Imagine o Ragnarok como um teatro:

- O **servidor** é o palco, as regras e o juiz. Ele decide se o item existe, quanto dano dá, se o monstro dropa, se o NPC vende.
- O **cliente** é o que o jogador instala no PC. Ele desenha o personagem, toca o som, mostra o mapa e a janela de inventário.
- O **GRF** é a **caixa de cenário** do cliente: sprites, texturas, mapas, efeitos, sons, fontes e vários arquivos de texto/Lua.

O GRF Editor é a ferramenta para **abrir essa caixa**, tirar coisas, colocar coisas novas e fechar de novo.

Se você mudar só o servidor, o item pode existir mas aparecer como ponto de interrogação no cliente.  
Se você mudar só o cliente, a imagem pode aparecer mas o servidor não reconhecer o item.

Os dois lados precisam conversar.

```
  Jogador
     |
     |  abre o .exe do Ragnarok
     v
  Cliente (pasta do jogo no Windows)
     |  lê DATA.INI
     |  abre os .grf na ordem
     |  desenha sprites, mapas, sons
     |
     |  conecta na rede
     v
  Servidor rAthena (login / char / map)
     |  decide regras, itens, drops, NPCs
```

---

## 2. Servidor e cliente: a diferença que evita 90% da confusão

| Coisa | Onde vive | Ferramenta típica |
| --- | --- | --- |
| HP do monstro, drop, script de NPC | Servidor | rAthena (`db/`, `npc/`) |
| Sprite do monstro, ícone do item, mapa visual | Cliente | GRF Editor |
| Nome do item na janela | Quase sempre no cliente (`iteminfo`) | GRF Editor + editor de texto |
| Se o item existe de verdade | Servidor (`item_db`) | editor YAML/SQL do rAthena |
| Mapa jogável (colisão, warps) | Servidor **e** cliente | GRF Editor + `mapcache` no rAthena |

Este guia cobre **só o lado do cliente**, que é onde o GRF entra.

O rAthena deste repositório quase não “abre o GRF do jogador”. Ele usa um `map_cache.dat` gerado a partir dos mapas. Isso aparece em `rathena/conf/grf-files.txt` e em `rathena/doc/map_cache.txt`. Você só precisa disso quando for adicionar **mapa customizado**.

---

## 3. O que é um arquivo GRF

`GRF` significa *Gravity Resource File*. É o formato de arquivo que o Ragnarok usa para guardar milhares de arquivos em um único volume, comprimidos.

Pense em um `.zip` ou `.rar`, mas feito especialmente para o jogo.

Arquivos típicos na pasta do cliente:

| Arquivo | O que costuma ser |
| --- | --- |
| `data.grf` | Arquivo principal oficial. Tem a maior parte do jogo. **Não edite.** |
| `rdata.grf` | Conteúdo extra / mais novo (Sakray / renewal). **Não edite.** |
| `sdata.grf` | Nome antigo, equivalente ao `rdata` em clientes bem velhos. |
| `montyla.grf` (exemplo) | O GRF **seu**, com customizações. É este que você cria e edita. |
| `algo.gpf` | Mesmo formato do GRF. O nome `.gpf` costuma indicar patch. |
| `algo.thor` | Patch usado pelo Thor Patcher para atualizar o cliente dos jogadores. |

Sem o `data.grf`, o cliente em geral nem abre.

---

## 4. O que o GRF Editor faz

O programa mais usado hoje é o **GRF Editor**, feito pelo Tokei (Tokeiburu).

Ele consegue:

- Abrir `.grf`, `.gpf` e `.thor`
- Ver pastas e arquivos como um Explorador do Windows
- Pré-visualizar imagens, sprites, alguns mapas e textos
- Extrair arquivos para o HD
- Criar um GRF novo
- Adicionar, substituir, renomear e apagar arquivos
- Procurar por nome
- Converter encoding de nomes de arquivo
- (Avançado) criptografar GRF e gerar patch Thor

Ele **não** é:

- Um Photoshop (não “desenha” o sprite do zero)
- Um editor de mapa completo (para isso existe BrowEdit / WeeMapCache)
- Um editor do servidor rAthena
- Um programa para “hackear” o jogo dos outros

---

## 5. O que você precisa no computador

O GRF Editor é programa de **Windows**.

Você precisa de:

1. **Windows 10 ou 11** (o caminho normal).
2. **.NET Framework 4.0 ou superior**. O instalador avisa se faltar. No Windows 10/11 isso quase sempre já existe.
3. A **pasta do cliente** do seu Ragnarok (a pasta onde está o `.exe` do jogo, o `data.grf` e o `DATA.INI`).
4. Um pouco de espaço em disco. GRFs oficiais são grandes (vários GB).

Se você usa Linux ou macOS, o cliente de Ragnarok privado normalmente ainda roda no Windows. Dá para tentar via Wine, mas para iniciante o recomendado é Windows.

**Não precisa saber programar.**

---

## 6. Como baixar e instalar

Use a fonte oficial, não um “GRF Editor + no delay” de blog aleatório.

### Download

1. Abra o GitHub do autor: [https://github.com/Tokeiburu/GRFEditor/releases](https://github.com/Tokeiburu/GRFEditor/releases)
2. Baixe a versão mais recente (no momento da escrita deste guia: **v1.9.1.2**).
3. Alternativa conhecida da comunidade: página no rAthena, [GRF Editor](https://rathena.org/board/files/file/2766-grf-editor/).

O código-fonte está em [https://github.com/Tokeiburu/GRFEditor](https://github.com/Tokeiburu/GRFEditor).

### Instalação

1. Extraia o `.zip` baixado.
2. Execute `GRF Editor Installer.exe` (ou o instalador que vier no pacote).
3. Se o Windows pedir o .NET Framework, aceite e instale.
4. Ao terminar, abra o atalho **GRF Editor** no Desktop.

Se o Windows SmartScreen avisar “Windows protegeu o seu PC”, isso acontece com programas pouco assinados. Confira se o download veio do GitHub/rAthena. Só então clique em **Mais informações** → **Executar assim mesmo**.

### Primeira abertura

Na primeira vez o programa pode pedir encoding e algumas opções. Deixe o padrão. Se nomes de pasta aparecerem como `????` ou `????`, vá até a seção [18](#18-nomes-em-coreano-encoding-e-arquivos-lub).

---

## 7. Regra de ouro: nunca edite o data.grf original

Isso é a regra mais importante deste guia.

| Faça | Não faça |
| --- | --- |
| Copie o `data.grf` para um backup (`data.grf.bak`) | Abrir o `data.grf` oficial, mexer e salvar por cima |
| Criar um GRF novo só com as suas mudanças | Juntar tudo dentro do `data.grf` |
| Colocar o seu GRF na posição `0=` do `DATA.INI` | Apagar o `data.grf` |

Por quê:

- O `data.grf` oficial tem milhares de arquivos. Se corromper, o cliente quebra e você rebaixa o cliente inteiro.
- Customizar em um GRF separado deixa o trabalho pequeno, organizável e fácil de distribuir para os jogadores.
- Se algo der errado, você só apaga o seu GRF. O jogo original continua lá.

**Antes de qualquer teste:** copie a pasta do cliente inteira, ou pelo menos `data.grf`, `rdata.grf` e `DATA.INI`, para um lugar seguro.

Feche o Ragnarok **antes** de salvar um GRF que o jogo esteja usando. Arquivo aberto pelo jogo não pode ser gravado direito.

---

## 8. Primeiro contato com a tela do programa

Ao abrir, você vê algo parecido com o Explorador de Arquivos:

```
+------------------+-----------------------------------+
|  Árvore de       |  Lista de arquivos da pasta       |
|  pastas          |  selecionada                     |
|  (esquerda)      |                                   |
|                  +-----------------------------------+
|                  |  Pré-visualização (imagem/sprite/ |
|                  |  texto do arquivo clicado)        |
+------------------+-----------------------------------+
|  Barra de pesquisa / status                          |
+------------------------------------------------------+
```

Peças principais:

- **Menu File**: New, Open, Save, Save As, Close.
- **Menu Edit**: Add, Extract, Delete, Rename, Undo, Redo.
- **Lado esquerdo**: pastas dentro do GRF. Quase sempre começa em `data`.
- **Lado direito**: arquivos da pasta atual.
- **Painel de preview**: mostra o conteúdo quando o tipo é suportado (BMP, TGA, JPG, SPR, alguns textos).
- **Caixa de busca**: procura pelo nome do arquivo.

Você ainda não precisa de Tools, Encrypt, Thor, Hash, etc. Isso é etapa avançada.

---

## 9. Abrir um GRF e olhar os arquivos

1. Abra o GRF Editor.
2. Clique em **File → Open** (ou `Ctrl+O`).
3. Vá até a pasta do cliente. Exemplo típico:

   `C:\Ragnarok\data.grf`

4. Espere carregar. GRF grande demora alguns segundos. Não feche no meio.
5. Clique na pasta `data` à esquerda.
6. Clique em um arquivo à direita e olhe o preview.

Se o preview de sprite aparecer, o programa está funcionando.

Não salve nada neste momento. Você está só **olhando**.

---

## 10. Procurar um arquivo

Os GRFs oficiais têm dezenas de milhares de arquivos. Não navegue “no olho”.

1. Use a caixa de **Search** / lupa.
2. Digite parte do nome. Exemplos:
   - `prontera` — arquivos do mapa de Prontera
   - `loading` — telas de carregamento
   - `poring` — sprite do Poring
   - `knife` — item faca, se o nome interno for esse
3. Dê Enter.
4. Clique no resultado. O programa pula para a pasta certa.

Dicas:

- A busca costuma ser pelo **nome do arquivo**, não pelo nome em português que você vê no jogo.
- O nome interno de um item quase nunca é o nome bonito da loja. O ícone de “Espada de Uma Mão” pode se chamar `검.bmp` ou `sword.bmp`.
- Se nada aparecer, o arquivo pode estar em outro GRF (`rdata.grf`). Abra o outro arquivo e busque de novo.

---

## 11. Extrair arquivos para o computador

Extrair = copiar o arquivo de dentro do GRF para uma pasta comum do Windows, para você ver, editar ou guardar.

### Um arquivo só

1. Clique no arquivo.
2. Clique com o botão direito → **Extract**.
3. Escolha uma pasta vazia e fácil de achar, por exemplo:

   `C:\RO-trabalho\extraido`

4. Confirme.

### Uma pasta inteira

1. Clique na pasta na árvore da esquerda.
2. Botão direito → **Extract**.
3. Escolha o destino.

### O GRF inteiro

Só faça isso se tiver disco sobrando. O `data.grf` extraído pode ocupar vários GB.

### Depois de extrair

O arquivo vira um arquivo normal. Você pode:

- Abrir um `.bmp` no Paint / Photoshop / GIMP
- Abrir um `.txt` no Bloco de Notas
- Abrir um `.spr` no Act Editor (veja a seção 23)

O GRF original **não muda** só porque você extraiu.

---

## 12. A pasta `data` e por que o caminho importa

O cliente não procura “qualquer arquivo chamado poring.spr”. Ele procura em um **caminho interno fixo**.

Exemplo real:

```
data\sprite\몬스터\poring.spr
data\sprite\몬스터\poring.act
```

Se você colocar o mesmo `poring.spr` em:

```
data\poring.spr
```

o jogo **não encontra**. Vai continuar usando o sprite antigo, ou mostrar erro / erro de sprite.

Regra prática:

> A estrutura de pastas dentro do seu GRF tem que ser **idêntica** à estrutura original, começando por `data\`.

Fluxo mental:

1. Descubra o caminho original no `data.grf`.
2. Recrie exatamente esse caminho no seu material.
3. Só então empacote.

O `몬스터` no exemplo é coreano. Significa “monstro”. Não traduza a pasta. O cliente procura o nome original.

---

## 13. Criar o seu GRF customizado (o jeito certo)

Este é o fluxo que você deve memorizar.

### Passo 1 — Monte a pasta de trabalho no Windows

Crie algo assim:

```
C:\RO-trabalho\
    backup\                 ← cópias dos GRFs originais
    extraido\               ← o que você tirou do data.grf
    custom\
        data\               ← OBRIGATÓRIO este nome
            texture\
                유저인터페이스\
                    ...
```

A pasta mais de fora que entra no GRF é `data`. Não comece em `texture` direto.

### Passo 2 — Coloque só os arquivos seus

Não copie o jogo inteiro para `custom\data`. Coloque **apenas** o que você mudou.

Exemplo: se você só vai trocar a tela de loading:

```
custom\
    data\
        texture\
            유저인터페이스\
                loading00.jpg
```

### Passo 3 — Crie um GRF novo

1. No GRF Editor: **File → New**.
2. **File → Save As**.
3. Salve na pasta do cliente, com um nome claro, por exemplo:

   `C:\Ragnarok\montyla.grf`

4. Com o GRF novo ainda aberto: **Edit → Add** (ou arraste a pasta `data` para dentro).
5. Selecione a pasta `data` do seu `custom`.
6. Confira se, dentro do GRF, a raiz mostra `data\` e os arquivos no caminho certo.
7. **File → Save**.

### Passo 4 — Não misture com o data.grf

O `montyla.grf` deve ter poucos arquivos. O `data.grf` continua intacto. O cliente junta os dois na leitura.

### Adicionar mais arquivos depois

1. Abra `montyla.grf` (o seu).
2. Add / arraste os novos arquivos no caminho certo.
3. Save.

Se um arquivo já existir no mesmo caminho, o novo **substitui** o antigo. Isso é o que você quer quando está atualizando um custom.

---

## 14. Fazer o cliente usar o seu GRF: o `DATA.INI`

Criar o GRF não basta. O cliente precisa saber que ele existe e **em que ordem** lê os arquivos.

### O que é o DATA.INI

É um arquivo de texto na **mesma pasta do `.exe`** do jogo. Ele lista os GRFs.

Clientes oficiais da Gravity leem só `data.grf` / `rdata.grf`. Clientes de servidor privado (hexed / diffed) precisam da opção **Enable Multiple GRFs**. Sem isso, o `DATA.INI` é ignorado.

Quase todo cliente de servidor privado já vem com isso ligado.

### Como editar

1. Feche o jogo.
2. Na pasta do cliente, ache `DATA.INI` (às vezes `DATA.ini`).
3. Clique com o botão direito → **Abrir com → Bloco de Notas**.
4. Deixe assim, adaptando o nome do seu GRF:

```ini
[data]
0=montyla.grf
1=rdata.grf
2=data.grf
```

### O que o número significa

O número é prioridade. **0 é o mais importante.**

O cliente pergunta: “existe `loading00.jpg`?”

1. Primeiro olha `montyla.grf`.
2. Se não achar, olha `rdata.grf`.
3. Se não achar, olha `data.grf`.

Por isso o seu GRF tem que ser `0=`. Se você colocar o custom em `2=` e o oficial em `0=`, o oficial ganha e sua mudança some.

### Regras

- Máximo típico: **10** GRFs (`0=` até `9=`).
- O nome do arquivo tem que ser **exatamente** o que está na pasta (incluindo `.grf`).
- Não invente caminho completo tipo `C:\Ragnarok\montyla.grf`. Só o nome do arquivo, porque ele já está na pasta do cliente.
- Não deixe espaço estranho: `0 = montyla.grf` pode falhar. Use `0=montyla.grf`.
- Se o seu cliente já tiver um GRF do servidor (`MyRO.grf`, `palete.grf`, etc.), coloque o **seu** acima deles se quiser que ele vença, ou abaixo se for só um extra.

### Pasta `data` solta (sem GRF)

Alguns clientes aceitam uma pasta `data\` ao lado do `.exe` se tiverem o diff **Read Data Folder First**. Isso é útil para testar rápido, mas para distribuir para jogadores o GRF é mais limpo.

Para iniciante: use GRF + `DATA.INI`.

---

## 15. Mapa das pastas mais usadas

Você não precisa decorar tudo. Use esta tabela quando for procurar.

Pastas em coreano aparecem “estranhas” no Windows se a encoding estiver errada. No GRF Editor, com encoding certa, você lê o nome.

| Caminho interno (resumo) | O que tem |
| --- | --- |
| `data\sprite\몬스터\` | Sprites de monstros (`.spr` + `.act`) |
| `data\sprite\npc\` | Sprites de NPCs |
| `data\sprite\아이템\` | Sprites de itens no chão / view |
| `data\sprite\인간족\` | Sprites de personagens (classes) |
| `data\texture\유저인터페이스\item\` | Ícone do item no inventário |
| `data\texture\유저인터페이스\collection\` | Arte grande do item (coleção) |
| `data\texture\유저인터페이스\illust\` | Ilustrações de diálogo |
| `data\texture\` (várias) | Texturas de mapa, UI, loading |
| `data\wav\` | Sons `.wav` |
| `data\luafiles514\lua files\datainfo\` | Lua de itens, hats, IDs |
| `data\` (arquivos `.rsw` `.gnd` `.gat`) | Mapas |
| `data\model\` | Modelos 3D |
| `data\palette\` | Paletas de cor de cabelo/roupa |

O nome `유저인터페이스` significa *user interface* (interface do usuário).  
O nome `아이템` significa *item*.  
O nome `몬스터` significa *monster*.

Se você não conseguir digitar coreano, **copie o nome da pasta de dentro do GRF Editor** e cole. Não tente adivinhar.

---

## 16. Exercício guiado: trocar uma tela de loading

Este exercício existe para você fazer uma mudança **visível** sem quebrar o jogo.

### O que você vai fazer

Trocar a imagem que aparece enquanto o jogo carrega.

### Material

Uma imagem `.jpg` ou `.bmp` no tamanho parecido com a original (muitos clientes usam 256×256 ou 1024×1024; o mais seguro é **abrir a original e copiar o tamanho**).

### Passo a passo

1. Feche o Ragnarok.
2. Copie `data.grf` para `C:\RO-trabalho\backup\`.
3. Abra o GRF Editor → **File → Open** → `data.grf`.
4. Busque `loading`.
5. Clique em um resultado tipo `loading00.jpg` (o nome exato varia).
6. Olhe o preview. Anote o **caminho completo** que aparece (barra de status / coluna de path). Exemplo:

   `data\texture\유저인터페이스\loading00.jpg`

7. Extraia esse arquivo para `C:\RO-trabalho\extraido\`.
8. Abra a imagem extraída em um editor de imagem. Não mude o nome nem a extensão no começo. Só pinte um “TESTE” enorme no meio, salve.
9. Monte:

   ```
   C:\RO-trabalho\custom\data\texture\유저인터페이스\loading00.jpg
   ```

   O nome da pasta coreana deve ser **copiado** do GRF, não traduzido.

10. GRF Editor → **File → New**.
11. **File → Save As** → `C:\Ragnarok\montyla.grf`.
12. Adicione a pasta `data` de `C:\RO-trabalho\custom\`.
13. Confira o caminho dentro do GRF. Tem que bater com o original.
14. **File → Save**. Feche o GRF Editor.
15. Edite o `DATA.INI` como na seção 14, com `0=montyla.grf`.
16. Abra o jogo.

### Resultado esperado

Na tela de loading, sua imagem “TESTE” aparece.

Se o loading antigo continuar:

- o nome do arquivo não é `loading00` no seu cliente
- o caminho da pasta está diferente
- o `DATA.INI` não está com o seu GRF em `0=`
- o jogo não está lendo `DATA.INI` (cliente sem Multiple GRFs)
- você salvou o GRF em outra pasta, não na pasta do `.exe`

---

## 17. Tarefas comuns (item, NPC, mapa, som)

Cada tarefa abaixo assume que você já sabe extrair, montar `data\` e salvar um GRF próprio.

### 17.1. Ícone de um item já existente

O servidor já tem o item. Você só quer mudar a figurinha do inventário.

1. Descubra o **nome do arquivo de sprite/ícone**, não o nome em português.
   - Em clientes recentes isso está em `iteminfo.lua` / `iteminfo_true.lub`.
   - No rAthena, o campo `View` / `sprite` / `identifiedResourceName` aponta para esse nome.
2. Busque esse nome no GRF.
3. Extraia o BMP da pasta `item` (ícone) e, se existir, o da pasta `collection`.
4. Edite a imagem. Mantenha:
   - o mesmo nome
   - a mesma extensão
   - de preferência o mesmo tamanho
5. Coloque no seu GRF no **mesmo caminho**.
6. Teste no jogo com `@item` / loja.

Se o ícone ficar rosa, preto ou “estourado”, a paleta ou o formato da imagem não é o que o cliente espera. Muitos ícones oficiais são BMP 24-bit ou BMP com magenta (`#FF00FF`) como transparência. Comece copiando um BMP oficial e pintando por cima.

### 17.2. Item customizado novo (visão geral)

Aqui o GRF sozinho **não basta**.

Você precisa, no mínimo:

| Lado | O que fazer |
| --- | --- |
| Servidor | Cadastrar o item no `item_db` (YAML do rAthena) com um ID livre |
| Cliente | Ícone (`item`), arte (`collection`), sprite de chão se cair no mapa |
| Cliente | Entrada no `iteminfo` (nome, descrição, resource) |
| Cliente (chapéu) | Se for visual na cabeça: `accessoryid`, `accname`, sprite de view ID |

Ordem sugerida para iniciante:

1. Copie um item oficial parecido (ícone + collection + sprite).
2. Renomeie os arquivos para um nome **novo**, só com letras minúsculas, números e `_`. Evite espaço e acento.
3. Empacote no seu GRF nos caminhos corretos.
4. Só então peça (ou faça) o cadastro no `item_db` e no `iteminfo`.

Se o servidor não tiver o ID, o cliente mostra um item que “não existe”.  
Se o cliente não tiver o `iteminfo`, aparece nome em branco / `Unknown Item`.

### 17.3. Sprite de NPC ou monstro

Cada visual tem **dois** arquivos:

- `.spr` — as imagens (frames)
- `.act` — a animação (quando cada frame aparece, hitbox visual)

Eles andam juntos. Se você trocar só o `.spr` e esquecer o `.act`, a animação quebra.

Para recolorir, o programa irmão é o **Act Editor** (também do Tokei), não o GRF Editor.

Fluxo:

1. Extraia `.spr` e `.act`.
2. Edite no Act Editor.
3. Devolva os dois arquivos ao mesmo caminho no seu GRF.

### 17.4. Som

1. Busque o `.wav` (exemplo: efeito de skill).
2. Extraia.
3. Substitua por outro `.wav` **curto** e no formato que o RO aceita (PCM, qualidade baixa/média costuma funcionar melhor do que um MP3 disfarçado).
4. Mesmo nome, mesmo caminho, no seu GRF.

### 17.5. Mapa customizado (visão geral, sem entrar no editor de mapa)

Um mapa do RO não é “uma imagem”. São vários arquivos, em geral:

| Extensão | Função grosseira |
| --- | --- |
| `.rsw` | Mundo: modelos, luz, água |
| `.gnd` | Chão / terreno |
| `.gat` | Grade de caminhada (onde o personagem anda) |
| `.gat` extra / `.rsm` | Modelos 3D usados no mapa |

No **cliente**, esses arquivos entram no GRF (pasta `data\`).  
No **servidor**, você precisa:

1. Registrar o nome em `rathena/db/map_index.txt`.
2. Gerar / atualizar o `map_cache.dat` com a ferramenta `mapcache`.
3. Apontar o `rathena/conf/grf-files.txt` para o GRF ou pasta que contém o `.gat` e o `.rsw`.

Se você só jogar o mapa no GRF e esquecer o mapcache, o cliente até entra na cidade “bonita”, mas o servidor não trata o chão direito (ou recusa o mapa).

Isso já é um projeto à parte. Não comece por mapa se você ainda está aprendendo a extrair um BMP.

---

## 18. Nomes em coreano, encoding e arquivos `.lub`

### Encoding

O GRF oficial usa encoding coreana (code page 949 / EUC-KR).

Se as pastas aparecerem como `????` ou `Ã­Â•Âœ`:

1. No GRF Editor, abra **Settings** / **Tools → Settings**.
2. Ache a opção de **Encoding**.
3. Selecione Korean / `949` / a opção que o próprio programa oferecer para RO.
4. Reabra o GRF.

Nunca “corrija” o nome da pasta coreana para português. O jogo procura o nome original.

### Arquivos `.lua` e `.lub`

- `.lua` = texto, você pode abrir no Bloco de Notas / VS Code.
- `.lub` = Lua **compilado**. Abrir no Bloco de Notas mostra lixo. Precisa de descompilador (Lua decompiler / unluac / ferramentas da comunidade RO).

Clientes modernos guardam nomes de item em:

- `System\iteminfo.lua` (fora do GRF, ao lado do `.exe`), ou
- `data\luafiles514\lua files\...`

O seu cliente pode usar um ou outro. **Olhe o que já existe no seu cliente** em vez de copiar tutorial de 2012.

Editar Lua com vírgula a mais quebra o cliente no login (“Lua Error”). Sempre faça backup do `iteminfo` antes.

### Caracteres especiais no Windows

O Explorador do Windows às vezes não cria pasta com nome coreano direito. Duas saídas:

- Extraia a pasta inteira pelo GRF Editor (ele cria o nome certo).
- Ou adicione o arquivo **arrastando para a pasta já existente dentro do GRF Editor**, sem recriar a pasta no Windows.

---

## 19. Salvar, compactar e o que acontece se você fechar sem salvar

- O GRF Editor tem **Undo / Redo**. Use se adicionar o arquivo errado.
- **Save** grava no arquivo aberto.
- **Save As** cria outro arquivo. Útil para versionar: `montyla_v2.grf`.
- Fechar sem salvar descarta as mudanças da sessão.
- Depois de Save, o arquivo no disco mudou. O jogo só vê isso na **próxima abertura**. Se o jogo estava aberto, feche e abra de novo.
- Salvamentos grandes (milhares de arquivos) demoram. Espere a barra terminar.

Não copie o GRF para os jogadores no meio de um save. Espere o arquivo fechar no programa.

---

## 20. Erros frequentes e como resolver

| Sintoma | Causa mais comum | O que fazer |
| --- | --- | --- |
| Nada mudou no jogo | GRF não está no `DATA.INI`, ou não está em `0=` | Confira o `DATA.INI` e o nome do arquivo |
| Sprite / ícone de interrogação | Caminho errado, nome errado, ou arquivo não empacotado | Compare o path com o original |
| Cliente fecha ao abrir | GRF corrompido, Lua com erro, GRF salvo por cima do `data.grf` | Restaure o backup; teste tirando o seu GRF do `DATA.INI` |
| “Lua Error” | `iteminfo` / outro Lua quebrado | Restaure o Lua anterior |
| Pastas `????` | Encoding errada | Ajuste Encoding e reabra |
| Não consegue salvar | Jogo aberto, arquivo só leitura, antivírus | Feche o RO, tire só leitura, tente de novo |
| Imagem rosa / preta | Formato/paleta incompatível | Use o BMP original como base |
| Funciona no seu PC e não no do amigo | Você esqueceu de mandar o GRF, ou o `DATA.INI` dele é outro | Envie o `.grf` e o `DATA.INI` atualizado |
| Mapa visual ok, personagem não anda | Falta mapcache no servidor | Veja `rathena/doc/map_cache.txt` |
| Antivírus apaga o GRF Editor | Falso positivo comum em tools de RO | Restaure da quarentena; baixe só do GitHub |

Como isolar o problema:

1. Tire o seu GRF do `DATA.INI` e veja se o jogo volta ao normal.
2. Se voltar, o problema está no seu GRF. Abra-o e confira paths.
3. Se mesmo sem o seu GRF o jogo quebrar, você mexeu no `data.grf` ou no Lua da pasta `System`. Restaure o backup.

---

## 21. O que o GRF Editor não faz

Para não perder tempo procurando botão que não existe:

- Não cadastra item no servidor.
- Não cria NPC falante. NPC é script em `rathena/npc/`.
- Não altera taxa de EXP, drop, ou “VIP”.
- Não traduz o jogo sozinho (tradução é um pacote de arquivos, depois empacotado no GRF).
- Não gera um servidor. O servidor é o rAthena.
- Não “libera” itens oficiais da Gravity. Você trabalha no **seu** cliente/servidor.

Criptografia de GRF (Encrypt) existe no programa para proteger um pouco o conteúdo custom. É assunto avançado: o `.exe` do cliente também precisa ser preparado. Não comece por aí. Primeiro faça o exercício da seção 16 funcionar.

---

## 22. Relação com o rAthena deste repositório

Este repositório tem o emulador em `rathena/`.

Pontos de contato reais com GRF:

| Arquivo no repo | Quando você usa |
| --- | --- |
| `rathena/conf/grf-files.txt` | Quando for gerar `map_cache` a partir de mapas que estão num GRF |
| `rathena/doc/map_cache.txt` | Manual do mapcache |
| `rathena/src/tool/readme.md` | Ferramenta `mapcache` |
| `rathena/db/map_index.txt` | Lista de mapas que o servidor conhece |
| `rathena/db/*/item_db.yml` | Itens do **servidor** (não é GRF) |

O GRF Editor **não** é instalado neste repositório. Ele roda na sua máquina Windows, na pasta do **cliente**.

Fluxo mental do projeto Montyla:

```
Você edita o cliente (GRF Editor)
        |
        |  jogadores baixam montyla.grf + DATA.INI
        v
Cliente de cada jogador  ----rede---->  Servidor rAthena
                                             |
                                             |  você edita scripts/db neste repo
```

Não coloque o `data.grf` oficial (vários GB, conteúdo da Gravity) dentro deste Git. O Git fica para código do servidor, scripts e esta documentação.

---

## 23. Ferramentas vizinhas (quando precisar)

Você **não** precisa delas no primeiro dia. Quando o GRF Editor não der conta:

| Ferramenta | Para quê |
| --- | --- |
| [Act Editor](https://github.com/Tokeiburu/ActEditor) (Tokei) | Abrir e recolorir `.spr` / `.act` |
| BrowEdit / WeeMapCache | Editar mapas |
| Editor de imagem (GIMP, Paint.NET, Photoshop) | BMP, TGA, JPG |
| VS Code / Notepad++ | Lua, TXT, YAML do servidor |
| Thor Patcher | Distribuir atualização do GRF para os jogadores |
| Nemo / WARP (diff do cliente) | Ligar “Multiple GRFs”, “Read Data Folder First”, etc. |

O GRF Editor também sabe gerar `.thor`. Isso entra quando você já tem um patcher. Ignore até ter jogadores para atualizar.

---

## 24. Checklist rápido

Imprima mentalmente isto toda vez:

1. Fechei o Ragnarok?
2. Tenho backup do `data.grf` e do `DATA.INI`?
3. Estou editando o **meu** GRF, não o `data.grf`?
4. O arquivo está em `data\...` com o **mesmo** caminho do original?
5. O nome do arquivo está idêntico, incluindo extensão?
6. Salvei o GRF na pasta do `.exe`?
7. O `DATA.INI` tem `0=meuarquivo.grf`?
8. Abri o jogo de novo depois de salvar?

Se a resposta de algum item for “não sei”, pare e volte para a seção correspondente. Não “tente várias coisas ao mesmo tempo”. Uma variável por teste.

---

## 25. Glossário

| Termo | Significado simples |
| --- | --- |
| Cliente | Programa que o jogador abre no PC |
| Servidor | Programa que roda as regras (rAthena) |
| GRF | Caixa compactada com os arquivos visuais/sonoros do cliente |
| GRF Editor | Programa para abrir e montar GRFs |
| `data.grf` | Caixa oficial principal. Não edite. |
| `DATA.INI` | Lista e ordem dos GRFs que o cliente lê |
| Sprite | Desenho 2D do personagem/monstro/item (`.spr` + `.act`) |
| Textura | Imagem de chão, parede, botão, ícone |
| Lua / Lub | Scripts do **cliente** (nomes de item, hats, etc.) |
| Diff / hexed | Cliente oficial modificado para servidor privado |
| View ID | Número que liga um visual (chapéu, arma) a um sprite |
| Mapcache | Arquivo do **servidor** com a colisão dos mapas |
| Extract | Copiar de dentro do GRF para o Windows |
| Add / Merge | Colocar arquivos do Windows para dentro do GRF |
| Patch Thor | Pacote pequeno de atualização para o patcher |

---

## 26. Fontes e onde pedir ajuda

- Programa: [Tokeiburu/GRFEditor](https://github.com/Tokeiburu/GRFEditor)
- Releases: [github.com/Tokeiburu/GRFEditor/releases](https://github.com/Tokeiburu/GRFEditor/releases)
- Página na comunidade rAthena: [GRF Editor](https://rathena.org/board/files/file/2766-grf-editor/)
- Explicação de `DATA.INI`: [wiki rAthena — DATA.INI](https://github.com/rathena/rathena/wiki/DATA.INI)
- Mapcache do servidor: `rathena/doc/map_cache.txt`

Quando for pedir ajuda, envie:

1. O caminho interno do arquivo (ex.: `data\texture\...\loading00.jpg`)
2. O conteúdo do seu `DATA.INI`
3. Se você editou o `data.grf` ou um GRF separado
4. O que você esperava ver e o que apareceu

Sem isso, ninguém consegue diagnosticar.

---

## Por onde continuar depois deste guia

Ordem saudável:

1. Fazer o exercício da tela de loading.
2. Trocar **um** ícone de item já existente.
3. Entender `iteminfo` do **seu** cliente (Lua da pasta `System` ou do GRF).
4. Só então pensar em item novo, hat, ou mapa.

Não pule para criptografia, Thor e diff de `.exe` enquanto o passo 1 não estiver sólido.
