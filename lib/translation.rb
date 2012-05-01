class Translation < ActiveRecord::Base                                      
  class << self
    def lookup(*args) ; find_by_key_and_locale(*args) ; end
    alias_method :t, :lookup
  end
end
