require "hippie_csv"

def fixture_path(name)
  File.expand_path("../fixtures/#{name}.csv", __FILE__)
end
