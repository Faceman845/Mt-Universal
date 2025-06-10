require_relative 'maquina_turing_universal'
require_relative 'mt_codificada'
require_relative 'mt_codificada1'  
require_relative 'mt_codificada2'
require_relative 'mt_codificadaXY'

testes = [
  { nome: "xy*",     linker: CodificadaXY.method(:linker),       cadeia: CodificadaXY.method(:codificacao_cadeia) },
  { nome: "aⁿbⁿ",         linker: CodificadaAB.method(:linker),      cadeia: CodificadaAB.method(:codificacao_cadeia) },
  { nome: "aⁿbⁿcⁿ",       linker: CodificadaABC.method(:linker),     cadeia: CodificadaABC.method(:codificacao_cadeia) },
  { nome: "multiplicação", linker: CodificadaMult.method(:linker), cadeia: CodificadaMult.method(:codificacao_cadeia) }
]

testes.each do |teste|
  puts "\n--- Testando Máquina: #{teste[:nome]} ---"

  entrada = teste[:linker].call + "#" + teste[:cadeia].call
  mt = MTU.new

  puts "Entrada: #{entrada[0..100]}..." if entrada.length > 100
  puts "Entrada: #{entrada}" if entrada.length <= 100
  resultado = mt.processar(entrada)

  puts "Resultado: #{resultado ? "ACEITA" : "REJEITA"}"
  puts "Fita final: #{mt.fita_simulada.join('|')}" if mt.fita_simulada.any?
end