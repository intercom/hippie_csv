require "spec_helper"

describe HippieCSV::Support do

  describe ".encode" do
    context "with invalid byte sequence" do
      let(:string) { "\u0014\xFE\u000E\u0000" }

      it "would error normally" do
        expect { CSV.parse(string) }.to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
      end

      it "works" do
        expect(string).not_to be_valid_encoding

        expect(subject.encode(string)).to be_valid_encoding
      end
    end

    context "with a string detected to be UTF-8 but with an invalid byte sequence" do
      let(:utf8_string) { ("Rubyのメ" * HippieCSV::ENCODING_SAMPLE_CHARACTER_COUNT).force_encoding("utf-8") }
      let(:string) { utf8_string << "\xBF"}

      it "ensures encoding becomes valid" do
        expect(string).not_to be_valid_encoding

        expect(subject.encode(string)).to be_valid_encoding
      end
    end

    context 'with unquoted fields and \r or \n' do
      let(:string) { "id,first_name,last_name\r123,Heinrich,Schütz\r\n" }

      it "would error normally" do
        expect { CSV.parse(string) }.to raise_error(CSV::MalformedCSVError, "Unquoted fields do not allow \\r or \\n (line 3).")
      end

      it "works" do
        result = CSV.parse(subject.encode(string))

        rows, columns = result.size, result.first.size

        expect(rows).to eq(2)
        expect(columns).to eq(3)
      end
    end
  end

  describe ".maybe_parse" do
    let(:file_path) { fixture_path(:small_file) }
    it "works" do
      expect(subject.maybe_parse(File.read(file_path))).to eq(
        [["name", "email"], ["stephen", "test@example.com"]]
      )
    end
  end

  describe ".maybe_stream" do
    let(:file_path) { fixture_path(:small_file) }
    it "works" do
      result = []
      subject.maybe_stream(file_path) { |row| result << row }

      expect(result).to eq(
        [["name", "email"], ["stephen", "test@example.com"]]
      )
    end
  end

  describe ".parse_csv" do
    let(:string) { "name,email\nstephen,test@example.com"}
    let(:quote_character) { "\"" }

    it "works" do
      expect(subject).to receive(:guess_delimeter).with(string, quote_character).and_return(',')

      expect(subject.parse_csv(string, quote_character)).to eq(
        [["name", "email"], ["stephen", "test@example.com"]]
      )
    end
  end

  describe ".rescuing_malformed" do
    let(:error) { CSV::MalformedCSVError }
    let(:will_error) { -> { raise error } }

    it "would normally error" do
      expect { will_error.call }.to raise_error(error)
    end

    it "rescues from CSV::MalformedCSVError" do
      expect { subject.rescuing_malformed { will_error.call } }.not_to raise_error
    end
  end

  describe ".tolerate_escaping" do
    let(:string) { "'Stephen', 'O\\'Brien'"}
    let(:quote_character) { "'" }

    it "enforces escaping according to CSV spec" do
      expect(subject.tolerate_escaping(string, quote_character)).to eq("'Stephen', 'O''Brien'")
    end
  end

  describe ".guess_delimeter" do
    let(:string) { "'a'\t'b'\t'c'\n'd'\t'e'\t'f'\n" }
    let(:quote_character) { "'" }

    it "deduces the delimiter based on counts" do
      expect(subject.guess_delimeter(string, quote_character)).to eq("\t")
    end
  end
end
