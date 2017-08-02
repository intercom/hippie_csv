require "hippie_csv/version"
require "hippie_csv/support"
require "hippie_csv/errors"

module HippieCSV
  def self.read(path)
    string = File.read(path, encoding: ENCODING_WITH_BOM)
    parse(string)
  end

  def self.parse(string)
    Support.maybe_parse(string) || (raise UnableToParseError)
  end

  def self.stream(path, &block)
    Support.maybe_stream(path, &block)
  end
end
