module ShrimpKit
  class Renderer
    attr_accessor :container

    def initialize(str)
      @html_raw = str
      @html = Nokogiri::HTML.parse(str)
      @body = @html / 'html/body'
      @container = NodeProcessor.process @body
    end

    def to_file(filename)
      Prawn::Document.generate(filename) do |pdf|
        add_to_pdf(pdf)
      end
    end

    def add_to_pdf(pdf)
      @container.render(pdf)
    end
  end
end
