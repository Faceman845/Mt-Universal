module CodificadaAB
  def self.linker
    # Estados: fa=q0, faa=q1, faaa=q2, fb=qf
    # Símbolos: _=branco, sc=a, scc=b, sx=X, sy=Y
    
    # Cada transição: estado_origem + simbolo_origem + estado_destino + simbolo_destino + movimento
    transicoes = [ 
    # q0,a -> q1,X,d (marca primeiro a)
    "fa" + "sc" + "faa" + "sx" + "d",

    # q1,a -> q1,a,d (pula demais a's)
    "faa" + "sc" + "faa" + "sc" + "d",

    # q1,Y -> q1,Y,d (pula Y's já marcados)
    "faa" + "sy" + "faa" + "sy" + "d",

    # q1,b -> q2,Y,e (marca primeiro b e volta)
    "faa" + "scc" + "faaa" + "sy" + "e",

    # q2,Y -> q2,Y,e (volta passando por Y's)
    "faaa" + "sy" + "faaa" + "sy" + "e",

    # q2,a -> q2,a,e (volta passando por a's)
    "faaa" + "sc" + "faaa" + "sc" + "e",

    # q2,X -> q0,X,d (volta ao início para próximo ciclo)
    "faaa" + "sx" + "fa" + "sx" + "d",

    # q0,X -> q0,X,d (pula X's já processados)
    "fa" + "sx" + "fa" + "sx" + "d",

    # q0,Y -> q0,Y,d (pula Y's)
    "fa" + "sy" + "fa" + "sy" + "d",
    
    # q0,branco -> qf,branco,d (aceita quando só restam marcações)
    "fa" + "_" + "fb" + "_" + "d"
    ]

    return transicoes.join # Use join para concatenar todas as strings
  end

  def self.codificacao_cadeia
    # Cadeia "aabb" = sc sc scc scc
    "scsc" + "sccscc"
  end
end