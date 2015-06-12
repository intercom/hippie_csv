module HippieCsv
  class UnableToParseError < StandardError
    def self.explain
      raise new "Something went wrong. Report this CSV: https://github.com/intercom/hippie_csv"
    end
  end
end
