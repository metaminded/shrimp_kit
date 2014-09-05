module ShrimpKit
  class Renderer
    attr_accessor :container

    def initialize(str)
      @html_raw = str
      @html = Nokogiri::HTML.parse(str)
      @body = @html / 'html/body'
      @container = NodeProcessor.process @body
    end

    def to_file(filename, options={})
      Prawn::Document.generate(filename) do |pdf|
        add_to_pdf(pdf, options)
      end
    end

    def add_to_pdf(pdf, options={})
      @container.render(pdf, options)
    end
  end
end
