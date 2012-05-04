class Translation < ActiveRecord::Base                                      
  class << self
    if ENV["SKIP_DATABASE"]
      def lookup(*args) ; args.first ; end
    else
      def lookup(*args) ; find_by_key_and_locale(*args) ; end
    end
    alias_method :t, :lookup
  end
end
