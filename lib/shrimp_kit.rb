gem 'prawn'
gem 'prawn-table'

require 'active_support/all'
require 'prawn'
require 'prawn/table'
require 'nokogiri'
require 'prawn/measurement_extensions'

module ShrimpKit
  def self.to_pdf_file(filename, html, options: {})
    renderer = Renderer.new(html, css_files: options[:css_files])
    renderer.to_file(filename, options)
  end
end

require_relative './shrimp_kit/default_styles'
require_relative './shrimp_kit/element'
require_relative './shrimp_kit/node_processor'
require_relative './shrimp_kit/css_processor'
require_relative './shrimp_kit/renderer'
require_relative './shrimp_kit/prawn_extension'

Prawn::Document.send(:include, ShrimpKit::PrawnExtension)
