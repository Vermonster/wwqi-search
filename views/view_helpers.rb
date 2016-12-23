#encoding: utf-8
require 'ostruct'

class String
  def name
    self
  end
end

module ViewHelpers
  FARSI_NUMBERS = "۰۱۲۳۴۵۶۷۸۹"

  def with_farsi_numbers(string)
    string ||= ""
    string = string.to_s
    if @lang == :fa
      FARSI_NUMBERS.chars.each.with_index do |e, i|
        string.gsub!(i.to_s, e)
      end
    end
    string
  end
end

class Array
  def present?
    count > 0
  end

  def all
    self
  end
end

class Object
  def try(m)
    if self
      self.send(m)
    else
      nil
    end
  end
end

class NilClass
  def try(_)
    self
  end
end
