require "hippie_csv/version"
require "csv"

module HippieCsv
  QUOTE_CHARACTERS = %w(" ').freeze
  DELIMETERS = %W(, ; \t).freeze
  DEFAULT_DELIMETER = ','.freeze
  ENCODING = 'utf-8'.freeze
  ALTERNATE_ENCODING = 'utf-16'.freeze
  FIELD_SAMPLE_COUNT = 10
  ENCODING_WITH_BOM = "bom|#{ENCODING}".freeze

  class << self
    def parse(path)
      csv_string = encoded_string_for_file(path)

      parsed_csv = QUOTE_CHARACTERS.map do |quote_char|
        try_parse_csv(csv_string, quote_char)
      end.compact.first

      parsed_csv
    end

    private

    def encoded_string_for_file(path)
      str = File.read(path, encoding: ENCODING_WITH_BOM)

      unless str.valid_encoding?
        str.encode!(ALTERNATE_ENCODING, ENCODING, invalid: :replace, replace: '')
        str.encode!(ENCODING, ALTERNATE_ENCODING)
      end

      str.encode!(str.encoding, universal_newline: true)
    end

    def try_parse_csv(string, quote_char)
      begin
        parse_csv(string, quote_char)
      rescue CSV::MalformedCSVError
      end
    end

    def parse_csv(string, quote_char)
      CSV.parse(tolerate_escaping(string, quote_char),
        quote_char: quote_char,
        col_sep: obtain_delimeter(string, quote_char)
      )
    end

    def tolerate_escaping(string, quote_char)
      string.gsub("\\#{quote_char}", "#{quote_char}#{quote_char}")
    end

    def obtain_delimeter(file, quote_char)
      results = DELIMETERS.map do |delimeter|
        [delimeter, field_count(file, delimeter, quote_char)]
      end.max_by do |delimeter, count|
        count
      end.first
    end

    def field_count(file, delimeter, quote_char)
      csv = CSV.new(file, col_sep: delimeter, quote_char: quote_char)
      csv.lazy.take(FIELD_SAMPLE_COUNT).map(&:size).inject(:+)
    rescue CSV::MalformedCSVError
      0
    end
  end
end
