class Array
  def all
    self
  end
end

def period(i)
  OpenStruct.new(title_en: "Period #{i}",
                 title_fa: "Period_farsi #{i}",
                 end_at: "1900-01-01",
                 start_at: "1800-01-01")
end
Period = [period(1), period(2), period(3), period(4)]


require 'ostruct'
class OpenStruct
  def key(_)
    "#test"
  end
end
class NilClass 
  def key(_)
    "#test"
  end
end
