require 'spec_helper'

describe "The Search Entry Page" do
  it "is not located at /" do
    get('/').should_not be_ok
  end

  it "doesnt require a language" do
    get('/search').should be_ok 
  end

  it "is ok with a language" do
    get('/search?lang=en').should be_ok
    get('/search?lang=fa').should be_ok
  end
end

describe "The Search Results page" do
  before do
    mocked_response = { 
      "took" => 87,
      "timed_out" => false,
      "_shards" => {"total"=>1, "successful"=>1, "failed"=>0},
      "hits" => { "total" => 30, "max_score" => 100, "hits" => [] },
      "facets" => {
        "genres_en"=> {
          "_type"=>"terms",
          "missing"=>79,
          "total"=>1303,
          "other"=>0,
          "terms"=> [
            {"term"=>"photographs", "count"=>511},
            {"term"=>"objects", "count"=>234},
            {"term"=>"legal & financial", "count"=>133},
            {"term"=>"letters", "count"=>118},
            {"term"=>"writings", "count"=>53},
            {"term"=>"marriage contracts", "count"=>49},
            {"term"=>"petitions", "count"=>46},
            {"term"=>"audio files", "count"=>32},
            {"term"=>"manuscripts", "count"=>28},
            {"term"=>"drawings and paintings ", "count"=>23},
            {"term"=>"sales & settlements", "count"=>14},
            {"term"=>"embroidery", "count"=>14},
            {"term"=>"endowments", "count"=>7},
            {"term"=>"maps", "count"=>6},
            {"term"=>"genealogies", "count"=>6},
            {"term"=>"wills", "count"=>5},
            {"term"=>"powers of attorney", "count"=>4},
            {"term"=>"periodicals", "count"=>4},
            {"term"=>"leases", "count"=>4},
            {"term"=>"dowry registries", "count"=>4},
            {"term"=>"calligraphy", "count"=>4},
            {"term"=>"speeches", "count"=>2},
            {"term"=>"travelogue", "count"=>1},
            {"term"=>"prayers & devotions", "count"=>1}
          ]
        }
      }
    }
    mocked_response["hits"]["total"].times do |i|
      mocked_response["hits"]["hits"] << { 
        "_id" => i.to_s,
        "_type" => "item",
        "_score" => 100 - i,
        "_source" => {
          title_en: "foo#{i}", 
          description_en: "bar#{i}"
        }
      }
    end
    mocked_results = Tire::Results::Collection.new(mocked_response)
    Tire.stub_chain(:search, :results).and_return(mocked_results)
  end

  it "should use tire to search the elasticsearch index" do
    Tire.should_receive(:search)
    visit "/search?query=Foobar"
  end

  it "should show results" do
    visit "/search?query=*"
    page.should have_content "foo9"
    page.should have_content "foo19"
  end

  it "should have pages when there are enough results"
end
