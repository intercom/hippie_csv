require "hippie_csv/version"
require "hippie_csv/support"
require "hippie_csv/errors"

module HippieCSV
  def self.read(path)
    string = Support.file_path_to_string(path)
    parse(string)
  end

  def self.parse(string)
    string = Support.encode(string)
    Support.maybe_parse(string) || (raise UnableToParseError)
  end
end
