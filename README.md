# Mt-Universal
Maquina de Turing Universal

Para adicionar sua própria máquina codificada ou alterar uma existente:

- Crie a nova maquina como um módulo

Parâmetros:
| Componente | Codificação |
| :--- | :--- |
| **Estados de não-aceitação** | `fa`, `faa`, `faaa`, ... |
| **Estados de aceitação** | `fb`, `fbb`, `fbbb`, ... |
| **Símbolos da fita** | `sc` (para 'a'), `scc` (para 'b'), etc. |
| **Símbolo branco** | `_` |
| **Movimentos** | `d` (direita), `e` (esquerda) |

- Crie o require_relative dela no main.rb adicione dento de testes, exemplo:

`{ nome: "nomeDeExemplo", linker: mTcodificadaExemplo.method(:linker), cadeia: mTcodificadaExemplo.method(:codificacao_cadeia)`

ou siga o modelo das maquinas codificadas ja criadas.
