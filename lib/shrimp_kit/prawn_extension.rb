module ShrimpKit
  module PrawnExtension
    def html_formatted_text(html, css_files: [])
      renderer = ShrimpKit::Renderer.new(html, css_files: css_files)
      renderer.add_to_pdf(self)
    end
  end
end
