module ShrimpKit
  module PrawnExtension
    def html_formatted_text(html, css_files: [], css: '', line_height: nil, leading: nil)
      custom_css = css
      custom_css += (css_files || []).map do |css_file|
                                            File.read(css_file)
                                          end.join("\n")

      renderer = ShrimpKit::Renderer.new(html, custom_css: custom_css)
      renderer.add_to_pdf(self, line_height: line_height, leading: leading)
    end
  end
end
