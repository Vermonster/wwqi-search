#encoding: utf-8
require 'ostruct'

class String
  def name
    self
  end
end

module ViewHelpers
  def load_example_person_farsi!
    @object = OpenStruct.new
    @object.thumbnail = "http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2062.jpg"
    @object.name = "آرتین استپانیان"
    @object.description = "آرتین استپانیان (متولد ۱۲۴۸)، همسر نی‌نیش امیرخانیان (استپانیان)، اولین تحصیل کرده رشته دندانپزشکی ایران است."
    @object.long_description = <<-DESC
آرتین استپانیان متولد ترکیه و پس از دریافت گواهی نامه از کالج آمریکایی استانبول، برای ادامه تحصیلات به انگلستان رفته مدت دو سال در یکی از دانشکده های پزشکی شهر لندن مشغول تحصیل گردید و از آنجا عازم آمریکای شمالی گردیده و وارد دانشکده دندان پزشکی فیلادلفیا شد. سپس به مدت دو سال در شهر فیلادلفیای مشغول دندان پزشکی گردید و در سال 1902میلادی، عازم ایران شده و در شهر تبریز مطب شخصی خود را دائر کرد. در مدت اقامت او در تبریز به عنوان پزشک خصوصی محمدعلی میرزا فعالیت کرد. پس از مظفرالدین شاه، ولیعهد محمدعلی میرزا به سلطنت رسید و دکتر را نیز همراه خود به تهران آورد او را به سمت دندان پزشک رسمی دربار منصوب نمود. از تاریخ 1908 میلادی دکتر مطب شخصی خود را در تهران دائرکرد و با داشتن سمت "دندان پزشک دربار" مشغول معالجه و خدمت گردید.
DESC
    @object.birthplace = OpenStruct.new(name: "Turkey", url: "#")
    @object.place_of_death = OpenStruct.new(name: "Tehran", url: "#")
    @object.dob = "1870"
    @object.dod = "1952"
    @object.collections = []
    def fake_person(rel, name)
      OpenStruct.new(relationship: OpenStruct.new(name: rel), person: OpenStruct.new(name: name,url: "#"))
    end
    def fake_item(role, name, date)
      OpenStruct.new(role: OpenStruct.new(name: role), item: OpenStruct.new(name: name, url: "#", date: date))
    end
    @object.people_relationships = [
      fake_person(*["دختر", "آنیک استپانیان (آواکیان)"]),
      fake_person(*["زن", "نینیش امیرخانیان (استپانیان)"]),
      fake_person(*["دختر", "شاکه استپانیان (آبدالیان)"]),
      fake_person(*["پسر", "آرمن استپانیان"]),
      fake_person(*["پسر", "سامسون استپانیان"]),
      fake_person(*["پسر", "هوفسب استپانیان"]),
      fake_person(*["پسر", "رستم استپانیان"]),
      fake_person(*["داماد", "آواک آواکیان"]),
      fake_person(*["نوه", "هووانس آواکیان"]),
      fake_person(*["عروس", "آروسیاک"]),
      fake_person(*["خواهر", "ربکا استپانیان"])
    ]
    @object.people_roles = [
      fake_item(*[nil, "نینیش امیرخانیان (استپانیان) وآرتین استپانیان", "1910"]),
      fake_item(*[nil, "آرتین استپانیان", "1903"]),
      fake_item(*[nil, "نینیش امیرخانیان (استپانیان) درجمع دوستان", "حدود 1920"]),
      fake_item(*[nil, "عکس گروهی", "1944"]),
      fake_item(*[nil, "آنیک و آرتین استپانیان", nil]),
      fake_item(*[nil, "نینیش امیرخانیان (استپانیان) و آرتین استپانیان", "حدود 1925"]),
      fake_item(*[nil, "نینیش امیرخانیان (استپانیان) و آرتین استپانیان", "1954"]),
      fake_item(*[nil, "نینیش امیرخانیان (استپانیان)، آرتین، ربکا، و آنیک استپانیان", "1940"]),
      fake_item(*[nil, "خانواده نینیش امیرخانیان (استپانیان) در حیاط منزلشان", "1940"]),
      fake_item(*[nil, "نینیش امیرخانیان (استپانیان) در کنار خانواده", "حدود 1958 تا 1960"]),
      fake_item(*[nil, "آرتین استپانیان، آنیک، و شاکه استپانیان", nil]),
      fake_item(*[nil, "کارت پستال", "1933"])
    ]
    @object.sex = "male"
  end

  def load_example_person!
    # Person # 1226
    @object = OpenStruct.new
    @object.sex = "female"
    @object.thumbnail = "http://s3.amazonaws.com/assets.qajarwomen.org/thumbs/person_2061.jpg"
    @object.name = "Ninish Amirkhaniyan (Istipaniyan)"
    @object.description = "Ninish Amirkhaniyan (Istipaniyan), born in 1884 in Tehran, and her husband Artin Istipaniyan had six children together."
    @object.long_description = "Ninish Amirkhaniyan (Istipaniyan) was born in a progressive Armenian family in Tehran. She studied Sociology at Sorbonne University in Paris and taught French to Qajar Princesses such as Furugh al-Muluk and Malik al-Muluk when she came back to Iran. Muhammad Ali Mirza, who later became shah of Iran, asked her father for her hand in marriage. But she finally married Artin Istipaniyan, who is the first academically educated dentist in Iran according to the family. Ninish's children all perfected in their majors due to her emphasis on higher education."
    @object.birthplace = OpenStruct.new(name: "Tehran", url: "#")
    @object.dob = "1884"
    @object.dod = "1953"
    @object.collections = [OpenStruct.new(url: "#", title: "Avakiyan")]
    def fake_person(rel, name)
      OpenStruct.new(relationship: OpenStruct.new(name: rel), person: OpenStruct.new(name: name,url: "#"))
    end
    def fake_item(role, name, date)
      OpenStruct.new(role: OpenStruct.new(name: role), item: OpenStruct.new(name: name, url: "#", date: date))
    end
    @object.people_relationships = [
      fake_person(*["daughter", "Anik Istipaniyan (Avakiyan)"]),
      fake_person(*["husband", "Artin Istipaniyan"]),
      fake_person(*["daughter", "Shaki Istipaniyan (Abdaliyan)"]),
      fake_person(*["son", "Armin Istipaniyan"]),
      fake_person(*["son", "Samsun Istipaniyan"]),
      fake_person(*["son", "Hufisb Istipaniyan"]),
      fake_person(*["son", "Rustam Istipaniyan"]),
      fake_person(*["father", "Sirp Khan Amirkhaniyan"]),
      fake_person(*["mother", "Isabil Sururiyan (Amirkhaniyan)"]),
      fake_person(*["sister", "Hirach Amirkhaniyan"]),
      fake_person(*["sister", "Rose Amirkhaniyan"]),
      fake_person(*["uncle (paternal)", "Asatur Khan Amirkhaniyan"]),
      fake_person(*["grandchild", "Huvans Avakiyan"]),
      fake_person(*["sister-in-law", "Rebecca Istipaniyan"])
    ]
    @object.people_roles = [
      fake_item(*["No Role", "Armenian Women's Charity Society", "1958"]),
      fake_item(*["No Role", "Shaki Istipaniyan (Abdaliyan)", "1934"]),
      fake_item(*["No Role", "Ninish Amirkhaniyan (Istipaniyan)'s children", "1925"]),
      fake_item(*["No Role", "Harach Amirkhaniyan with a group of friends and teachers", "circa. 1905"]),
      fake_item(*["No Role", "Rose Amirkhaniyan among a group of friends and teachers", "circa. 1903"])
    ]
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
