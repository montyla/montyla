# montyla

## Scripts customizados

Arquivos adicionados:

- `npc/custom/vip_system.txt`
  - Mantem o comportamento do script enviado: no login, se a conta estiver VIP, mostra o tempo restante e aplica `SC_VIPSTATE`; no logout, remove o status visual para atualizar o timer no proximo login.
  - Adiciona um comando scriptado `@storage` que so abre o armazem quando `vip_status(VIP_STATUS_ACTIVE)` estiver ativo.
- `npc/custom/curandeira_para_todos.txt`
  - Cria uma curandeira em Prontera que cura HP/SP e remove alguns status negativos sem verificar VIP.

Para carregar os scripts, adicione no arquivo de imports do seu emulador:

```txt
npc: npc/custom/vip_system.txt
npc: npc/custom/curandeira_para_todos.txt
```

Observacao sobre `@storage`: mantenha o `@storage` padrao desabilitado para jogadores comuns/grupos normais no `groups.conf`. Assim o comando scriptado fica responsavel por liberar o armazem apenas para contas VIP.
