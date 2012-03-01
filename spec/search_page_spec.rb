require 'spec_helper'

describe "The Search Entry Page" do
  it "should respond to GET /" do
    #shows the search form 
    get('/').should be_ok
  end

  it "should send me to the /search page when I click the search link" do
    visit('/')
    fill_in "Query", with: "Foo"
    click_button "Search"
    current_url.should =~ %r|/search\?Query=Foo|
  end
end

describe "The Search Results page" do
  it "should respond to GET /search?params" do
    #performs the search,  
    get('/search').should be_ok
  end
end
