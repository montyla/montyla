# Pacote do cliente MeuRO (local)

Isto **nao e** o jogo completo. Nao inclui kRO, `data.grf` nem o Ragexe da Gravity (sao arquivos oficiais, cada um baixa o proprio).

Este pacote so tem a configuracao do **seu** servidor rAthena:

| Item | Valor |
|---|---|
| Nome na lista | MeuRO Local |
| IP | `127.0.0.1` |
| Porta de login | **6901** (a 6900 e do Cursor) |
| PACKETVER / Ragexe | **2021-11-03** |
| Web-server | `127.0.0.1:8888` |
| Conta | `paulo` / `vitor` (nao use `s1`) |

## O que tem aqui

```
client-pack/
  copiar-para-kro.bat
  DATA.ini
  WARP-patches.txt
  data/clientinfo.xml
  data/sclientinfo.xml
  data/luafiles514/lua files/service_korea/ExternalSettings_kr.lub
  data/luafiles514/lua files/service_usa/ExternalSettings_usa.lub
  System/ExternalSettings_kr.lub
  System/ExternalSettings_usa.lub
```

## Como usar (Windows)

1. Extraia um **kRO Full Client 2022–2024** em `C:\RO\kRO\` ate existir `data.grf`.
   Nao use kRO 2025+ com este Ragexe.
2. Baixe o Ragexe **2021-11-03_Ragexe_1635926200**:
   http://nemo.herc.ws/downloads/
3. Rode `copiar-para-kro.bat` (edite `KRO_DIR` no bat se a pasta for outra).
4. Patcheie o Ragexe com o WARP usando `WARP-patches.txt`.
   Salve o resultado como `C:\RO\kRO\MeuRO.exe`.
5. Ligue `login-server`, `char-server`, `web-server` e `map-server`.
6. Abra `MeuRO.exe` e entre com **paulo** / **vitor**.

## Se o servidor nao aparecer na lista

- O `clientinfo.xml` tem que estar em `C:\RO\kRO\data\`
- O exe tem que estar na **mesma pasta** do `data.grf`
- A porta no XML e **6901**, nao 6900
- O patch **Load custom ClientInfo file** precisa estar aplicado

## Licenca

Os arquivos `.lub` seguem o formato publico do [ROenglishRE](https://github.com/llchrisll/ROenglishRE), ajustados para `127.0.0.1:8888`.
