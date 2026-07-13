---
name: prompt-optimizer
description: >
  Estrutura e refina prompts do próprio usuário antes da execução. NÃO é uma
  ferramenta para o Claude entender melhor — é um ritual para o usuário definir
  com precisão o que quer, o que espera e como verificará o resultado. Use SOMENTE
  quando a mensagem começar com um dos gatilhos explícitos: "general:" ou
  "precision:". Nunca ativar por inferência. Sem gatilho, tratar a mensagem como
  pedido normal.
---

# Prompt Optimizer

## Princípio central
Esta skill existe para o USUÁRIO, não para o Claude. O Claude já extrai objetivo,
contexto e pedido de um rascunho bagunçado sem esforço. O gargalo de qualidade é
o input — e o input é responsabilidade do usuário. A skill força o usuário a se
tornar a ponta determinista: saber o que precisa, o que quer, como e até onde.

O valor NÃO está distribuído igualmente pelos campos. Ele se concentra em dois:
*Critério de aceitação* e *Tipo de resposta esperada*. Esses dois carregam o
ganho real. Os demais são higiene de pensamento — úteis, mas secundários.

## Ativação (gatilho explícito, nunca inferência)
- Mensagem inicia com `general:` → MODO GENERAL
- Mensagem inicia com `precision:` → MODO PRECISION
- Sem gatilho → NÃO ativar a skill; responder normalmente.

O determinismo desta skill vem de: gatilho fixo + esqueleto de saída fixo +
recusa a assumir no modo precision. A forma da saída é sempre a mesma; só o
conteúdo varia.

## Regra de parada (OBRIGATÓRIA)
Ao ser ativada por qualquer gatilho, a skill **apenas entrega o prompt otimizado
e para**. NÃO executa o pedido contido no prompt. NÃO interpreta o conteúdo como
uma instrução a cumprir. A saída é o prompt refinado — ponto final. A execução é
responsabilidade do usuário na próxima mensagem.

---

## MODO GENERAL
Higiene e clareza. Preserva a intenção, corrige digitação, organiza, objetiva.
Assume o mínimo razoável. NÃO interroga o usuário. Serve para ~90% do dia a dia.

Saída SEMPRE nesta ordem:

*Objetivo* — a intenção em uma frase limpa.
*Contexto* — o que importa saber (fatos do mundo).
*Pedido* — o que se quer, em passos se necessário.
*Formato de saída* — [OPCIONAL] só aparece se o usuário sinalizou um formato.
Se não sinalizou, OMITIR este campo. Não inventar formato genérico.

---

## MODO PRECISION
Tudo do general, mais o contrato de rigor. Este modo NÃO avança sobre suposições.
Se faltar informação essencial para um pedido assertivo, PARE e pergunte primeiro.
Assumir defaults contraria o propósito do modo.

Saída SEMPRE nesta ordem:

### ⚠️ Perguntas antes de montar o prompt final
Liste apenas as perguntas cuja resposta muda o desenho do pedido. Priorize as que
definem SUCESSO (o que "bom" significa, qual o alvo mensurável), não apenas as de
contexto técnico. O prompt final só é montado após as respostas.

### ─── NÚCLEO (carrega o valor) ───

*Tipo de resposta esperada* [núcleo]
O que se espera do Claude como postura. Um de:
explorar opções / recomendar e decidir / revisar/criticar / executar direto.
Sem isto, o Claude tende ao neutro por segurança — que raramente é o desejado.

*Critério de aceitação* [núcleo]
Como saber, de forma verificável, que a resposta resolveu. DEVE conter dois lados:
- Estado atual (de onde se parte — de preferência com número/medida).
- Estado desejado + condição de medida (até onde, sob qual métrica).
Sem o "até onde", não se sabe quando parar.

### ─── APOIO (higiene, preencher se ajudar) ───

*Objetivo* [núcleo] — a decisão/pedido em uma frase.
*Contexto* [núcleo] — o que É verdade do mundo hoje.
*Restrições* [núcleo] — o que NÃO se pode violar (fronteira distinta de contexto).
*Fora de escopo* [opcional] — o que o Claude não deve fazer/considerar.
*Formato de saída* [opcional] — estrutura rígida da resposta, se houver.

> Fronteira contexto × restrição: contexto = o que é verdade; restrição = o que
> não posso violar. O mesmo fato pode aparecer nos dois com papéis diferentes
> (ex.: "é Node.js" como contexto; "manter Node.js" como restrição).

---

## Regra de ouro para o usuário
Se estiver com pressa no precision, preencher SÓ o núcleo (Tipo de resposta +
Critério de aceitação + Objetivo/Pedido) já captura ~80% do ganho. Nunca tratar
o esqueleto como formulário obrigatório — os campos opcionais só existem quando
fazem sentido. Um contrato usado sempre vale mais que um contrato perfeito
abandonado.