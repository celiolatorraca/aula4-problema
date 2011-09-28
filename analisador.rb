class AnalisadorER
  
  #Expressões Regulares
  @@patterns = {
    :p1 => /(\|\d+\|(     ))+(\|\d+\|)$?/,
    :p2 => /(>>>>>\(\d+\))+/,
    :p3 => /(\d+:)+(\d+)$?/
  }
  
  def initialize input_folder, output_folder
    @input_folder, @output_folder = input_folder, output_folder
  end

  def analisar!
    #Cria a pasta de saída caso não exista
    unless File.exists? @output_folder
      Dir.mkdir @output_folder
    end
    
    #Conteúdo de cada tipo de arquivo
    contents = {
      :p1 => [],
      :p2 => [],
      :p3 => []
    }

    #Itera pelos arquivos da pasta informada
    Dir.entries(@input_folder).each do |entry|
      arq_name = "#{@input_folder}/#{entry}"

      if File.file? arq_name
        content = File.read arq_name

        @@patterns.each_pair do |key,pattern|
          if content.scan(pattern).size > 0
            contents[key] << content
          end
        end
        
      end
    end

    #Itera pelos resultados e cria os arquivos com todos os conteúdos de cada padrão
    contents.each_pair do |key,content|
      File.open "#{@output_folder}/saida_#{key}", "w" do |file|
        file.write content.join("\n")
      end
    end

  end
end

AnalisadorER.new(ARGV[0], ARGV[1]).analisar!