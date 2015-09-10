require "csv"

module HippieCSV
  QUOTE_CHARACTERS = %w(" ' | ∑ ⦿ ◉).freeze
  # The latter three characters are not expected to intentionally used as
  # quotes. Rather, when usual quote characters are badly misused, we want
  # to fall back to a character _unlikely_ to be in the file, such that
  # we can at least parse.

  DELIMETERS = %W(, ; \t).freeze
  ENCODING = "utf-8".freeze
  ALTERNATE_ENCODING = "utf-16".freeze
  FIELD_SAMPLE_COUNT = 10.freeze
  ENCODING_SAMPLE_CHARACTER_COUNT = 10000.freeze
  ENCODING_WITH_BOM = "bom|#{ENCODING}".freeze
end
