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

  it "should have pages when there are enough results" do
    mocked_results = []
    15.times do |i|
      mocked_results << double(
        title_en: "foo#{i}", 
        description_en: "bar#{i}",
        url_en: "",
        thumbnail_en: nil,
        thumbnail: nil,
        name: nil,
        type: "fooo",
        created_at: nil
      )
    end
    Tire.stub_chain(:search, :results).and_return(mocked_results)
    visit "/search?query=*&lang=en"
    page.should have_content "foo9"
    page.should_not have_content "foo10"
    visit "/search?query=*&lang=en&page=2"
    page.should have_content "foo10"
  end
end
