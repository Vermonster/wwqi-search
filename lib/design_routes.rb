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
end
