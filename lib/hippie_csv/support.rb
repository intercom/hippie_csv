require "hippie_csv/constants"
require "rchardet"

module HippieCSV
  module Support
    class << self
      def file_path_to_string(file_path)
        File.read(file_path, encoding: ENCODING_WITH_BOM)
      end

      def encode(string)
        string = ensure_valid_encoding(string)

        DELIMETERS.each do |delimiter|
          string.gsub!(blank_line_regex(delimiter), "")
        end

        string.encode(string.encoding, universal_newline: true)
      end

      def maybe_parse(string)
        encoded_string = encode(string)

        QUOTE_CHARACTERS.find do |quote_character|
          [encoded_string, tolerate_escaping(encoded_string, quote_character), dump_quotes(encoded_string, quote_character)].find do |string_to_parse|
            rescuing_malformed do
              return parse_csv(string_to_parse.squeeze("\n").strip, quote_character)
            end
          end
        end
      end

      def parse_csv(string, quote_character)
        CSV.parse(
          string,
          quote_char: quote_character,
          col_sep: guess_delimeter(string, quote_character)
        )
      end

      def maybe_stream(path, &block)
        File.foreach(path, encoding: ENCODING_WITH_BOM) do |line|
          row = maybe_parse(line)
          block.call(row.first) if row.first
        end
      end

      def dump_quotes(string, quote_character)
        string.gsub(quote_character, "")
      end

      def rescuing_malformed
        begin; yield; rescue CSV::MalformedCSVError; end
      end

      def tolerate_escaping(string, quote_character)
        string.gsub("\\#{quote_character}", "#{quote_character}#{quote_character}")
      end

      def guess_delimeter(string, quote_character)
        results = DELIMETERS.map do |delimeter|
          [delimeter, field_count(string, delimeter, quote_character)]
        end.max_by do |delimeter, count|
          count
        end.each do |delimiter, count|
          return delimiter
        end
      end

      private

      def ensure_valid_encoding(string)
        return string if string.valid_encoding?

        current_encoding = detect_encoding(string)

        if !current_encoding.nil? && current_encoding != ENCODING
          string.encode(ENCODING, current_encoding)
        else
          magical_encode(string)
        end
      rescue Encoding::InvalidByteSequenceError
        magical_encode(string)
      end

      def blank_line_regex(delimiter)
        /^#{delimiter}+(\r\n|\r)$/
      end

      def detect_encoding(string)
        CharDet.detect(string[0..ENCODING_SAMPLE_CHARACTER_COUNT])["encoding"]
      end

      def magical_encode(string)
        string.encode(ALTERNATE_ENCODING, ENCODING, invalid: :replace, replace: "")
              .encode(ENCODING, ALTERNATE_ENCODING)
      end

      def field_count(file, delimeter, quote_character)
        csv = CSV.new(file, col_sep: delimeter, quote_char: quote_character)
        csv.lazy.take(FIELD_SAMPLE_COUNT).map(&:size).inject(:+)
      rescue CSV::MalformedCSVError
        0
      end
    end
  end
end
