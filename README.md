# Mt-Universal
Maquina de Turing Universal

Para adicionar sua própria maquina codificada ou alterar uma existente deve seguir os eguintes parâmetros:

| Componente | Codificação |
| :--- | :--- |
| **Estados de não-aceitação** | `fa`, `faa`, `faaa`, ... |
| **Estados de aceitação** | `fb`, `fbb`, `fbbb`, ... |
| **Símbolos da fita** | `sc` (para 'a'), `scc` (para 'b'), etc. |
| **Símbolo branco** | `_` |
| **Movimentos** | `d` (direita), `e` (esquerda) |
