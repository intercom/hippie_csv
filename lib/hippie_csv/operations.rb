module HippieCsv
  module Operations
    def self.produce_string(file_path)
      File.read(file_path, encoding: ENCODING_WITH_BOM)
    end

    def self.encode_string(raw_string)
      unless raw_string.valid_encoding?
        raw_string.encode!(ALTERNATE_ENCODING, ENCODING, invalid: :replace, replace: '')
        raw_string.encode!(ENCODING, ALTERNATE_ENCODING)
      end

      raw_string.encode!(raw_string.encoding, universal_newline: true)
    end

    def self.parse_csv(string, quote_character)
      CSV.parse(tolerate_escaping(string, quote_character),
        quote_char: quote_character,
        col_sep: obtain_delimeter(string, quote_character)
      )
    end

    def self.tolerate_escaping(string, quote_char)
      string.gsub("\\#{quote_char}", "#{quote_char}#{quote_char}")
    end

    def self.obtain_delimeter(file, quote_char)
      results = DELIMETERS.map do |delimeter|
        [delimeter, field_count(file, delimeter, quote_char)]
      end.max_by do |delimeter, count|
        count
      end.first
    end

    def self.field_count(file, delimeter, quote_char)
      csv = CSV.new(file, col_sep: delimeter, quote_char: quote_char)
      csv.lazy.take(FIELD_SAMPLE_COUNT).map(&:size).inject(:+)
    rescue CSV::MalformedCSVError
      0
    end
  end
end
