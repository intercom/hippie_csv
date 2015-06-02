require "hippie_csv/version"
require "csv"
require "pry"

module HippieCsv
  QUOTE_CHARACTERS = %w(" |).freeze
  DELIMETERS = %W(, ; \t).freeze
  DEFAULT_DELIMETER = ','.freeze
  ENCODING = 'utf-8'.freeze
  FIELD_SAMPLE_COUNT = 10

  class << self
    def parse(path)
      raw_string = encoded_string_for_file(path)

      # tolerate some malformed files
      quote_characters = QUOTE_CHARACTERS.dup
      begin
        quote_char = quote_characters.shift

        # handle escaped quotes
        string_minus_bad_escaping = raw_string.gsub("\\#{quote_char}", "#{quote_char}#{quote_char}")

        parsed_csv = CSV.parse(string_minus_bad_escaping,
          quote_char: quote_char,
          col_sep: obtain_delimeter(raw_string, quote_char)
        )
      rescue CSV::MalformedCSVError
        quote_characters.empty? ? raise : retry
      end

      parsed_csv
    end

    private

    def encoded_string_for_file(path)
      str = File.read(path, encoding: "bom|#{ENCODING}")

      unless str.valid_encoding?
        str.encode!('UTF-16', ENCODING, invalid: :replace, replace: '')
        str.encode!(ENCODING, 'UTF-16')
      end

      str.encode!(str.encoding, universal_newline: true)
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
