require "spec_helper"

describe HippieCsv do

  describe "::QUOTE_CHARACTERS" do
    let(:supported_quote_characters) { ['"', "'", "|"] }

    it "defines supported quote characters" do
      expect(HippieCsv::QUOTE_CHARACTERS).to match(supported_quote_characters)
    end

    it "is not modifiable" do
      expect(HippieCsv::QUOTE_CHARACTERS).to be_frozen
    end
  end

  describe "::DELIMETERS" do
    let(:supported_delimiters) { [",", ";", "\t"] }

    it "defines supported delimeters" do
      expect(HippieCsv::DELIMETERS).to match(supported_delimiters)
    end

    it "is not modifiable" do
      expect(HippieCsv::DELIMETERS).to be_frozen
    end
  end

  describe "::ENCODING" do
    it "encodes as UTF-8" do
      expect(HippieCsv::ENCODING).to eq('utf-8')
    end

    it "is not modifiable" do
      expect(HippieCsv::ENCODING).to be_frozen
    end
  end

  describe "::ALTERNATE_ENCODING" do
    it "defines an alternative encoding for temporary force encoding purposes" do
      expect(HippieCsv::ALTERNATE_ENCODING).to eq('utf-16')
    end

    it "is not modifiable" do
      expect(HippieCsv::ALTERNATE_ENCODING).to be_frozen
    end
  end

  describe "::FIELD_SAMPLE_COUNT" do
    it "considers the first 10 rows when sampling from a CSV" do
      expect(HippieCsv::FIELD_SAMPLE_COUNT).to eq(10)
    end

    it "is not modifiable" do
      expect(HippieCsv::FIELD_SAMPLE_COUNT).to be_frozen
    end
  end

  describe "::ENCODING_WITH_BOM" do
    it "provides an encoding string supporting byte order mark" do
      expect(HippieCsv::ENCODING_WITH_BOM).to eq('bom|utf-8')
    end

    it "is not modifiable" do
      expect(HippieCsv::ENCODING_WITH_BOM).to be_frozen
    end
  end
end
