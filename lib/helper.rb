module Helpers
  def t(*_) ; end
  
  def javascript(name)
    %Q|<script type='text/javascript' src='/javascripts/#{name}.js'></script>|
  end

  def lang_link_to(text, link, opts={})
    lang = opts.delete(:lang) 
    url = URI.join(ENV["MAIN_SITE_URL"], "#{lang}/", "#{link}")
    
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

  def search_url
    ENV["SEARCH_URL"]
  end

  def carousel
    ["1131-1141","1134","1016-1139","1131-1142","1019","1025","911","1021A","907-1023","1014","1018","905-906-1017"]
  end

  def carousel_entry(acc)
    entries = { 
      "1131-1141"    => { lang: @lang, img: "collection_33.jpg", text: "Shirin Dukht Sultani Nuri"                 , acc: "1131-1141"    },
      "1134"         => { lang: @lang, img: "collection_35.jpg", text: "Moezzi Family"                             , acc: "1134"         },
      "1016-1139"    => { lang: @lang, img: "collection_8.jpg" , text: "Bahram Sheikholeslami"                     , acc: "1016-1139"    },
      "1131-1142"    => { lang: @lang, img: "collection_25.jpg", text: "Bahman Bayani Collection"                  , acc: "1131-1142"    },

      "1019"         => { lang: @lang, img: "collection_26.jpg", text: "Nush Afarin Ansari"                        , acc: "1019"         },
      "1025"         => { lang: @lang, img: "collection_21.jpg", text: "The Center for Iranian Jewish Oral History", acc: "1025"         },
      "911"          => { lang: @lang, img: "collection_6.jpg" , text: "Houri Mostofi Moghadam"                    , acc: "911"          },
      "1021A"        => { lang: @lang, img: "collection_28.jpg", text: "Najm al-Saltanah"                          , acc: "1021A"        },
      "907-1023"     => { lang: @lang, img: "collection_2.jpg" , text: "Nusrat Mozaffari"                          , acc: "907-1023"     },
      "1014"         => { lang: @lang, img: "collection_7.jpg" , text: "Najmabadi Papers"                          , acc: "1014"         },
      "1018"         => { lang: @lang, img: "collection_19.jpg", text: "Majlis Library, Museum and Document Center", acc: "1018"         },
      "905-906-1017" => { lang: @lang, img: "collection_12.jpg", text: "Sadiqah Dawlatabadi"                       , acc: "905-906-1017" }
    }
    collection_entry(entries[acc])
  end

  def collection_entry(opts = {})
    raise "must provide img" unless opts.has_key? :img
    raise "must provide acc" unless opts.has_key? :acc
    raise "must provide alt or text options" unless opts.has_key? :alt or opts.has_key? :text

    img_url = "#{ENV["ASSET_URL"]}/collection_thumbs/#{opts[:img]}"

    opts[:text] ||= opts[:alt]  # must provide one or the other
    opts[:alt]  ||= opts[:text]

    %Q|<li><a href="/#{opts[:lang]}/collection/#{opts[:acc]}.html">
        <div class="collection-thumb">
          <img src="#{img_url}" alt="#{opts[:alt]}">
          <span>#{opts[:text]}</span>
          <div class="layer1"></div>
          <div class="layer2"></div>
        </div>
      </a></li>|
  end
end
