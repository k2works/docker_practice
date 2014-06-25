require_relative "spec_helper"
require_relative "../sample_sinatra.rb"

def app
  SampleSinatra
end

describe SampleSinatra do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
