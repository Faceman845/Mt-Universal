class MTU
  BLANK = "_"
  log = false # logs para debug
  
  attr_accessor :fita, :estado, :cursor, :transicoes, :fita_simulada, :aceito, :estados_debug

  def initialize
    @estado = :parsing
    @cursor = 0
    @transicoes = {}
    @fita = ""
    @fita_simulada = []
    @aceito = false
    @estados_debug = []
  end
  # Processa a entrada no formato "MT#cadeia"
  # onde MT é a codificação da máquina de Turing e cadeia é a entrada
  def processar(entrada)
    @fita = entrada + (" " * 1000)
    @cursor = 0
    @transicoes = {}
    @fita_simulada = []
    @aceito = false
    @estados_debug = []
    
    # Parse da entrada: MT#cadeia
    partes = entrada.split('#')
    return false if partes.length != 2
    
    codificacao_mt = partes[0]
    cadeia_entrada = partes[1]
    
    # Parse das transições
    if !parse_transicoes(codificacao_mt)
      puts "Erro no parsing das transições"
      return false
    end
    
    # Parse da cadeia de entrada
    if !parse_cadeia_entrada(cadeia_entrada)
      puts "Erro no parsing da cadeia"
      return false
    end
    
    puts "Transições parseadas: #{@transicoes.size}"
    puts "Cadeia parseada: #{@fita_simulada.join(' ')}"
    
    # Simula a máquina
    return simular_maquina
  end

  private

  def parse_transicoes(codificacao)
    i = 0
    puts "Parseando: #{codificacao}"
    
    while i < codificacao.length
      # Busca por início de transição (estado começando com 'f')
      if codificacao[i] == 'f'
        transicao = extrair_transicao(codificacao, i)
        if transicao
          estado_orig, simbolo_orig, estado_dest, simbolo_dest, movimento = transicao
          chave = [estado_orig, simbolo_orig]
          valor = [estado_dest, simbolo_dest, movimento]
          @transicoes[chave] = valor
          # Avança para após esta transição completa
          i += comprimento_transicao(transicao)
        else
          i += 1
        end
      else
        i += 1
      end
    end
    
    puts "Total de transições parseadas: #{@transicoes.size}"
    @transicoes.each { |k, v| puts "  #{k} -> #{v}" }
    
    return @transicoes.size > 0
  end

  def extrair_transicao(codigo, pos)
    return nil if pos >= codigo.length
    
    # Deve começar com 'f' (estado)
    return nil unless codigo[pos] == 'f'
    
    inicio = pos
    
    # Estado origem
    estado_orig = extrair_estado(codigo, pos)
    return nil unless estado_orig
    pos += estado_orig.length
    
    # Símbolo origem 
    simbolo_orig = extrair_simbolo(codigo, pos)
    return nil unless simbolo_orig
    pos += simbolo_orig.length
    
    # Estado destino
    return nil if pos >= codigo.length || codigo[pos] != 'f'
    estado_dest = extrair_estado(codigo, pos)
    return nil unless estado_dest
    pos += estado_dest.length
    
    # Símbolo destino
    simbolo_dest = extrair_simbolo(codigo, pos)
    return nil unless simbolo_dest
    pos += simbolo_dest.length
    
    # Movimento
    return nil if pos >= codigo.length
    movimento = codigo[pos]
    return nil unless ['d', 'e'].include?(movimento)
    
    # Debug da transição extraída
    transicao_str = codigo[inicio..pos]
    return [estado_orig, simbolo_orig, estado_dest, simbolo_dest, movimento]
  end

  def extrair_estado(codigo, pos)
    return nil if pos >= codigo.length || codigo[pos] != 'f'
    
    estado = 'f'
    pos += 1
    
    # Conta 'a's para estados normais ou 'b's para estados de aceitação
    if pos < codigo.length && codigo[pos] == 'a'
      while pos < codigo.length && codigo[pos] == 'a'
        estado += 'a'
        pos += 1
      end
    elsif pos < codigo.length && codigo[pos] == 'b'
      while pos < codigo.length && codigo[pos] == 'b'
        estado += 'b'
        pos += 1
      end
    end
    
    return estado
  end

  def extrair_simbolo(codigo, pos)
    return nil if pos >= codigo.length

    # Símbolo branco
    return BLANK if codigo[pos] == BLANK
    
    # Símbolos que começam com 's'
    if codigo[pos] == 's'
      # Verifica se é um símbolo simples como 's', 'sx', 'sy', 'sz'
      if pos + 1 < codigo.length
        char_after_s = codigo[pos + 1]
        if ['x', 'y', 'z'].include?(char_after_s)
          return "s" + char_after_s # e.g., sx, sy, sz
        end
      end

      # Símbolos que começam com 's' e podem ter 'c's
      # Exemplo: sc, scc, sccc, etc.
      simbolo = 's'
      current_idx = pos + 1
      while current_idx < codigo.length && codigo[current_idx] == 'c'
        simbolo += 'c'
        current_idx += 1
      end
      return simbolo # Retorna s, sc, scc, etc.
    end

    return nil # Não é um símbolo válido
  end

  def comprimento_transicao(transicao)
    estado_orig, simbolo_orig, estado_dest, simbolo_dest, movimento = transicao
    return estado_orig.length + simbolo_orig.length + 
           estado_dest.length + simbolo_dest.length + 1
  end

  def parse_cadeia_entrada(cadeia)
    @fita_simulada = []
    i = 0
    
    while i < cadeia.length
      # Verifica se o caractere atual pode iniciar um símbolo
      if ['s', '_'].include?(cadeia[i])
        simbolo = extrair_simbolo(cadeia, i)
        if simbolo
          @fita_simulada << simbolo
          i += simbolo.length
        else
          # Se extrair_simbolo retornar nil, algo está errado, mas avançamos para evitar loop infinito
          i += 1
        end
      else
        i += 1
      end
    end
    
    return true
  end

  def simular_maquina
    @estado_simulado = "fa"  # Estado inicial
    @posicao_simulada = 0
    max_passos = 10000
    passos = 0

    puts "Iniciando simulação com estado: #{@estado_simulado}"
    
    while passos < max_passos
      # Expande fita se necessário
      while @posicao_simulada >= @fita_simulada.length
        @fita_simulada << BLANK
      end

      simbolo_atual = @fita_simulada[@posicao_simulada]
      chave = [@estado_simulado, simbolo_atual]
      if @log
        puts "Passo #{passos}: Estado=#{@estado_simulado}, Pos=#{@posicao_simulada}, Simbolo=#{simbolo_atual}"
      end
      # Verifica se existe transição
      if @transicoes.key?(chave)
        prox_estado, novo_simbolo, movimento = @transicoes[chave]
        if @log
          puts "  Transição encontrada: #{chave} -> #{[prox_estado, novo_simbolo, movimento]}"
        end
        # Executa transição
        @fita_simulada[@posicao_simulada] = novo_simbolo
        @estado_simulado = prox_estado
        @estados_debug << @estado_simulado
        
        # Move cabeçote
        case movimento
        when 'd'
          @posicao_simulada += 1
        when 'e'
          @posicao_simulada -= 1 if @posicao_simulada > 0
        end
      else
        # Sem transição: verifica se é estado de aceitação
        puts "  Sem transição. Verificando aceitação..."
        @aceito = @estado_simulado.start_with?('fb')
        puts "  Estado final: #{@estado_simulado}, Aceito: #{@aceito}"
        return @aceito
      end

      passos += 1
    end
    
    puts "Limite de passos excedido"
    return false
  end
end