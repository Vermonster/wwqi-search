require 'spec_helper'

describe "The Search Page" do
  it "should respond to GET /" do
    get('/').should be_ok
  end

end
