require 'actionpack'
require 'prawn/measurement_extensions'
require 'prawn'

module ShrimpKit
  DEMO2 = <<-HTML
    <h1>Überschrift</h1>
    <p>Dieses ist ein <b>Fetter</b> Text, alter!</p>
    <div>Dies ist ein <i>kursiver</i>. So ein Spaß!</div>
    <p>Dies ist ein <i>kursiver mit <b>fett</b> drin</i> – mit einem <br/>Umbruch drin! wie cool!</p>
    <p>Und <a href="/foo">Linx</a> gehen (irgendwann) auch!</p>
  HTML
  DEMO = <<-HTML
    <h1>Überschrift</h1>
  HTML

  def self.to_pdf_file(filename, html)
    renderer = Renderer.new(html)
    renderer.to_file(filename)
  end
end

require 'shrimp_kit/default_styles'
require 'shrimp_kit/element'
require 'shrimp_kit/node_processor'
require 'shrimp_kit/renderer'
require 'shrimp_kit/prawn_extension'

Prawn::Document.send(:include, ShrimpKit::PrawnExtension)
