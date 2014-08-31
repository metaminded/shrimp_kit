module ShrimpKit
  module PrawnExtension
    def html_formatted_text(html)
      renderer = ShrimpKit::Renderer.new(html)
      renderer.add_to_pdf(self)
    end
  end
end
