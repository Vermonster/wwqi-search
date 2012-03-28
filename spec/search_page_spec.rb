require 'spec_helper'

describe "The Search Entry Page" do
  it "should respond to GET /" do
    #shows the search form 
    get('/').should be_ok
  end

  it "should send me to the /search page when I click the search link" do
    visit('/')
    fill_in "query", with: "Foo"
    click_button "Search"
    current_url.should =~ %r|/search\?query=Foo|
  end

  it "should redirect to '/' on GET '/en'" do
    visit "/en"
    current_path.should == '/'
  end

  it "should respond to GET /fa" do
    get("/fa").should be_ok
  end

  it "should see a search form when it goes to the farsi search page" do
    visit "/fa"
    #page.should have_content "query (in farsi)"
  end
end



describe "The Search Results page" do
  it "should respond to GET /search?params" do
    get('/search').should be_redirect
    get('/search?query=foo').should be_ok
  end

  it "should redirect to / if no query parameter is given" do
    visit '/search'
    current_path.should == "/"
  end

  it "should use tire to search the elasticsearch index" do
    Tire.should_receive(:search).with("_all")
    visit "/search?query=Foobar"
  end
  end
  
end
