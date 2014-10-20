gem 'prawn'
gem 'prawn-table'

require 'active_support/all'
require 'prawn'
require 'prawn/table'
require 'nokogiri'
require 'prawn/measurement_extensions'

module ShrimpKit
  # possible options:
  # image_path: path to images
  # image_position: html image position flags
  # image_size:
  # language: Language for hyphenation (used in justified blocks)
  def self.to_pdf_file(filename, html, options: {})
    custom_css = options[:css] || ''
    custom_css += (options[:css_files] || []).map do |css_file|
                                                    File.read(css_file)
                                                  end.join("\n")

    renderer = Renderer.new(html, custom_css: custom_css)
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
