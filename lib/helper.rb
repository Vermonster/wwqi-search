#encoding: utf-8
require 'net/http'
require 'json'
require 'kramdown'

PERIOD_FILTERS = JSON.parse(Net::HTTP.get(URI("http://www.qajarwomen.org.s3.amazonaws.com/period_manifest.json")))

TRANSLATIONS = {
  'en' => JSON.parse(File.read('./locales/en.json')),
  'fa' => JSON.parse(File.read('./locales/fa.json'))
}

module Helpers
  def javascript(name)
    %Q|<script type='text/javascript' src='/javascripts/#{name}.js'></script>|
  end

  def markdown(str)
    Kramdown::Document.new(str).to_html
  end

  def facet_link(facet, term)
    term_name = if term.is_a? Hash
                  t(term['term']).to_s
                else 
                  has_current = 'current' 
                  t(term).to_s
                end

    if term_name.present?
      has_current ||= "current" if loopback.filters.any? {|type, value| type == facet && value == term['term']}
      count = with_farsi_numbers term["count"].to_i

      return_link = if has_current
                      loopback.remove_filter(facet).page(0).to_url
                    else
                      loopback.update_filter(facet, term['term']).page(0).to_url
                    end

      link_html = if has_current 
                    %Q|<a href='#{return_link}'>D</a>#{term_name}|
                  else
                    %Q|<a href='#{return_link}'>#{term_name}<span>(#{count})</span></a>|
                    end

      %Q|<li class="#{has_current}"> #{link_html}  </li>|
    else
      ""
    end
  end

  def lang_link_to(text, link, opts={})
    lang = opts.delete(:lang) 
    url = URI.join(Environment.main_site_url, "#{lang}/", "#{link}")

    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def return_link(*_)
    Loopback.new(params).to_url
  end

  def loopback(opts = nil)
    Loopback.new(opts || params)
  end

  def partial(path)
    erb("_#{path}".to_sym)
  end

  def stylesheet(name, opts = {})
    extra = opts.inject("") { |a,(key, value)| a << "#{key}=\"#{value}\" " } if opts.keys.any?
    %Q|<link rel="stylesheet" href="/stylesheets/#{name}.css" #{extra} />|
  end

  def t(key, lang = nil)
    TRANSLATIONS[(lang || @lang).to_s][key.to_s] || key
  end

  def period_filters
    PERIOD_FILTERS
  end
end
