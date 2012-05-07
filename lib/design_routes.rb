module DesignRoutes
  get '/pendar/index.html' do 
    erb :landing
  end

  get '/pendar/:lang/collections/manifest.html' do |lang|
    @lang = lang.to_sym
    erb :collection_manifest
  end

  get '/pendar/:lang/collections/:id.html' do |lang, id|
    @lang = lang.to_sym
    @id = id
    erb :collection
  end

  get '/pendar/:lang/item/:id.html' do |lang, id|
    @lang = lang.to_sym
    @id = id
    erb :item
  end

  get '/pendar/:lang/index.html' do |lang|
    @lang = lang.to_sym
    erb :home
  end

  get '/pendar/:lang/browse.html' do |lang|
    @lang = lang.to_sym
    erb :browse
  end

  get '/pendar/:lang/contact.html' do |lang|
    @lang = lang.to_sym
    erb :contact
  end

  get '/pendar/:lang/faq.html' do |lang|
    @lang = lang.to_sym
    erb :faq
  end
  
  get '/pendar/:lang/links.html' do |lang|
    @lang = lang.to_sym
    erb :links
  end
  
  get '/pendar/:lang/about.html' do |lang|
    @lang = lang.to_sym
    erb :about
  end

  get '/pendar/:lang/donate.html' do |lang|
    @lang = lang.to_sym
    erb :donate
  end

  get '/pendar/:lang/permissions.html' do |lang|
    @lang = lang.to_sym
    erb :permissions
  end

  get '/pendar/:lang/credits.html' do |lang|
    @lang = lang.to_sym
    erb :credits
  end
end
