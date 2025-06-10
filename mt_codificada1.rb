module CodificadaABC
  def self.linker
    # Estados: fa= q0, faa= q1, faaa= q2, faaaa= q3, faaaaa= q4, fb= qf
    # Símbolos: _= branco, sc= a, scc= b, sccc= c, sx= X, sy= Y, sz= Z
    
    transicoes = [
      # q0,a -> q1,X,d
      "fa", "sc", "faa", "sx", "d",
      
      # q1: procura primeiro b
      "faa", "sc", "faa", "sc", "d",   # pula a's
      "faa", "sx", "faa", "sx", "d",   # pula X's
      "faa", "sy", "faa", "sy", "d",   # pula Y's
      "faa", "scc", "faaa", "sy", "d", # marca b como Y
      
      # q2: procura primeiro c
      "faaa", "scc", "faaa", "scc", "d", # pula b's
      "faaa", "sy", "faaa", "sy", "d",   # pula Y's
      "faaa", "sz", "faaa", "sz", "d",  # pula Z's
      "faaa", "sccc", "faaaa", "sz", "e", # marca c como Z e volta
      
      # q3: volta ao início
      "faaaa", "sz", "faaaa", "sz", "e",   # volta passando por Z's
      "faaaa", "sy", "faaaa", "sy", "e",   # volta passando por Y's
      "faaaa", "scc", "faaaa", "scc", "e", # volta passando por b's
      "faaaa", "sc", "faaaa", "sc", "e",   # volta passando por a's
      "faaaa", "sx", "fa", "sx", "d",      # encontrou X, volta para q0
      
      # q0: transições de verificação final
      "fa", "sx", "fa", "sx", "d",  # pula X's
      "fa", "sy", "fa", "sy", "d",  # pula Y's  
      "fa", "sz", "fa", "sz", "d",  # pula Z's
      "fa", "_", "fb", "_", "d"     # branco = aceita
    ]
    
    return transicoes.join
  end

  def self.codificacao_cadeia
    # Cadeia "aabbcc" = sc sc scc scc sccc sccc
    "scsc" + "sccscc" + "scccsccc"
  end
end