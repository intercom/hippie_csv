module HippieCSV
  class UnableToParseError < StandardError
    def initialize(msg = "Something went wrong. Report this CSV: https://github.com/intercom/hippie_csv")
      super(msg)
    end
  end
end
