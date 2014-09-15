module ShrimpKit
  class Renderer
    attr_accessor :container

    def initialize(str, css_files: [])
      @html_raw = str
      @html = Nokogiri::HTML.parse(str)
      @body = (@html / 'html/body').first
      @container = NodeProcessor.process @body, css_files: css_files
    end

    def to_file(filename, options={})
      Prawn::Document.generate(filename) do |pdf|
        add_to_pdf(pdf, options)
      end
    end

    def add_to_pdf(pdf, options={})
      @container.render(pdf, options: options)
    end
  end
end
