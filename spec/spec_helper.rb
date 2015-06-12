require "hippie_csv"

def fixture_path(name)
  File.expand_path("../fixtures/#{name}.CSV", __FILE__)
end
