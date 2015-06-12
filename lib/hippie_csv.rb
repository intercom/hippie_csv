require "hippie_csv/version"
require "hippie_csv/constants"
require "hippie_csv/operations"
require "csv"

module HippieCsv
  def self.parse(path)
    string = Operations.file_path_to_string(path)

    Operations.encode!(string)

    QUOTE_CHARACTERS.find do |quote_character|
      Operations.rescuing_malformed do
        return Operations.parse_csv(string, quote_character)
      end
    end
  end
end
