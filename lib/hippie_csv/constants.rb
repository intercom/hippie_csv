module HippieCsv
  QUOTE_CHARACTERS = %w(" ' |).freeze
  DELIMETERS = %W(, ; \t).freeze
  DEFAULT_DELIMETER = ','.freeze
  ENCODING = 'utf-8'.freeze
  ALTERNATE_ENCODING = 'utf-16'.freeze
  FIELD_SAMPLE_COUNT = 10
  ENCODING_WITH_BOM = "bom|#{ENCODING}".freeze
end
