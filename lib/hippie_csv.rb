require "hippie_csv/version"
require "hippie_csv/constants"
require "hippie_csv/operations"
require "csv"

module HippieCsv
  def self.parse(path)
    raw_string = Operations.produce_string(path)

    encoded_string = Operations.encode_string(raw_string)

    QUOTE_CHARACTERS.map do |quote_character|
      Operations.parse_csv(encoded_string, quote_character) rescue CSV::MalformedCSVError
    end.compact.first
  end
end
