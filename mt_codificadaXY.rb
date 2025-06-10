# traduzido para o formato que a MTU entende.
module CodificadaXY
  def self.linker
    # 1. Definições usando o esquema de codificação da MTU
    # Estados: q0="fa", q1="faa", q2="fb" (final)
    q0 = "fa"
    q1 = "faa"
    q2_final = "fb" 

    # Símbolos: x="sc", y="scc", B (branco)="_"
    x = "sc"
    y = "scc"
    b = "_" 

    # Movimentos: Direita="d", Esquerda="e"
    dir = "d"
    esq = "e"

    # d(q0, x) = (q1, x, D) -> A máquina lê x, escreve x e vai para q1.
    d1 = "#{q0}#{x}#{q1}#{y}#{dir}"

    # d(q1, y) = (q1, y, D) -> Continua consumindo y's
    d2 = "#{q1}#{y}#{q1}#{y}#{dir}"

    # d(q1, B) = (q2, B, E) -> Encontrou o branco, vai para o estado final e aceita.
    d3 = "#{q1}#{b}#{q2_final}#{b}#{esq}"

    # 2. Juntar as transições em uma única string
    return [d1, d2, d3].join
  end

  def self.codificacao_cadeia
    # Cadeia de entrada: "xyyy"
    x = "sc"
    y = "scc"
    return "#{x}#{y}#{y}#{y}"
  end
end