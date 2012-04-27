#encoding: utf-8
require 'ostruct'

class String
  def name
    self
  end
end

module ViewHelpers
  def load_example_item! 
    @object = OpenStruct.new
    @object.thumbnail = "http://d19ob2c2hogwg9.cloudfront.net/thumbs/it_1527.jpg"
    @object.description =<<DESC
A satirical anthology of poetry that uses Iranian foods to make fun of
government elites, both men and women.
<br/>
This description is cut off in the interest of not having to fight with UTF-8
Encodings and serve.
DESC
    @object.instance_eval do 
      def has_creator? 
        true
      end
    end
    @object.creator = OpenStruct.new
    @object.creator.name = "Mayil Afshar Shaykh al-Shu'ara"

    @object.audio_clip = 'http://s3.amazonaws.com/wwqi-static/clips/it_1_1_clip.mp3?1329177600'
    @object.audio_clip_caption = 'Lorem Ipsum Dolor Sit Amet'

    @object.harvard_url = "http://nrs.harvard.edu/urn-3:FHCL:7984115"
    @object.secondary_urls = [
      "http://nrs.harvard.edu/urn-3:FHCL:7984115",
      "http://nrs.harvard.edu/urn-3:FHCL:7984114",
      "http://nrs.harvard.edu/urn-3:FHCL:7984112",
      "http://nrs.harvard.edu/urn-3:FHCL:7984111",
      "http://nrs.harvard.edu/urn-3:FHCL:7984116",
      "http://nrs.harvard.edu/urn-3:FHCL:7984113"
    ]

    @object.date = OpenStruct.new
    @object.date.representation = "[ca. 1873 or 1874]"

    @object.title = "Anthology of Food, #{@object.date.representation}"

    @object.notes =<<NOTES
The date of the text must be after the formation of the consultative body in
1275 AH or 1289 AH (the text refers to the chairman of the consultative
assembly) and before 1297 AH (when it was entered in the library).
<br/>
On the last page of the text is written: "This book was received from Aqa Muslim
[?] [on] 1297 AH and entered in my library in the month of Muharram 1298 AH."
<br/>
The stamp of Muhammad Sadiq Tabataba'i appears on the last page of the text.
NOTES
    @object.dimensions = "17.5cm x 22cm"
    @object.collections = [OpenStruct.new(url: "#", title: "Majlis Library, Museum and Document Center")]
    @object.repository = "Majlis Library, Museum and Document Center, Tehran, Iran (MS. 1197-T)"
    @object.restrictions = "Use of collection materials for publication purposes must cite Majlis Library, Museum and Document Center (Tehran, Iran) as current repository."
    @object.created = "14 January 2011"
    @object.created.instance_eval do
      def strftime(*_)
        self
      end
    end
    @object.updated = "14 September 2011"
    @object.updated.instance_eval do
      def strftime(*_)
        self
      end
    end

    @object.instance_eval do
      def url
        "#"
      end
    end

    @object.accession_number = "1018A10"
    @object.genres = [
      fake_facet
    ]
    @object
    @object.people = [
      fake_facet,
      fake_facet,
      fake_facet,
      fake_facet,
    ]

    @object.subjects = [
      fake_facet
    ]

    @object.places = [
      fake_facet
    ]
  end

  def fake_facet
    os = OpenStruct.new
    os.name = 'THE Facet'
    os.instance_eval do
      def name 
        "facet name" 
      end

      def url_to_facet(*args)
        '#'
      end
    end
    os
  end

  def load_example_item_farsi! 
    @object = OpenStruct.new
    @object.thumbnail = "http://d19ob2c2hogwg9.cloudfront.net/thumbs/it_1527.jpg"
    @object.description =<<DESC
    در صنعت چاپ، صفحه آرایی و طراحی گرافیک، لورم ایپسوم به متن ساختگی گفته می شود که به عنوان عنصر گرافیکی، برای پر کردن صفحه و ارایه شکل ظاهری صفحه به کار برده می شود تا از نظر گرافیکی نشانگر چگونگی نوع و اندازه فونت و لی آوت متن باشد. 
DESC
    @object.instance_eval do 
      def has_creator? 
        true
      end
    end
    @object.creator = OpenStruct.new
    @object.creator.name = "عباس میرزا نایب السلطنه"


    @object.date = OpenStruct.new
    @object.date.representation = " متن ساختگی گفته"

    @object.title = "، لورم ایپسوم به"

    @object.notes =<<NOTES
در صنعت چاپ، صفحه آرایی و طراحی گرافیک، لورم ایپسوم به متن ساختگی گفته می شود که به عنوان عنصر گرافیکی، برای پر کردن صفحه و ارایه شکل ظاهری صفحه به کار برده می شود تا از نظر گرافیکی نشانگر چگونگی نوع و اندازه فونت و لی آوت متن باشد. 
NOTES
    @object.dimensions = "۲۵ دسامبر ۱۹۲۰ تا ۱ مه ۱۹۰۶"
    @object.collections = [OpenStruct.new(url: "#", title: "Majlis Library, Museum and Document Center")]
    @object.repository = "در صنعت چاپ، صفحه"
    @object.restrictions = "در صنعت چاپ، صفحه"
    @object.created = "۲۵ دسامبر ۱۹۲۰ تا ۱ مه ۱۹۰۶"
    @object.created.instance_eval do
      def strftime(*_)
        self
      end
    end
    @object.updated =  "۲۵ دسامبر ۱۹۲۰ تا ۱ مه ۱۹۰۶"
    @object.updated.instance_eval do
      def strftime(*_)
        self
      end
    end

    @object.instance_eval do
      def url
        "#"
      end
    end

    @object.accession_number = "1018A10"
    @object.genres = [
      OpenStruct.new(name: "manuscripts & lithographs", url_to_facet: "#")
    ]
    @object.people = [
      OpenStruct.new(name: "Ziya' al-Saltanah [I]", url: "#"),
      OpenStruct.new(name: "Mayil Afshar Shaykh al-Shu'ara", url: "#"),
      OpenStruct.new(name: "Amin al-Saltanah", url: "#")
    ]

    @object.subjects = [
      OpenStruct.new(name: "food", url_to_facet: "#"),
      OpenStruct.new(name: "cooking", url_to_facet: "#"),
      OpenStruct.new(name: "courtiers", url_to_facet: "#")
    ]

    @object.places = [
      OpenStruct.new(name: "Bushihr", url: "#")
    ]
  end

  def load_example_collection_index! 
    @object = OpenStruct.new.tap do |o|
      o.title = "Named Holdings"
      o.description = "Women's Worlds in Qajar Iran includes a growing number of digital collections from private family holdings and participating archival institutions. Click on each holding to see the full details."
      o.instance_eval do
        def content(*_) 
          10.times.with_object([]) { |_, acc| acc << ViewHelpers.create_collection! }
        end
      end
    end
  end

  def load_example_collection!
    @object = create_collection!
  end

  def create_collection!
    ViewHelpers.create_collection!
  end

  def self.create_collection!
    @coll_number ||= 0
    @coll_number += 1
    OpenStruct.new.tap do |o|
      o.instance_eval do
        def in_process?
          rand(1) == 1
        end
      end
      o.title = "Collection Title #{@coll_number}"
      o.created = "1786-2010 [1201 AH - 1388 SH]"
      o.updated = "1786-2010 [1201 AH - 1388 SH]"
      o.accession_number = "1228"
      o.description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud"
      o.acquisition_notes = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
      o.restrictions = "No restrictions"
      o.genres = ["Letters", "Objects"]
      o.subjects = ["clothing and dress", "marriage"]
      o.dates = "1-January-2000"
      o.url = "#"
      o.history = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
      o.creator = "Corleone Family"
      o.favorites = []
      6.times.with_object(o.favorites) { |_, acc| acc << create_item! }
      o.count = rand(125)


      if rand(2) == 1
        o.thumbnail = "http://d19ob2c2hogwg9.cloudfront.net/collection_thumbs/collection_#{(1..28).to_a.sample}.jpg"
      end
    end
  end



  def create_item!
    ViewHelpers.create_item!
  end

  def self.create_item!
    OpenStruct.new.tap do |o|
      o.title = "an item"
      o.thumbnail = "http://d19ob2c2hogwg9.cloudfront.net/thumbs/it_#{rand(2000)+1}.jpg"
    end
  end

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

  def t(key)
    Translation.t(key, @lang)
  end
end

class Array
  def present?
    count > 0
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
