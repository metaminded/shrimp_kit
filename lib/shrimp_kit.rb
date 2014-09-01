gem 'prawn'
gem 'prawn-table'

require 'active_support/all'
require 'prawn'
require 'prawn/table'
require 'nokogiri'
require 'prawn/measurement_extensions'

module ShrimpKit
  DEMO = <<-HTML
    <h1>Überschrift</h1>
    <p>Dieses ist ein <b>Fetter</b> Text, alter!</p>
    <div>Dies ist ein <i>kursiver</i>. So ein Spaß!</div>
    <p>Dies ist ein <i>kursiver mit <b>fett</b> drin</i> – mit einem <br/>Umbruch drin! wie cool!</p>
    <p>Und <a href="/foo">Linx</a> gehen (irgendwann) auch!</p>
    <h2>Unterüberschrift</h2>
    <div><p>Dieses ist ein <b>Fetter</b> Text, alter!</p></div>
    <ul>
    <li>ping</li>
    <li>pong</li>
    <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
      cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
      proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      <ul>
        <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod</li>
        <li>tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,</li>
        <li>quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo</li>
        <li>consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse</li>
        <li>cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non</li>
        <li>proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</li>
      </ul>
      <li>Hurz!</li>
    </ul>
    <i><p>Hier ist mal die Reihenfolge umgekehrt. Also i aussen, und p innen.</p></i>
    <h3>Noch 'ne Tabelle:</h3>
    <table>
      <tr><th><b>Dings</b></th><th>Bums!</th></tr>
      <tr><td><i>Foo</i></td><td>Bar!</td></tr>
    </table>

  HTML

  def self.to_pdf_file(filename, html)
    renderer = Renderer.new(html)
    renderer.to_file(filename)
  end
end

require_relative './shrimp_kit/default_styles'
require_relative './shrimp_kit/element'
require_relative './shrimp_kit/table_element'
require_relative './shrimp_kit/node_processor'
require_relative './shrimp_kit/table_node_processor'
require_relative './shrimp_kit/renderer'
require_relative './shrimp_kit/prawn_extension'

Prawn::Document.send(:include, ShrimpKit::PrawnExtension)
