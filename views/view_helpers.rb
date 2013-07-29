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
    @object.image_count = rand(10) + 1
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

    @object.instance_eval do
      def audio_clip? ; true ; end
      def harvard_link? ; true ; end
      def translation_to_english? ; true ; end
      def transcription_of_farsi? ; true ; end
    end

    @object.translation_to_english = "Lorem ipsum oh my god it's filler text. #{" " * rand(10)}" * 250
    @object.transcription_of_farsi = "Lorem ipsum oh my god it's filler text. " * 50

    @object.harvard_urls = {
      preferred: "http://nrs.harvard.edu/urn-3:FHCL:7984115",
      secondary: [
        "http://nrs.harvard.edu/urn-3:FHCL:7984115",
        "http://nrs.harvard.edu/urn-3:FHCL:7984114",
        "http://nrs.harvard.edu/urn-3:FHCL:7984112",
        "http://nrs.harvard.edu/urn-3:FHCL:7984111",
        "http://nrs.harvard.edu/urn-3:FHCL:7984116",
        "http://nrs.harvard.edu/urn-3:FHCL:7984113"
      ]
    }

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

    @object.related_items = [
      OpenStruct.new(name: "Unidentified to Rukhsarah Khanum", url: '#'),
      OpenStruct.new(name: "First page of marriage contract of Sitarah Buhlul and Mirza Masʻud Shaykh al-Islam", url: '#'),
      OpenStruct.new(name: "Sadiqah Dawlatabadi to [Zayn al-ʻAbidin] Shafa, 20 January 1952", url: '#'),
      OpenStruct.new(name: "Nusrat al-Saltanah to A‘zam al-Saltanah, [ca. 1927-32]", url: '#'),
      OpenStruct.new(name: "Korsi cover", url: '#')
    ]
  end

  def user_platform_url? 
    true unless Environment.user_platform_url.nil?
  end

  # Widget helper to create a url to the user platform site
  def construct_user_platform_url(type, action, accession_number)
    url = "#{Environment.user_platform_url}"

    # Append a controller 
    case type
    when 'research'
      url << '/researches'
    when 'discussion'
      url << '/threads'
    when 'question'
      url << '/threads'
    else
      url << '/contributions'
    end

    # Append an new action if the action is new
    url << '/new' if action == 'new'

    # Starts to append the search parameters
    url << '?'

    # Append a type parameter if the type is not reseach
    url << "type=#{type}&" unless type == 'research'

    # Append an accession number parameter
    url << "accession_no=#{accession_number}"
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
      def translation_to_english? ; true ; end
      def transcription_of_farsi? ; true ; end
    end

    @object.translation_to_english = "Lorem ipsum oh my god it's filler text. #{" " * rand(10)}" * 250
    @object.transcription_of_farsi = "Lorem ipsum oh my god it's filler text. " * 50

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

    @object.related_items = [
      OpenStruct.new(name: "خانواده نهورايف‌، تهران، ۱۲۹۲ ش", url: '#'),
      OpenStruct.new(name: "زن های درویش در ساوجبلاغ", url: '#'),
      OpenStruct.new(name: "[صبح ازل] به صفوه الحاجیه", url: '#'),
      OpenStruct.new(name: "شمس الملوک عضدی", url: '#'),
      OpenStruct.new(name: "گل پیراهن اعتضادی و دخترش قدرت ملک", url: '#')
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

  def load_example_browse_page_object!
    @object = OpenStruct.new.tap do |o|
      o.title = 'Browse'
      o.browse_entries = 6.times.with_object([]) do |i, bes|
        bes <<  OpenStruct.new(:name => 'Genre Name ' + i.to_s)
      end

      o.period_list = [
        OpenStruct.new(slug: "pre-qajar", name: "Pre-Qajar", start_time: Time.now, end_time: Time.now),
        OpenStruct.new(slug: "aqa-muhammed-khan", name: "Aqa Muhammed Khan", start_time: Time.now, end_time: Time.now),
        OpenStruct.new(slug: "early-pahlavi", name: "Early Pahlavi", start_time: Time.now, end_time: Time.now)
      ]
      
    end

    @object.instance_eval do
      def tags_for(name)
        [ ["Tag 1", '100'], 
          ["Tag 2", '200'], 
          ["Tag 3", '400'], 
          ["Tag 4", '800'], 
          ["Tag 5", '1600'], 
          ["Tag 6", '3200'] ]
      end
    end

    @object
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
      o.history = 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? For full album viewing, see: [Full Album](http://nrs.harvard.edu/urn-3:FHCL:1125271 "Title")'
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
  
  def persian_sort(content)
    sortable = {}
    sorted = []
    content.each_with_index do |(w, c), i|
      s1 = w.downcase.strip.gsub("ʻ","‘ ").gsub(/\A’/,"1 ").gsub(/\A‘/,"2 ").gsub("آ", "3 ").gsub("ا", "4 ").gsub("ب", "5 ").gsub("پ", "6 ").gsub("ت", "7 ").gsub("ث", "8 ").gsub("ج", "9 ").gsub("چ", "a ").gsub("ح", "b ").gsub("خ", "c ").gsub("د", "d ").gsub("ذ","e ").gsub("ر", "f ").gsub("ز", "g ").gsub("ژ", "h ").gsub("س", "i ").gsub("ش", "j ").gsub("ص", "k ").gsub("ض", "l ").gsub("ط", "m ").gsub("ظ", "n ").gsub("ع", "o ").gsub("غ", "p ").gsub("ف", "q ").gsub("ق", "r ").gsub("ک", "s ").gsub("گ", "t ").gsub("ل", "u ").gsub("م", "v ").gsub("ن", "w ").gsub("و", "x ").gsub("ه", "y ").gsub("ی", "z ")
      sortable.merge!(s1 => i)
    end
    sortable.sort.each do |s|
      sorted<<content[s[1]]
    end
    sorted
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
