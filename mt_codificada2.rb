module CodificadaMult  
  def self.linker
    # Estados: fa= q0, faa= q1, faaa= q2, faaaa= q3, fb= qf
    # Para cada 'a', percorre todos os 'b's e gera um 'c' para cada
    
    transicoes = [
      # q0,a -> q1,X,d (marca um a)
      "fa", "sc", "faa", "sx", "d",

      # q1: procura um b não marcado
      "faa", "sc", "faa", "sc", "d",   # pula a's (não X)
      "faa", "sx", "faa", "sx", "d",   # pula X's (outros a's marcados)
      "faa", "sy", "faa", "sy", "d",   # pula Y's (b's já marcados para este a)
      "faa", "scc", "faaa", "sy", "d", # marca b como Y, vai para q2 (faaa)

      # Se q1 (faa) vê um 'c' (sccc) ou branco (_), todos os 'b's para o 'a' atual foram processados.
      # Vá para o estado q4 (faaaaa) para resetar Ys para Bs e então pegar o próximo 'a'.
      "faa", "sccc", "faaaaa", "sccc", "e", # Encontrou 'c', vá para q4 (reset), mova E
      "faa", "_", "faaaaa", "_", "e",    # Encontrou branco, vá para q4 (reset), mova E

      # q2 (faaa): vai até o fim da fita e adiciona um c
      "faaa", "scc", "faaa", "scc", "d",  # pula b's
      "faaa", "sy", "faaa", "sy", "d",    # pula Y's
      "faaa", "sccc", "faaa", "sccc", "d",# pula c's existentes
      "faaa", "_", "faaaa", "sccc", "e",  # adiciona 'c' no branco, vai para q3 (faaaa) e volta E

      # q3 (faaaa): volta para continuar multiplicação (para o MESMO 'a'/X, encontrar o próximo 'b')
      "faaaa", "sccc", "faaaa", "sccc", "e", # volta por c's
      "faaaa", "sy", "faaaa", "sy", "e",     # volta por Y's (b marcado)
      "faaaa", "scc", "faaaa", "scc", "e",   # volta por b's (não marcados)
      "faaaa", "sc", "faaaa", "sc", "e",     # volta por a's (não marcados X)
      "faaaa", "sx", "faa", "sx", "d",       # encontrou X do 'a' atual, volta para q1 (faa) procurar próximo 'b', mova D

      # NOVO ESTADO q4 (faaaaa): rebobina, reseta Ys para Bs, e então vai para q0 para o próximo 'a'
      "faaaaa", "sccc", "faaaaa", "sccc", "e", # Pula 'c's existentes, movendo E
      "faaaaa", "sy", "faaaaa", "scc", "e",   # Encontrou Y, muda para B (scc), mova E
      "faaaaa", "scc", "faaaaa", "scc", "e",  # Pula B's (originais ou já resetados), mova E
      "faaaaa", "sc", "faaaaa", "sc", "e",   # Pula 'a's (não X), mova E
      "faaaaa", "sx", "fa", "sx", "d",      # Encontrou o X de um 'a' processado, vá para q0 (fa), mova D (para achar próximo 'a' ou finalizar)

      # q0 (fa): quando não há mais 'a's para marcar (todos são X's)
      "fa", "sx", "fa", "sx", "d",      # Pula todos X's (a's já processados)
     
      # Se q0 encontrar Y aqui, é um estado inesperado ou o reset falhou.
      "fa", "sy", "fa", "sy", "d",      # Pula Y's (se algum sobrou)
      "fa", "scc", "fa", "scc", "d",    # Pula todos b's (scc)
      "fa", "sccc", "fa", "sccc", "d",  # Pula todos c's (sccc)
      "fa", "_", "fb", "_", "d"         # Encontrou branco, aceita (fb)
    ]
        
    return transicoes.join
  end

  def self.codificacao_cadeia  
    # Cadeia "aaabb" = 3×2 deve gerar 6 c's
    "scscsc" + "sccscc"  # 3 a's + 2 b's
  end
end