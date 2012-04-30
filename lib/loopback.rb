class Filter
  def initialize(str)
    @filter = parse_filters(str)
  end

  include Enumerable
  extend Forwardable
  delegate [:keys, :delete, :each, :[], :[]=] => :@filter

  def to_s
    map do |type, value|
      "#{type}:#{CGI.escape(value)}"
    end.join('|')
  end
  alias inspect to_s

  def has_filters? 
    !keys.empty? 
  end

  private
  def parse_filters(str)
    return {} if str.blank?
    str.split('|').each_with_object({}) do |pair, acc| 
      type, value = pair.split(":") 
      acc[type] = CGI::unescape(value)
    end
  end
end

class Loopback
  attr_reader :filters
  delegate :has_filters?, :to => :filters

  def initialize(params)
    params = params.with_indifferent_access
    @query = params["query"]
    @page = params["page"].to_i || 1
    @lang = params["lang"].to_sym
    @sorter = params["sort"]
    @date = params["date"]
    @filters = Filter.new(params["filter"])
  end

  def self.results_per_page
    10
  end

  def query_field
    return "" unless @query
    "&query=#{@query}" 
  end

  def sort_field 
    return "" unless @sorter
    "&sort=#{@sorter}"
  end

  def lang_field
    return "" unless @lang
    "lang=#{@lang}" 
  end

  def filter_field
    return "" unless @filters.has_filters?
    "&filter=#{@filters}" 
  end

  def page_field
    return "" if @page.nil? or @page == 0
    "&page=#{@page}" 
  end

  def date_field
    if @from and @to 
      "&date=#{@from}TO#{@to}"
    elsif @date 
      "&date=#{@date}"
    else
      "" 
    end
  end

  def to_url
    "#{ENV["SEARCH_URL"]}?" + lang_field + query_field + filter_field + page_field + date_field + sort_field
  end

  def increment_page
    @page += 1
    self
  end

  def decrement_page
    @page -= 1
    self
  end

  def to(date)
    @to = date
    self
  end

  def sort!
    @sorter = "title"
    self
  end

  def from(date)
    @from = date
    self
  end

  def prev_page?(total)
    @page + 1 > 1
  end

  def next_page?(total)
    @page + 1 < (1.0 * total / Loopback.results_per_page).ceil 
  end

  def update_filter(type, value)
    @filters[type] = CGI.escape(value)
    self
  end

  def remove_filter(type)
    @filters.delete(type)
    self
  end
end


module Helpers
  def return_link(*_)
    Loopback.new(params).to_url
  end

  def loopback(opts = nil)
    Loopback.new(opts || params)
  end
end

