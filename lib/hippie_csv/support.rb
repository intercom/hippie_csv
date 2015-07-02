require "hippie_csv/constants"
require "rchardet"

module HippieCSV
  module Support
    class << self
      def file_path_to_string(file_path)
        File.read(file_path, encoding: ENCODING_WITH_BOM)
      end

      def encode(string)
        unless string.valid_encoding?
          current_encoding = CharDet.detect(string)["encoding"]

          string = if !current_encoding.nil?
            string.encode(ENCODING, current_encoding)
          else
            string.encode(ALTERNATE_ENCODING, ENCODING, invalid: :replace, replace: "")
                  .encode(ENCODING, ALTERNATE_ENCODING)
          end
        end

        string.encode(string.encoding, universal_newline: true)
      end

      def maybe_parse(string)
        QUOTE_CHARACTERS.find do |quote_character|
          Support.rescuing_malformed do
            return Support.parse_csv(string.strip, quote_character)
          end
        end
      end

      def parse_csv(string, quote_character)
        CSV.parse(
          tolerate_escaping(string, quote_character),
          quote_char: quote_character,
          col_sep: guess_delimeter(string, quote_character)
        )
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

      def field_count(file, delimeter, quote_character)
        csv = CSV.new(file, col_sep: delimeter, quote_char: quote_character)
        csv.lazy.take(FIELD_SAMPLE_COUNT).map(&:size).inject(:+)
      rescue CSV::MalformedCSVError
        0
      end
    end
  end
end
