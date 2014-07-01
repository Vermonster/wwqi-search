#encoding: utf-8
require 'ostruct'

class String
  def name
    self
  end
end

class NestedHash
  def initialize(hash)
    @h = HashWithIndifferentAccess.new(hash)
  end

  def process_array(array)
    array.map do |el|
      case el
      when Array then process_array(el)
      when Hash then NestedHash.new(el)
      else el
      end
    end
  end

  def method_missing(method, *args)
    if @h.has_key?(method)
      result = @h[method]
      result = NestedHash.new(result) if result.is_a?(Hash)
      result = process_array(result) if result.is_a?(Array)
      result
    end
  end
end

module ViewHelpers
  def load_example_person_farsi!
    @object = NestedHash.new(YAML.load(FA_YAML))

    def @object.local_date(m)
      send(m)
    end

    def @object.as_timeline_json(l)
      YAML.load(FA_TIMELINE_YAML)
    end
  end

  def load_example_person!
    @object = NestedHash.new(YAML.load(EN_YAML))

    def @object.local_date(m)
      send(m)
    end

    def @object.as_timeline_json(l)
      YAML.load(EN_TIMELINE_YAML)
    end
  end

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

    def fake_person
      OpenStruct.new(name: 'person name', url: '#')
    end
    @object.people = [
      fake_person,
      fake_person,
      fake_person,
      fake_person,
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
    when 'Research'
      url << '/researches'
    when 'Discussion'
      url << '/threads'
    when 'Question'
      url << '/threads'
    when 'Correction'
      url << '/corrections'
    else
      url << '/contributions'
    end

    # Append an new action if the action is new
    url << '/new' if action == 'new'

    # Starts to append the search parameters
    url << '?'

    # Append a type parameter if the type is not reseach
    url << "type=#{type}&" unless %w(Research Correction).include?(type)

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



  def load_example_person_index!
    @content = {
    "'Abd Allah Qavami" => 1,
    "ʻAbbas Khan Tunikabuni Muntazim al-Mulk" => 5,
      "ʻAbbas Mirza (Bayani Collection)" => 1,
      "ʻAbbas Mirza Mulk'ara" => 2,
      "ʻAbbas Mirza Qajar Iftikhar Nizam" => 4,
      "ʻAbbas Quli Khan Buhlul" => 1,
      "ʻAbbasah Qajar (Shazdah Valiyah)" => 1,
      "ʻAbbasquli Khan Kaziruni" => 1,
      "ʻAbbasquli Khan Sartip Samsam al-Mulk" => 1,
      "ʻAbd al-Amir Mirza" => 2,
      "ʻAbd al-Hamid Mirza (Nasir al-Dawlah)" => 1,
      "ʻAbd al-Hamid Mirza ʻAyn al-Dawlah" => 2,
      "ʻAbd al-Husayn Mirza Farmanfarma" => 22,
      "ʻAbd al-Husayn Mirza ʻAlaʼ al-Sultan (son of Bahram Mirza Muʻizz al-Dawlah)" => 4,
      "ʻAbd al-Husayn Sanʻatizadah" => 3,
      "ʻAbd al-Majid Mirza" => 1,
      "ʻAbd al-Samad Hamidani" => 1,
      "ʻAbd al-Samad Mirza (ʻIzz al-Dawlah)" => 4,
      "ʻAbd al-Vahhab ibn ʻAli Muhammad Isfahani" => 1,
      "ʻAli Riza Mirza" => 1,
      "ʻAli Ruhi" => 1,
      "ʻAlidad Mirza (son of Fatimah Baygum and Farmanfarma)" => 1,
      "ʻAlimah Azal" => 2,
      "ʻAliyah Khanum (Azardukht Qahramani Collection)" => 12,
      "ʻAliyah Khanum (daughter of Sitarah and Pasha Khan Amin al-Mulk)" => 2,
      "ʻAliyah Khanum (Nusrat Muzaffari Collection)" => 3,
      "ʻAliyah Khanum (Rastkar-Daryabandari Collection)" => 2,
      "ʻAmid al-Dawlah" => 1,
      "ʻAmid al-Dawlah (Tehran University Central Library)" => 1,
      "ʻAmid al-Mulk" => 1,
      "ʻAndalib al-Sadat" => 2,
      "ʻAndalib al-Saltanah" => 1,
      "ʻAndalib Vaʻiz" => 1,
      "ʻAyishah Khanum" => 1,
      "ʻAyn al-Mulk" => 1,
      "ʻAyn Allah Mirza Jahanbani" => 1,
      "ʻAziz al-Dawlah (daughter of Asiyah Khanum and Kiyumars Mirza)" => 2,
      "ʻAziz al-Dawlah (sister of Nasir al-Din Shah)" => 5,
      "ʻAziz al-Muluk (Bayani Collection)" => 1,
      "ʻAziz al-Saltanah" => 1,
      "ʻAziz al-Sultan" => 3,
      "ʻAziz Allah Khan" => 2,
      "ʻAziz Jan" => 4,
      "ʻAziz Khanum (Muʼayyid al-Muluk)" => 6,
      "ʻAzizah" => 4,
      "ʻAzra Asʻadi" => 1,
      "ʻIffat (Daughter of Fath ʻAli Shah)" => 1,
      "ʻIffat al-Muluk Khvajah-nuri" => 3,
      "ʻIffat Qajariyah" => 1,
      "Afsanah Khanum" => 4,
      "Afsanah Najmabadi" => 2,
      "Afsaneh Ashrafi" => 4,
      "Afsar al-Dawlah" => 1,
      "Afsar al-Muluk (daughter of Huma Khanum and ‘Abbas Mirza Iftikhar Nizam)" => 4,
      "Afsar al-Muluk Shaykh al-Islami" => 5,
      "Afzal Mohtadi" => 5,
      "Agha Baji" => 2,
      "Agha Baygum" => 1,
      "Agha Baygum (daughter of Ja‘far Quli Khan Navayi)" => 1,
      "Agha Baygum Sultan al-Hajiyah" => 1,
      "Agha Kuchak" => 1,
      "Aghali Khanum Sharafat al-Dawlah" => 1,
      "Ahamad Khan Navaʼi (Moezzi Collection)" => 1,
      "Ahmad Ashrafi" => 9,
      "Ahmad Bahaj" => 1,
      "Ahmad Khan Mushir al-Dawlah (son of Sharafat al-Saltanah)" => 1,
      "Ahmad Khan Mushir Huzur (spouse of Furuzandah)" => 1,
      "Ahmad Khan Mustawf" => 1,
      "Ahmad Khan Muʼayyad al-Mulk (III)" => 14,
      "Ahmad Khan Zahir" => 1,
      "Ahmad Khan ʻAlaʼ al-Dawlah (father of Turan)" => 1,
      "Ahmad Mutiʻ al-Saltanah (Bayani Collection)" => 1,
      "Ahmad Riza Qavami" => 1,
      "Ahmad Shah Qajar" => 17,
      "Ahmad Sharifi" => 1,
      "Ahmad Tabatabaʼi Qumi" => 1,
      "Ajudan Bashi" => 1,
      "Akbar Mirza (son of Nayyir al-Saltanah and Malik Mansur Mirza)" => 2,
      "Akbar Mirza Rukni" => 2,
      "Aqa Muhammad Mahdi" => 1,
      "Aqa Muhammad Mir al-Dawlah" => 1,
      "Aqa Muhammad ʻAli (Rukni Collection)" => 1,
      "Aqa Nasir Imam Jum‘ah" => 1,
      "Aqa Sayyid Hasan Sabbagh" => 1,
      "Aqa Sayyid Hashim (Rouhi Collection)" => 1,
      "Aqa Sayyid Muhammad Baqir" => 1,
      "Aqa Shaykh Riza" => 2,
      "Aqa Vajih" => 1,
      "Aqa Zadah Khanum (daughter of Mirza Musa Siqqat al-Islam)" => 1,
      "Aqa ʻAli" => 1,
      "Aqdas (Bayani Collection)" => 1,
      "Aqdas al-Dawlah (daughter of Muzaffar al-Din Shah)" => 8,
      "Aqdas al-Saltanah" => 5,
      "Aqdas Khanum (Saʻid al-Sultan Collection)" => 1,
      "Arbab Jamshid Zartushti" => 3,
      "Arfa‘ al-Dawlah" => 1,
      "Mirza Ismaʻil Khan Shaykh al-Islam (Sayf al-Islam)" => 1,
      "Mirza Ismaʻil Mustawfi" => 1,
      "Mirza Isma‘il Rubat Karimi" => 1,
      "Mirza Isma‘il Tafrishi" => 2,
      "Mirza Isma‘il Zarandi" => 1,
      "Munshi Bashi" => 14,
      "Muntazir al-Dawlah (daughter of Mah Parah)" => 1,
      "Murtiza Quli Khan" => 1,
      "Murvarid Khanum" => 1,
      "Murvarid Yahud" => 1,
      "Musa (son of ʻAli Ahmad Kur)" => 2,
      "Musa Ashrafi" => 8,
      "Musa Khan Ashraf al-Mulk (son of ‘Abbas Quli Khan Ashrafi)" => 14,
      "Musaddiq al-Dawlah" => 1,
      "Mushir al-Dawlah" => 2,
      "Mushir al-Saltanah" => 2,
      "Musri Baygum Khanum [Sakinah?] (sister of Sayyid Abu al-Fazl Khatib)" => 1,
      "Mustafa Hamidi" => 1,
      "Rafiʻ al-Dawlah (spouse of Nur al-Huda)" => 1,
      "Rafʻat al-Mamalik" => 1,
      "Taqi al-Din Azal" => 1,
      "Taqi Hamidpur" => 1,
      "Ziya’ Allah Abqi" => 1,
      "Zubaydah (daughter of Mahmud Mirza)" => 1,
      "Zubaydah (Jahan) Khanum" => 3,
      "Zukaʼ al-Dawlah" => 1,
      "Zuka’ al-Mulk" => 1
    }.entries
  end

   def load_example_person_index_farsi!
    text = <<-TEXT.strip_heredoc
آجودان باشی => 1
آذر (مجموعه بیانی) => 1
آذر شیخ الاسلامی => 2
آذر قوام => 1
آذر کاووسی => 1
آذرمی دخت => 3
آرتین استپانیان => 12
آرمن استپانیان => 4
آروسیاک => 1
آروسیاک سروریان (پطروسیان) => 7
آساطور خان امیرخانیان => 1
آسیه (احترام الشریعه) => 3
آسیه خانم => 2
آسیه خانم (مادر عباس میرزا نایب السلطنه) => 1
آسیه خانم (مادر فتحعلی‌ شاه) => 1
آسیه خانم (مجموعه بیانی) => 1
آسیه خانم (مجموعه شیخ الاسلامی) => 13
آصف السلطنه => 2
آغا باجی => 2
آغا بیگم => 1
آغا بیگم (دختر جعفرقلی خان نوایی) => 1
آغا بیگم سلطان الحاجیه => 1
آغا کوچک => 1
آغالی خانم شرافت الدوله => 1
آفاق الدوله => 1
آقا ابراهیم خان => 1
آقا احمد => 1
آقا اسمعیل خان امیر پنجه => 2
آقا بالا خان سردار => 1
آقا جمال خوانساری => 1
آقا خان (پسر بی بی شمس الملوک) => 1
آقا زاده خانم (دختر میرزا موسی ثقة الاسلام) => 1
آقا سید حسین صباغ => 1
آقا سید محمد باقر => 1
آقا سید هاشم (مجموعه روحى) => 1
آقا شفا => 1
آقا شیخ رضا => 2
آقا علی => 1
آقا کوچک خانم => 1
آقا محمد خان قاجار => 2
آقا محمد مهدی => 1
آقا محمد میر الدوله => 1
آقا محمدحسن => 2
آقا محمدعلی (مجموعه رکنی) => 1
آقا میرزا ابو القاسم یزدی => 11
TEXT
    @content = text.split("\n").map{|l| l.split(" => ") }
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

FA_YAML = <<-YAML
---
:sex: female
:thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
:name: نینیش امیرخانیان (استپانیان)
:description: نینیش امیرخانیان (استپانیان)، متولد سال ۱۲۶۲ در تهران و همسرش آرتین
  استپانیان صاحب شش فرزند بودند.
:long_description: ! 'نینیش امیرخانیان (استپانیان) در یک خانواده ارمنی پیشرو در تهران
  به دنیا آمد. او تحصیلات عالی خود را در زمینه رشته جامعه شناسی دردانشگاه سوربن در
  شهر پاریس به اتمام رساند و پس از بازگشت به ایران به خاطر تسلط به زبان فرانسه جهت
  تدریس به شاهزاده خانم های قاجار به حرمسرا راه یافت و به بسیاری از آنان درس فرانسه
  داد از جمله این شاهزاده خانم ها که رابطه نزدیکی با نی نیش داشتند می توان به تاج
  السلطنه و فروغ الدوله اشاره کرد. همچنین محمدعلی میرزا(که سپس شاه ایران شد) نی نیش
  را از پدرش سرپ خان خواستگاری کرد. اما سرانجام نینیش با آرتین استپانیان، اولین دندانپزشک
  رسمی ایران ازدواج کرد. '
:birthplace:
  :name: تهران
  :url: ! '#'
:dob_exact: '1884'
:dod_exact: '1953'
:published_collections:
- :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/collection_thumbs/collection_56.jpg?1362438745
  :title: آواکیان
:sources:
:people_relationships:
- :relationship:
    :title: دختر
  :related_person:
    :name: آنیک استپانیان (آواکیان)
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2063.jpg?1361910312
- :relationship:
    :title: شوهر
  :related_person:
    :name: آرتین استپانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2062.jpg?1361907866
- :relationship:
    :title: دختر
  :related_person:
    :name: شاکه استپانیان (آبدالیان)
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2064.jpg?1361913132
- :relationship:
    :title: پسر
  :related_person:
    :name: آرمن استپانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2065.jpg?1361913509
- :relationship:
    :title: پسر
  :related_person:
    :name: سامسون استپانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2066.jpg?1361913892
- :relationship:
    :title: پسر
  :related_person:
    :name: هوفسب استپانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2067.jpg?1361914610
- :relationship:
    :title: پسر
  :related_person:
    :name: رستم استپانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2068.jpg?1361914951
- :relationship:
    :title: پدر
  :related_person:
    :name: سرپ خان امیرخانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2069.jpg?1361916233
- :relationship:
    :title: مادر
  :related_person:
    :name: ایزابل سروریان (امیرخانیان)
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2070.jpg?1361916648
- :relationship:
    :title: خواهر
  :related_person:
    :name: هراچ امیرخانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2071.jpg?1361917824
- :relationship:
    :title: خواهر
  :related_person:
    :name: رز امیرخانیان
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2073.jpg?1361918671
- :relationship:
    :title: عمو
  :related_person:
    :name: آساطور خان امیرخانیان
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2122.jpg?1362421128
- :relationship:
    :title: نوه
  :related_person:
    :name: هووانس آواکیان
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2129.jpg?1362423941
- :relationship:
    :title: خواهر زن، خواهر شوهر
  :related_person:
    :name: ربکا استپانیان
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2139.jpg?1362428843
:published_items:
- :url: ! '#'
  :title: گروهی از اعضای انجمن خیریه بانوان ارامنه
  :local_date: 1377 یا 1378 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3985.jpg?1363017667
- :url: ! '#'
  :title: شاکه استپانیان (آبدالیان)
  :local_date: 1352 یا 1353 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3987.jpg?1363018276
- :url: ! '#'
  :title: فرزندان نینیش امیرخانیان (استپانیان)
  :local_date: 1343 یا 1344 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3989.jpg?1363018946
- :url: ! '#'
  :title: هراچ امیرخانیان در بین همکلاسیها و معلمان
  :local_date: حدود 1322 یا 1323 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3991.jpg?1363019708
- :url: ! '#'
  :title: رز امیرخانیان در بین همکلاسیها و معلمان
  :local_date: حدود 1320 یا 1321 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3992.jpg?1363020139
- :url: ! '#'
  :title: هوفسب، آرمن و سامسون
  :local_date: 1337 یا 1338 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3993.jpg?1363020405
- :url: ! '#'
  :title: آنیک استپانیان در لباس عروسی
  :local_date: 1358 یا 1359 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3994.jpg?1363020727
- :url: ! '#'
  :title: هووانس خان ماسِیان
  :local_date: حدود 1317 یا 1318 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3995.jpg?1363021178
- :url: ! '#'
  :title: ! 'خواهران و فرزندان نینیش امیرخانیان (استپانیان) '
  :local_date: حدود 1338 یا 1339 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3996.jpg?1363021513
- :url: ! '#'
  :title: فرزندان نینیش امیرخانیان (استپانیان)
  :local_date: 1331 یا 1332 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3997.jpg?1363021793
- :url: ! '#'
  :title: کارت ویزیت آنیک استپانیان
  :local_date:
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3999.jpg?1363022881
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) وآرتین استپانیان
  :local_date: 1327 یا 1328 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4000.jpg?1363023258
- :url: ! '#'
  :title: ! ' عکس گروهی'
  :local_date: حدود 1335 یا 1336 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3998.jpg?1363022127
- :url: ! '#'
  :title: هراچ  و رز امیرخانیان
  :local_date: 1317 یا 1318 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4003.jpg?1363024203
- :url: ! '#'
  :title: ! ' خواهر و دو دختر نینیش استپانیان (امیرخانیان)'
  :local_date: حدود 1346 یا 1347 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4007.jpg?1363026055
- :url: ! '#'
  :title: عکس گروهی
  :local_date: حدود 1317 یا 1318 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4008.jpg?1363026349
- :url: ! '#'
  :title: هراچ امیرخانیان
  :local_date: 1322 یا 1323 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4009.jpg?1363026627
- :url: ! '#'
  :title: هراچ امیرخانیان و رز امیرخانیان در عکس گروهی
  :local_date: 1366 یا 1367 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4011.jpg?1363027322
- :url: ! '#'
  :title: هراچ امیرخانیان و رز امیرخانیان در سفر هندوستان
  :local_date: 1368 یا 1369 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4012.jpg?1363030575
- :url: ! '#'
  :title: هراچ امیرخانیان و رز امیرخانیان در سفر هندوستان
  :local_date: 1368 یا 1369 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4013.jpg?1363030800
- :url: ! '#'
  :title: هراچ امیرخانیان و رز امیرخانیان در سفر هندوستان
  :local_date: 1370 یا 1371 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4014.jpg?1363031161
- :url: ! '#'
  :title: هراچ امیرخانیان
  :local_date: حدود 1333 یا 1334 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4015.jpg?1363031543
- :url: ! '#'
  :title: شاکه استپانیان (آبدالیان)
  :local_date: 1357 یا 1358 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4016.jpg?1363031792
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1394 یا 1395 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4018.jpg?1363032298
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1381 یا 1382 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4019.jpg?1363032551
- :url: ! '#'
  :title: عکس گروهی
  :local_date: حدود 1384 یا 1385 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4020.jpg?1363033311
- :url: ! '#'
  :title: عکس گروهی
  :local_date:
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4021.jpg?1363033819
- :url: ! '#'
  :title: آنیک استپانیان
  :local_date: 1420 یا 1421 ق تا 1421 یا 1422 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4022.jpg?1363034096
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1342 یا 1343 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4023.jpg?1363034367
- :url: ! '#'
  :title: هراچ امیرخانیان
  :local_date: 1323 یا 1324 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4004.jpg?1363024840
- :url: ! '#'
  :title: ! 'رز امیرخانیان '
  :local_date: 1323 یا 1324 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4005.jpg?1363025138
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1368 یا 1369 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4006.jpg?1363025766
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1350 یا 1351 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4026.jpg?1363035188
- :url: ! '#'
  :title: فروغالدوله و دخترانش٬ فروغالملوک و ملکالملوک
  :local_date: 20 صفر 1328 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3984.jpg?1363016796
- :url: ! '#'
  :title: شاکه استپانیان (آبدالیان)
  :local_date: 1348 یا 1349 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3986.jpg?1363018012
- :url: ! '#'
  :title: هراچ  و رز امیرخانیان
  :local_date: 1366 یا 1367 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4010.jpg?1363026939
- :url: ! '#'
  :title: سرپ خان امیرخانیان و ایزابل امیرخانیان (سروریان)
  :local_date: 1299 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4017.jpg?1363032059
- :url: ! '#'
  :title: آرتین استپانیان
  :local_date: 1320 یا 1321 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4002.jpg?1363023906
- :url: ! '#'
  :title: آنیک استپانیان
  :local_date: 1357 یا 1358 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4024.jpg?1363034658
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1350 یا 1351 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4025.jpg?1363034957
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان)
  :local_date: حدود 1333 یا 1334 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4001.jpg?1363023568
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) درجمع دوستان
  :local_date: حدود 1338 یا 1339 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3990.jpg?1363019333
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1350 یا 1351 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4027.jpg?1363035577
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1363 یا 1364 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4058.jpg?1364222987
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) در میان اقوام
  :local_date: 1358 یا 1359 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4059.jpg?1364223248
- :url: ! '#'
  :title: آنیک و آرتین استپانیان
  :local_date:
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4060.jpg?1364223577
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) و آرتین استپانیان
  :local_date: حدود 1343 یا 1344 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4061.jpg?1364224519
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) و آرتین استپانیان
  :local_date: 1373 یا 1374 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4062.jpg?1364225268
- :url: ! '#'
  :title: ! 'آنیک و شاکه استپانیان در کنار دوستانشان '
  :local_date: 1354 یا 1355 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4063.jpg?1364225511
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان)، آرتین، ربکا، و آنیک استپانیان
  :local_date: 1358 یا 1359 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4064.jpg?1364226067
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان)، هراچ امیرخانیان، شاکه استپانیان
  :local_date: 1355 یا 1356 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4065.jpg?1364226425
- :url: ! '#'
  :title: ! 'نینیش امیرخانیان (استپانیان) واقوام '
  :local_date: 1352 یا 1353 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4066.jpg?1364226701
- :url: ! '#'
  :title: خانواده نینیش امیرخانیان (استپانیان) در حیاط منزلشان
  :local_date: 1358 یا 1359 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4067.jpg?1364227315
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) در کنار خانواده و دوستان
  :local_date: 1353 یا 1354 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4068.jpg?1364227599
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) در کنار خانواده
  :local_date: 1382 یا 1383 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4069.jpg?1364227932
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) در کنار خانواده
  :local_date: حدود 1358 یا 1359 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4070.jpg?1364228165
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) در کنار خانواده
  :local_date: حدود 1377 یا 1378 ق تا 1379 یا 1380 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4071.jpg?1364228513
- :url: ! '#'
  :title: احتمالا ملکم خان همراه همسر و فرزندش
  :local_date:
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4056.jpg?1364222204
- :url: ! '#'
  :title: عکس گروهی
  :local_date: 1372 یا 1373 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4057.jpg?1364222567
- :url: ! '#'
  :title: آرتین استپانیان، آنیک، و شاکه استپانیان
  :local_date:
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4028.jpg?1363036224
- :url: ! '#'
  :title: نینیش امیرخانیان (استپانیان) درمیانسالی
  :local_date: 1358 یا 1359 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4029.jpg?1363036761
- :url: ! '#'
  :title: فرزندان نینیش امیرخانیان (استپانیان)
  :local_date: 1343 یا 1344 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4030.jpg?1363037119
- :url: ! '#'
  :title: ! 'خانواده آساطور خان امیرخانیان  '
  :local_date: 1338 یا 1339 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4031.jpg?1363038171
- :url: ! '#'
  :title: کارت پستال
  :local_date: 1351 یا 1352 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4032.jpg?1363038839
- :url: ! '#'
  :title: کارت پستال
  :local_date: 1351 یا 1352 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4033.jpg?1363039137
- :url: ! '#'
  :title: شاکه استپانیان (آبدالیان)
  :local_date: 1356 یا 1357 ق
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3988.jpg?1363018545
YAML

FA_TIMELINE_YAML = <<-YAML
---
timeline:
  type: default
  date:
  - startDate: '1301'
    headline: birth-timeline-message
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
    text: تهران رد ، <a href='/fa/people/2070.html'>ایزابل سروریان (امیرخانیان)</a>
      و <a href='/fa/people/2069.html'>سرپ خان امیرخانیان</a> رسپ
  - startDate: '1372'
    headline: death-timeline-message
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
  - startDate: '1330'
    headline: daughter-timeline-message
    text: <a href='/fa/people/2063.html'>آنیک استپانیان (آواکیان)</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2063.jpg?1361910312
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2063.jpg?1361910312
  - startDate: '1332'
    headline: daughter-timeline-message
    text: <a href='/fa/people/2064.html'>شاکه استپانیان (آبدالیان)</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2064.jpg?1361913132
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2064.jpg?1361913132
  - startDate: '1334'
    headline: son-timeline-message
    text: <a href='/fa/people/2065.html'>آرمن استپانیان</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2065.jpg?1361913509
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2065.jpg?1361913509
  - startDate: '1336'
    headline: son-timeline-message
    text: <a href='/fa/people/2066.html'>سامسون استپانیان</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2066.jpg?1361913892
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2066.jpg?1361913892
  - startDate: '1327'
    headline: son-timeline-message
    text: <a href='/fa/people/2067.html'>هوفسب استپانیان</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2067.jpg?1361914610
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2067.jpg?1361914610
  - startDate: '1338'
    headline: son-timeline-message
    text: <a href='/fa/people/2068.html'>رستم استپانیان</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2068.jpg?1361914951
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2068.jpg?1361914951
  - startDate: '1377'
    headline: گروهی از اعضای انجمن خیریه بانوان ارامنه
    text: <a href='/fa/items/1260A2.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3985.jpg?1363017667
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3985.jpg?1363017667
  - startDate: '1352'
    headline: شاکه استپانیان (آبدالیان)
    text: <a href='/fa/items/1260A4.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3987.jpg?1363018276
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3987.jpg?1363018276
  - startDate: '1343'
    headline: فرزندان نینیش امیرخانیان (استپانیان)
    text: <a href='/fa/items/1260A6.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3989.jpg?1363018946
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3989.jpg?1363018946
  - startDate: '1322'
    headline: هراچ امیرخانیان در بین همکلاسیها و معلمان
    text: <a href='/fa/items/1260A8.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3991.jpg?1363019708
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3991.jpg?1363019708
  - startDate: '1320'
    headline: رز امیرخانیان در بین همکلاسیها و معلمان
    text: <a href='/fa/items/1260A9.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3992.jpg?1363020139
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3992.jpg?1363020139
  - startDate: '1337'
    headline: هوفسب، آرمن و سامسون
    text: <a href='/fa/items/1260A10.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3993.jpg?1363020405
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3993.jpg?1363020405
  - startDate: '1358'
    headline: آنیک استپانیان در لباس عروسی
    text: <a href='/fa/items/1260A11.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3994.jpg?1363020727
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3994.jpg?1363020727
  - startDate: '1317'
    headline: هووانس خان ماسِیان
    text: <a href='/fa/items/1260A12.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3995.jpg?1363021178
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3995.jpg?1363021178
  - startDate: '1338'
    headline: ! 'خواهران و فرزندان نینیش امیرخانیان (استپانیان) '
    text: <a href='/fa/items/1260A13.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3996.jpg?1363021513
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3996.jpg?1363021513
  - startDate: '1331'
    headline: فرزندان نینیش امیرخانیان (استپانیان)
    text: <a href='/fa/items/1260A14.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3997.jpg?1363021793
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3997.jpg?1363021793
  - startDate: '1327'
    headline: نینیش امیرخانیان (استپانیان) وآرتین استپانیان
    text: <a href='/fa/items/1260A17.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4000.jpg?1363023258
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4000.jpg?1363023258
  - startDate: '1335'
    headline: ! ' عکس گروهی'
    text: <a href='/fa/items/1260A15.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3998.jpg?1363022127
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3998.jpg?1363022127
  - startDate: '1317'
    headline: هراچ  و رز امیرخانیان
    text: <a href='/fa/items/1260A20.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4003.jpg?1363024203
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4003.jpg?1363024203
  - startDate: '1346'
    headline: ! ' خواهر و دو دختر نینیش استپانیان (امیرخانیان)'
    text: <a href='/fa/items/1260A24.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4007.jpg?1363026055
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4007.jpg?1363026055
  - startDate: '1317'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A25.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4008.jpg?1363026349
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4008.jpg?1363026349
  - startDate: '1322'
    headline: هراچ امیرخانیان
    text: <a href='/fa/items/1260A26.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4009.jpg?1363026627
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4009.jpg?1363026627
  - startDate: '1366'
    headline: هراچ امیرخانیان و رز امیرخانیان در عکس گروهی
    text: <a href='/fa/items/1260A28.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4011.jpg?1363027322
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4011.jpg?1363027322
  - startDate: '1368'
    headline: هراچ امیرخانیان و رز امیرخانیان در سفر هندوستان
    text: <a href='/fa/items/1260A29.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4012.jpg?1363030575
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4012.jpg?1363030575
  - startDate: '1368'
    headline: هراچ امیرخانیان و رز امیرخانیان در سفر هندوستان
    text: <a href='/fa/items/1260A30.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4013.jpg?1363030800
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4013.jpg?1363030800
  - startDate: '1370'
    headline: هراچ امیرخانیان و رز امیرخانیان در سفر هندوستان
    text: <a href='/fa/items/1260A31.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4014.jpg?1363031161
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4014.jpg?1363031161
  - startDate: '1333'
    headline: هراچ امیرخانیان
    text: <a href='/fa/items/1260A32.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4015.jpg?1363031543
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4015.jpg?1363031543
  - startDate: '1357'
    headline: شاکه استپانیان (آبدالیان)
    text: <a href='/fa/items/1260A33.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4016.jpg?1363031792
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4016.jpg?1363031792
  - startDate: '1394'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A35.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4018.jpg?1363032298
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4018.jpg?1363032298
  - startDate: '1381'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A36.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4019.jpg?1363032551
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4019.jpg?1363032551
  - startDate: '1384'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A37.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4020.jpg?1363033311
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4020.jpg?1363033311
  - startDate: '1420'
    headline: آنیک استپانیان
    text: <a href='/fa/items/1260A39.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4022.jpg?1363034096
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4022.jpg?1363034096
  - startDate: '1342'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A40.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4023.jpg?1363034367
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4023.jpg?1363034367
  - startDate: '1323'
    headline: هراچ امیرخانیان
    text: <a href='/fa/items/1260A21.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4004.jpg?1363024840
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4004.jpg?1363024840
  - startDate: '1323'
    headline: ! 'رز امیرخانیان '
    text: <a href='/fa/items/1260A22.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4005.jpg?1363025138
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4005.jpg?1363025138
  - startDate: '1368'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A23.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4006.jpg?1363025766
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4006.jpg?1363025766
  - startDate: '1350'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A43.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4026.jpg?1363035188
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4026.jpg?1363035188
  - startDate: '1328'
    headline: فروغالدوله و دخترانش٬ فروغالملوک و ملکالملوک
    text: <a href='/fa/items/1260A1.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3984.jpg?1363016796
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3984.jpg?1363016796
  - startDate: '1348'
    headline: شاکه استپانیان (آبدالیان)
    text: <a href='/fa/items/1260A3.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3986.jpg?1363018012
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3986.jpg?1363018012
  - startDate: '1366'
    headline: هراچ  و رز امیرخانیان
    text: <a href='/fa/items/1260A27.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4010.jpg?1363026939
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4010.jpg?1363026939
  - startDate: '1299'
    headline: سرپ خان امیرخانیان و ایزابل امیرخانیان (سروریان)
    text: <a href='/fa/items/1260A34.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4017.jpg?1363032059
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4017.jpg?1363032059
  - startDate: '1320'
    headline: آرتین استپانیان
    text: <a href='/fa/items/1260A19.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4002.jpg?1363023906
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4002.jpg?1363023906
  - startDate: '1357'
    headline: آنیک استپانیان
    text: <a href='/fa/items/1260A41.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4024.jpg?1363034658
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4024.jpg?1363034658
  - startDate: '1350'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A42.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4025.jpg?1363034957
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4025.jpg?1363034957
  - startDate: '1333'
    headline: نینیش امیرخانیان (استپانیان)
    text: <a href='/fa/items/1260A18.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4001.jpg?1363023568
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4001.jpg?1363023568
  - startDate: '1338'
    headline: نینیش امیرخانیان (استپانیان) درجمع دوستان
    text: <a href='/fa/items/1260A7.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3990.jpg?1363019333
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3990.jpg?1363019333
  - startDate: '1350'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A44.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4027.jpg?1363035577
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4027.jpg?1363035577
  - startDate: '1363'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A53.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4058.jpg?1364222987
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4058.jpg?1364222987
  - startDate: '1358'
    headline: نینیش امیرخانیان (استپانیان) در میان اقوام
    text: <a href='/fa/items/1260A54.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4059.jpg?1364223248
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4059.jpg?1364223248
  - startDate: '1343'
    headline: نینیش امیرخانیان (استپانیان) و آرتین استپانیان
    text: <a href='/fa/items/1260A56.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4061.jpg?1364224519
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4061.jpg?1364224519
  - startDate: '1373'
    headline: نینیش امیرخانیان (استپانیان) و آرتین استپانیان
    text: <a href='/fa/items/1260A57.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4062.jpg?1364225268
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4062.jpg?1364225268
  - startDate: '1354'
    headline: ! 'آنیک و شاکه استپانیان در کنار دوستانشان '
    text: <a href='/fa/items/1260A58.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4063.jpg?1364225511
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4063.jpg?1364225511
  - startDate: '1358'
    headline: نینیش امیرخانیان (استپانیان)، آرتین، ربکا، و آنیک استپانیان
    text: <a href='/fa/items/1260A59.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4064.jpg?1364226067
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4064.jpg?1364226067
  - startDate: '1355'
    headline: نینیش امیرخانیان (استپانیان)، هراچ امیرخانیان، شاکه استپانیان
    text: <a href='/fa/items/1260A60.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4065.jpg?1364226425
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4065.jpg?1364226425
  - startDate: '1352'
    headline: ! 'نینیش امیرخانیان (استپانیان) واقوام '
    text: <a href='/fa/items/1260A61.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4066.jpg?1364226701
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4066.jpg?1364226701
  - startDate: '1358'
    headline: خانواده نینیش امیرخانیان (استپانیان) در حیاط منزلشان
    text: <a href='/fa/items/1260A62.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4067.jpg?1364227315
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4067.jpg?1364227315
  - startDate: '1353'
    headline: نینیش امیرخانیان (استپانیان) در کنار خانواده و دوستان
    text: <a href='/fa/items/1260A63.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4068.jpg?1364227599
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4068.jpg?1364227599
  - startDate: '1382'
    headline: نینیش امیرخانیان (استپانیان) در کنار خانواده
    text: <a href='/fa/items/1260A64.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4069.jpg?1364227932
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4069.jpg?1364227932
  - startDate: '1358'
    headline: نینیش امیرخانیان (استپانیان) در کنار خانواده
    text: <a href='/fa/items/1260A65.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4070.jpg?1364228165
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4070.jpg?1364228165
  - startDate: '1377'
    headline: نینیش امیرخانیان (استپانیان) در کنار خانواده
    text: <a href='/fa/items/1260A66.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4071.jpg?1364228513
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4071.jpg?1364228513
  - startDate: '1372'
    headline: عکس گروهی
    text: <a href='/fa/items/1260A52.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4057.jpg?1364222567
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4057.jpg?1364222567
  - startDate: '1358'
    headline: نینیش امیرخانیان (استپانیان) درمیانسالی
    text: <a href='/fa/items/1260A46.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4029.jpg?1363036761
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4029.jpg?1363036761
  - startDate: '1343'
    headline: فرزندان نینیش امیرخانیان (استپانیان)
    text: <a href='/fa/items/1260A47.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4030.jpg?1363037119
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4030.jpg?1363037119
  - startDate: '1338'
    headline: ! 'خانواده آساطور خان امیرخانیان  '
    text: <a href='/fa/items/1260A48.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4031.jpg?1363038171
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4031.jpg?1363038171
  - startDate: '1351'
    headline: کارت پستال
    text: <a href='/fa/items/1260A49.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4032.jpg?1363038839
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4032.jpg?1363038839
  - startDate: '1351'
    headline: کارت پستال
    text: <a href='/fa/items/1260A50.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4033.jpg?1363039137
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4033.jpg?1363039137
  - startDate: '1356'
    headline: شاکه استپانیان (آبدالیان)
    text: <a href='/fa/items/1260A5.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3988.jpg?1363018545
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3988.jpg?1363018545
YAML

EN_YAML = <<-YAML
---
:sex: female
:thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
:name: Ninish Amirkhaniyan (Istipaniyan)
:description: Ninish Amirkhaniyan (Istipaniyan), born in 1884 in Tehran, and her husband
  Artin Istipaniyan had six children together.
:long_description: Ninish Amirkhaniyan (Istipaniyan) was born in a progressive Armenian
  family in Tehran. She studied Sociology at Sorbonne University in Paris and taught
  French to Qajar Princesses such as Furugh al-Muluk and Malik al-Muluk when she came
  back to Iran. Muhammad Ali Mirza, who later became shah of Iran, asked her father
  for her hand in marriage. But she finally married Artin Istipaniyan, who is the
  first academically educated dentist in Iran according to the family. Ninish's children
  all perfected in their majors due to her emphasis on higher education.
:birthplace:
  :name: Tehran
  :url: ! '#'
:dob_exact: '1884'
:dod_exact: '1953'
:published_collections:
- :title: Avakiyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/collection_thumbs/collection_56.jpg?1362438745
:sources:
:people_relationships:
- :relationship:
    :title: daughter
  :related_person:
    :name: Anik Istipaniyan (Avakiyan)
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2063.jpg?1361910312
- :relationship:
    :title: husband
  :related_person:
    :name: Artin Istipaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2062.jpg?1361907866
- :relationship:
    :title: daughter
  :related_person:
    :name: Shaki Istipaniyan (Abdaliyan)
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2064.jpg?1361913132
- :relationship:
    :title: son
  :related_person:
    :name: Armin Istipaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2065.jpg?1361913509
- :relationship:
    :title: son
  :related_person:
    :name: Samsun Istipaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2066.jpg?1361913892
- :relationship:
    :title: son
  :related_person:
    :name: Hufisb Istipaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2067.jpg?1361914610
- :relationship:
    :title: son
  :related_person:
    :name: Rustam Istipaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2068.jpg?1361914951
- :relationship:
    :title: father
  :related_person:
    :name: Sirp Khan Amirkhaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2069.jpg?1361916233
- :relationship:
    :title: mother
  :related_person:
    :name: Isabil Sururiyan (Amirkhaniyan)
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2070.jpg?1361916648
- :relationship:
    :title: sister
  :related_person:
    :name: Hirach Amirkhaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2071.jpg?1361917824
- :relationship:
    :title: sister
  :related_person:
    :name: Rose Amirkhaniyan
    :url: ! '#'
    :published_items:
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2073.jpg?1361918671
- :relationship:
    :title: uncle (paternal)
  :related_person:
    :name: Asatur Khan Amirkhaniyan
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2122.jpg?1362421128
- :relationship:
    :title: grandchild
  :related_person:
    :name: Huvans Avakiyan
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2129.jpg?1362423941
- :relationship:
    :title: sister-in-law
  :related_person:
    :name: Rebecca Istipaniyan
    :url: ! '#'
    :published_items:
    - 0
    :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2139.jpg?1362428843
:published_items:
- :title: Armenian Women's Charity Society
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3985.jpg?1363017667
  :local_date: '1958'
- :title: Shaki Istipaniyan (Abdaliyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3987.jpg?1363018276
  :local_date: '1934'
- :title: Ninish Amirkhaniyan (Istipaniyan)'s children
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3989.jpg?1363018946
  :local_date: '1925'
- :title: Harach Amirkhaniyan with a group of friends and teachers
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3991.jpg?1363019708
  :local_date: circa. 1905
- :title: Rose Amirkhaniyan among a group of friends and teachers
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3992.jpg?1363020139
  :local_date: circa. 1903
- :title: Hufisb, Armin and Samsun
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3993.jpg?1363020405
  :local_date: '1919'
- :title: Anik Istipaniyan in her wedding dress
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3994.jpg?1363020727
  :local_date: '1940'
- :title: Huvans Khan Masiyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3995.jpg?1363021178
  :local_date: circa. 1900
- :title: Sisters and children of Ninish Amirkhaniyan (Istipaniyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3996.jpg?1363021513
  :local_date: circa. 1920
- :title: Children of Ninish Amirkhaniyan (Istipaniyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3997.jpg?1363021793
  :local_date: '1913'
- :title: Anik Istipaniyan's business card
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3999.jpg?1363022881
  :local_date:
- :title: Ninish Amirkhaniyan (Istipaniyan) and Artin Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4000.jpg?1363023258
  :local_date: '1910'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3998.jpg?1363022127
  :local_date: circa. 1917
- :title: Hirach and Rose Amirkhaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4003.jpg?1363024203
  :local_date: '1900'
- :title: Sister and daughters of Ninish Amirkhaniyan (Istipaniyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4007.jpg?1363026055
  :local_date: circa. 1928
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4008.jpg?1363026349
  :local_date: circa. 1900
- :title: Hirach Amirkhaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4009.jpg?1363026627
  :local_date: '1905'
- :title: Hirach and Rose Amirkhaniyan in a group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4011.jpg?1363027322
  :local_date: '1947'
- :title: Hirach and Rose Amirkhaniyan during travel to India
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4012.jpg?1363030575
  :local_date: '1949'
- :title: Hirach and Rose Amirkhaniyan during travel to India
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4013.jpg?1363030800
  :local_date: '1949'
- :title: Hirach and Rose Amirkhaniyan during travel to India
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4014.jpg?1363031161
  :local_date: '1951'
- :title: Hirach Amirkhaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4015.jpg?1363031543
  :local_date: circa. 1915
- :title: Shaki Istipaniyan (Abdaliyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4016.jpg?1363031792
  :local_date: '1939'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4018.jpg?1363032298
  :local_date: '1975'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4019.jpg?1363032551
  :local_date: '1962'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4020.jpg?1363033311
  :local_date: circa. 1965
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4021.jpg?1363033819
  :local_date:
- :title: Anik Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4022.jpg?1363034096
  :local_date: 2000 - 2001
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4023.jpg?1363034367
  :local_date: '1924'
- :title: Hirach Amirkhaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4004.jpg?1363024840
  :local_date: '1906'
- :title: Rose Amirkhaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4005.jpg?1363025138
  :local_date: '1906'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4006.jpg?1363025766
  :local_date: '1949'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4026.jpg?1363035188
  :local_date: '1932'
- :title: Furugh al-Dawlah and her daughters Furugh al-Muluk and Malik al-Muluk
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3984.jpg?1363016796
  :local_date: 20 Safar 1328 AH
- :title: Shaki Istipaniyan (Abdaliyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3986.jpg?1363018012
  :local_date: '1930'
- :title: Hirach and Rose Amirkhaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4010.jpg?1363026939
  :local_date: '1947'
- :title: Sirp Khan Amirkhaniyan, Isabil Sururiyan (Amirkhaniyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4017.jpg?1363032059
  :local_date: 1299 AH
- :title: Artin Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4002.jpg?1363023906
  :local_date: '1903'
- :title: Anik Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4024.jpg?1363034658
  :local_date: '1939'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4025.jpg?1363034957
  :local_date: '1932'
- :title: Ninish Amirkhaniyan (Istipaniyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4001.jpg?1363023568
  :local_date: circa. 1915
- :title: Ninish Amirkhaniyan (Istipaniyan) among a group of friends
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3990.jpg?1363019333
  :local_date: circa. 1920
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4027.jpg?1363035577
  :local_date: '1932'
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4058.jpg?1364222987
  :local_date: '1944'
- :title: Ninish Amirkhaniyan (Istipaniyan) and relatives
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4059.jpg?1364223248
  :local_date: '1940'
- :title: Anik and Artin Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4060.jpg?1364223577
  :local_date:
- :title: Ninish Amirkhaniyan (Istipaniyan) and Artin Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4061.jpg?1364224519
  :local_date: circa. 1925
- :title: Ninish Amirkhaniyan (Istipaniyan) and Artin Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4062.jpg?1364225268
  :local_date: '1954'
- :title: Anik and Shaki Istipaniyan with their friends
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4063.jpg?1364225511
  :local_date: '1936'
- :title: Ninish Amrikhaniyan (Istipanian), Artin, Rebecca, and Anik Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4064.jpg?1364226067
  :local_date: '1940'
- :title: Ninish Amirkhaniyan (Istipaniyan), Hirach Amirkhaniyan, Shaki Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4065.jpg?1364226425
  :local_date: '1937'
- :title: Ninish Amirkhaniyan (Istipaniyan) and relatives
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4066.jpg?1364226701
  :local_date: '1934'
- :title: Ninish Amirkhaniyan (Istipaniyan) and her family at their yard
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4067.jpg?1364227315
  :local_date: '1940'
- :title: Ninish Amirkhaniyan (Istipaniyan) with her relatives and friends
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4068.jpg?1364227599
  :local_date: '1935'
- :title: Ninish Amirkhaniyan (Istipaniyan) and her family
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4069.jpg?1364227932
  :local_date: '1963'
- :title: Ninish Amirkhaniyan (Istipaniyan) and her family
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4070.jpg?1364228165
  :local_date: circa. 1940
- :title: Ninish Amirkhaniyan (Istipaniyan) and her family
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4071.jpg?1364228513
  :local_date: circa. 1958 - 1960
- :title: Possibly Malkum Khan with his wife and child
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4056.jpg?1364222204
  :local_date:
- :title: Group portrait
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4057.jpg?1364222567
  :local_date: '1953'
- :title: Anik Istipaniyan, Shaki Istipaniyan, and Artin Istipaniyan
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4028.jpg?1363036224
  :local_date:
- :title: Ninish Amirkhaniyan (Istipaniyan) in her middle age
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4029.jpg?1363036761
  :local_date: '1940'
- :title: Children of Ninish Amirkhaniyan (Istipaniyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4030.jpg?1363037119
  :local_date: '1925'
- :title: Asatur Khan Amirkhaniyan's family
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4031.jpg?1363038171
  :local_date: '1920'
- :title: Postcard
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4032.jpg?1363038839
  :local_date: '1933'
- :title: Postcard
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4033.jpg?1363039137
  :local_date: '1933'
- :title: Shaki Istipaniyan (Abdaliyan)
  :url: ! '#'
  :thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3988.jpg?1363018545
  :local_date: '1938'
YAML

EN_TIMELINE_YAML = <<-YAML
---
timeline:
  type: default
  date:
  - startDate: '1884'
    headline: birth-timeline-message
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
    text: Born to <a href='/en/people/2070.html'>Isabil Sururiyan (Amirkhaniyan)</a>
      and <a href='/en/people/2069.html'>Sirp Khan Amirkhaniyan</a>, Tehran
  - startDate: '1953'
    headline: death-timeline-message
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg?1361902386
  - startDate: '1912'
    headline: daughter-timeline-message
    text: <a href='/en/people/2063.html'>Anik Istipaniyan (Avakiyan)</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2063.jpg?1361910312
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2063.jpg?1361910312
  - startDate: '1914'
    headline: daughter-timeline-message
    text: <a href='/en/people/2064.html'>Shaki Istipaniyan (Abdaliyan)</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2064.jpg?1361913132
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2064.jpg?1361913132
  - startDate: '1916'
    headline: son-timeline-message
    text: <a href='/en/people/2065.html'>Armin Istipaniyan</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2065.jpg?1361913509
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2065.jpg?1361913509
  - startDate: '1918'
    headline: son-timeline-message
    text: <a href='/en/people/2066.html'>Samsun Istipaniyan</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2066.jpg?1361913892
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2066.jpg?1361913892
  - startDate: '1910'
    headline: son-timeline-message
    text: <a href='/en/people/2067.html'>Hufisb Istipaniyan</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2067.jpg?1361914610
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2067.jpg?1361914610
  - startDate: '1920'
    headline: son-timeline-message
    text: <a href='/en/people/2068.html'>Rustam Istipaniyan</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2068.jpg?1361914951
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2068.jpg?1361914951
  - startDate: '1958'
    headline: Armenian Women's Charity Society
    text: <a href='/en/items/1260A2.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3985.jpg?1363017667
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3985.jpg?1363017667
  - startDate: '1934'
    headline: Shaki Istipaniyan (Abdaliyan)
    text: <a href='/en/items/1260A4.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3987.jpg?1363018276
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3987.jpg?1363018276
  - startDate: '1925'
    headline: Ninish Amirkhaniyan (Istipaniyan)'s children
    text: <a href='/en/items/1260A6.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3989.jpg?1363018946
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3989.jpg?1363018946
  - startDate: '1905'
    headline: Harach Amirkhaniyan with a group of friends and teachers
    text: <a href='/en/items/1260A8.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3991.jpg?1363019708
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3991.jpg?1363019708
  - startDate: '1903'
    headline: Rose Amirkhaniyan among a group of friends and teachers
    text: <a href='/en/items/1260A9.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3992.jpg?1363020139
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3992.jpg?1363020139
  - startDate: '1919'
    headline: Hufisb, Armin and Samsun
    text: <a href='/en/items/1260A10.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3993.jpg?1363020405
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3993.jpg?1363020405
  - startDate: '1940'
    headline: Anik Istipaniyan in her wedding dress
    text: <a href='/en/items/1260A11.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3994.jpg?1363020727
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3994.jpg?1363020727
  - startDate: '1900'
    headline: Huvans Khan Masiyan
    text: <a href='/en/items/1260A12.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3995.jpg?1363021178
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3995.jpg?1363021178
  - startDate: '1920'
    headline: Sisters and children of Ninish Amirkhaniyan (Istipaniyan)
    text: <a href='/en/items/1260A13.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3996.jpg?1363021513
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3996.jpg?1363021513
  - startDate: '1913'
    headline: Children of Ninish Amirkhaniyan (Istipaniyan)
    text: <a href='/en/items/1260A14.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3997.jpg?1363021793
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3997.jpg?1363021793
  - startDate: '1910'
    headline: Ninish Amirkhaniyan (Istipaniyan) and Artin Istipaniyan
    text: <a href='/en/items/1260A17.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4000.jpg?1363023258
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4000.jpg?1363023258
  - startDate: '1917'
    headline: Group portrait
    text: <a href='/en/items/1260A15.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3998.jpg?1363022127
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3998.jpg?1363022127
  - startDate: '1900'
    headline: Hirach and Rose Amirkhaniyan
    text: <a href='/en/items/1260A20.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4003.jpg?1363024203
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4003.jpg?1363024203
  - startDate: '1928'
    headline: Sister and daughters of Ninish Amirkhaniyan (Istipaniyan)
    text: <a href='/en/items/1260A24.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4007.jpg?1363026055
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4007.jpg?1363026055
  - startDate: '1900'
    headline: Group portrait
    text: <a href='/en/items/1260A25.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4008.jpg?1363026349
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4008.jpg?1363026349
  - startDate: '1905'
    headline: Hirach Amirkhaniyan
    text: <a href='/en/items/1260A26.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4009.jpg?1363026627
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4009.jpg?1363026627
  - startDate: '1947'
    headline: Hirach and Rose Amirkhaniyan in a group portrait
    text: <a href='/en/items/1260A28.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4011.jpg?1363027322
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4011.jpg?1363027322
  - startDate: '1949'
    headline: Hirach and Rose Amirkhaniyan during travel to India
    text: <a href='/en/items/1260A29.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4012.jpg?1363030575
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4012.jpg?1363030575
  - startDate: '1949'
    headline: Hirach and Rose Amirkhaniyan during travel to India
    text: <a href='/en/items/1260A30.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4013.jpg?1363030800
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4013.jpg?1363030800
  - startDate: '1951'
    headline: Hirach and Rose Amirkhaniyan during travel to India
    text: <a href='/en/items/1260A31.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4014.jpg?1363031161
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4014.jpg?1363031161
  - startDate: '1915'
    headline: Hirach Amirkhaniyan
    text: <a href='/en/items/1260A32.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4015.jpg?1363031543
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4015.jpg?1363031543
  - startDate: '1939'
    headline: Shaki Istipaniyan (Abdaliyan)
    text: <a href='/en/items/1260A33.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4016.jpg?1363031792
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4016.jpg?1363031792
  - startDate: '1975'
    headline: Group portrait
    text: <a href='/en/items/1260A35.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4018.jpg?1363032298
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4018.jpg?1363032298
  - startDate: '1962'
    headline: Group portrait
    text: <a href='/en/items/1260A36.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4019.jpg?1363032551
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4019.jpg?1363032551
  - startDate: '1965'
    headline: Group portrait
    text: <a href='/en/items/1260A37.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4020.jpg?1363033311
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4020.jpg?1363033311
  - startDate: '2000'
    headline: Anik Istipaniyan
    text: <a href='/en/items/1260A39.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4022.jpg?1363034096
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4022.jpg?1363034096
  - startDate: '1924'
    headline: Group portrait
    text: <a href='/en/items/1260A40.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4023.jpg?1363034367
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4023.jpg?1363034367
  - startDate: '1906'
    headline: Hirach Amirkhaniyan
    text: <a href='/en/items/1260A21.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4004.jpg?1363024840
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4004.jpg?1363024840
  - startDate: '1906'
    headline: Rose Amirkhaniyan
    text: <a href='/en/items/1260A22.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4005.jpg?1363025138
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4005.jpg?1363025138
  - startDate: '1949'
    headline: Group portrait
    text: <a href='/en/items/1260A23.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4006.jpg?1363025766
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4006.jpg?1363025766
  - startDate: '1932'
    headline: Group portrait
    text: <a href='/en/items/1260A43.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4026.jpg?1363035188
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4026.jpg?1363035188
  - startDate: '1910'
    headline: Furugh al-Dawlah and her daughters Furugh al-Muluk and Malik al-Muluk
    text: <a href='/en/items/1260A1.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3984.jpg?1363016796
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3984.jpg?1363016796
  - startDate: '1930'
    headline: Shaki Istipaniyan (Abdaliyan)
    text: <a href='/en/items/1260A3.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3986.jpg?1363018012
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3986.jpg?1363018012
  - startDate: '1947'
    headline: Hirach and Rose Amirkhaniyan
    text: <a href='/en/items/1260A27.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4010.jpg?1363026939
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4010.jpg?1363026939
  - startDate: '1881'
    headline: Sirp Khan Amirkhaniyan, Isabil Sururiyan (Amirkhaniyan)
    text: <a href='/en/items/1260A34.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4017.jpg?1363032059
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4017.jpg?1363032059
  - startDate: '1903'
    headline: Artin Istipaniyan
    text: <a href='/en/items/1260A19.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4002.jpg?1363023906
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4002.jpg?1363023906
  - startDate: '1939'
    headline: Anik Istipaniyan
    text: <a href='/en/items/1260A41.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4024.jpg?1363034658
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4024.jpg?1363034658
  - startDate: '1932'
    headline: Group portrait
    text: <a href='/en/items/1260A42.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4025.jpg?1363034957
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4025.jpg?1363034957
  - startDate: '1915'
    headline: Ninish Amirkhaniyan (Istipaniyan)
    text: <a href='/en/items/1260A18.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4001.jpg?1363023568
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4001.jpg?1363023568
  - startDate: '1920'
    headline: Ninish Amirkhaniyan (Istipaniyan) among a group of friends
    text: <a href='/en/items/1260A7.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3990.jpg?1363019333
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3990.jpg?1363019333
  - startDate: '1932'
    headline: Group portrait
    text: <a href='/en/items/1260A44.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4027.jpg?1363035577
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4027.jpg?1363035577
  - startDate: '1944'
    headline: Group portrait
    text: <a href='/en/items/1260A53.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4058.jpg?1364222987
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4058.jpg?1364222987
  - startDate: '1940'
    headline: Ninish Amirkhaniyan (Istipaniyan) and relatives
    text: <a href='/en/items/1260A54.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4059.jpg?1364223248
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4059.jpg?1364223248
  - startDate: '1925'
    headline: Ninish Amirkhaniyan (Istipaniyan) and Artin Istipaniyan
    text: <a href='/en/items/1260A56.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4061.jpg?1364224519
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4061.jpg?1364224519
  - startDate: '1954'
    headline: Ninish Amirkhaniyan (Istipaniyan) and Artin Istipaniyan
    text: <a href='/en/items/1260A57.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4062.jpg?1364225268
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4062.jpg?1364225268
  - startDate: '1936'
    headline: Anik and Shaki Istipaniyan with their friends
    text: <a href='/en/items/1260A58.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4063.jpg?1364225511
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4063.jpg?1364225511
  - startDate: '1940'
    headline: Ninish Amrikhaniyan (Istipanian), Artin, Rebecca, and Anik Istipaniyan
    text: <a href='/en/items/1260A59.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4064.jpg?1364226067
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4064.jpg?1364226067
  - startDate: '1937'
    headline: Ninish Amirkhaniyan (Istipaniyan), Hirach Amirkhaniyan, Shaki Istipaniyan
    text: <a href='/en/items/1260A60.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4065.jpg?1364226425
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4065.jpg?1364226425
  - startDate: '1934'
    headline: Ninish Amirkhaniyan (Istipaniyan) and relatives
    text: <a href='/en/items/1260A61.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4066.jpg?1364226701
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4066.jpg?1364226701
  - startDate: '1940'
    headline: Ninish Amirkhaniyan (Istipaniyan) and her family at their yard
    text: <a href='/en/items/1260A62.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4067.jpg?1364227315
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4067.jpg?1364227315
  - startDate: '1935'
    headline: Ninish Amirkhaniyan (Istipaniyan) with her relatives and friends
    text: <a href='/en/items/1260A63.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4068.jpg?1364227599
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4068.jpg?1364227599
  - startDate: '1963'
    headline: Ninish Amirkhaniyan (Istipaniyan) and her family
    text: <a href='/en/items/1260A64.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4069.jpg?1364227932
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4069.jpg?1364227932
  - startDate: '1940'
    headline: Ninish Amirkhaniyan (Istipaniyan) and her family
    text: <a href='/en/items/1260A65.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4070.jpg?1364228165
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4070.jpg?1364228165
  - startDate: '1958'
    headline: Ninish Amirkhaniyan (Istipaniyan) and her family
    text: <a href='/en/items/1260A66.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4071.jpg?1364228513
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4071.jpg?1364228513
  - startDate: '1953'
    headline: Group portrait
    text: <a href='/en/items/1260A52.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4057.jpg?1364222567
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4057.jpg?1364222567
  - startDate: '1940'
    headline: Ninish Amirkhaniyan (Istipaniyan) in her middle age
    text: <a href='/en/items/1260A46.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4029.jpg?1363036761
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4029.jpg?1363036761
  - startDate: '1925'
    headline: Children of Ninish Amirkhaniyan (Istipaniyan)
    text: <a href='/en/items/1260A47.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4030.jpg?1363037119
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4030.jpg?1363037119
  - startDate: '1920'
    headline: Asatur Khan Amirkhaniyan's family
    text: <a href='/en/items/1260A48.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4031.jpg?1363038171
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4031.jpg?1363038171
  - startDate: '1933'
    headline: Postcard
    text: <a href='/en/items/1260A49.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4032.jpg?1363038839
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4032.jpg?1363038839
  - startDate: '1933'
    headline: Postcard
    text: <a href='/en/items/1260A50.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4033.jpg?1363039137
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_4033.jpg?1363039137
  - startDate: '1938'
    headline: Shaki Istipaniyan (Abdaliyan)
    text: <a href='/en/items/1260A5.html'>view-item</a>
    asset:
      thumbnail: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3988.jpg?1363018545
      media: http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/it_3988.jpg?1363018545
YAML
