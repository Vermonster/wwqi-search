module DesignRoutes
  get '/pendar/:lang/collections/manifest.html' do |lang|
    @lang = lang
    erb :collection_manifest
  end

  get '/pendar/:lang/collections/:id.html' do |lang, id|
    @lang = lang
    @id = id
    erb :collection
  end

  get '/pendar/:lang/item/:id.html' do |lang, id|
    @lang = lang
    @id = id
    erb :item
  end

  get '/pendar/:lang/index.html' do |lang|
    @lang = lang
    erb :home
  end

  get '/pendar/:lang/browse.html' do |lang|
    @lang = lang
    erb :browse
  end

  get '/pendar/:lang/contact.html' do |lang|
    @lang = lang
    erb :contact
  end

  get '/pendar/:lang/faq.html' do |lang|
    @lang = lang
    erb :faq
  end
  
  get '/pendar/:lang/links.html' do |lang|
    @lang = lang
    erb :links
  end
  
  get '/pendar/:lang/about.html' do |lang|
    @lang = lang
    erb :about
  end

  get '/pendar/:lang/donate.html' do |lang|
    @lang = lang
    erb :donate
  end

  get '/pendar/:lang/permissions.html' do |lang|
    @lang = lang
    erb :permissions
  end

  get '/pendar/:lang/credits.html' do |lang|
    @lang = lang
    erb :credits
  end
end
