require "spec_helper"

describe HippieCsv::Support do

  describe ".file_to_string" do
    let(:file_path) { fixture_path(:normal) }
    let(:result) { HippieCsv::Support.file_path_to_string(file_path) }

    it "provides a string" do
      expect(result.class).to eq String
    end

    it "reads the file" do
      expect(result.slice(0,8)).to eq 'id,email'
    end

    context "with a byte order mark" do
      let(:file_path) { fixture_path(:with_byte_order_mark) }

      it "works" do
        expect(result).to eq '"Name","Email Address","Date Added"'
      end
    end
  end

  describe ".encode!" do
    context "with invalid byte sequence" do
      let(:string) { "\u0014\xFE\u000E\u0000" }

      it "would error normally" do
        expect { CSV.parse(string) }.to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
      end

      it "works" do
        expect(string).not_to be_valid_encoding

        subject.encode!(string)

        expect(string).to be_valid_encoding
      end
    end

    context 'with unquoted fields and \r or \n' do
      let(:string) { "id,first_name,last_name\r123,Heinrich,Schütz\r\n" }

      it "would error normally" do
        expect { CSV.parse(string) }.to raise_error(CSV::MalformedCSVError, "Unquoted fields do not allow \\r or \\n (line 3).")
      end

      it "works" do
        subject.encode!(string)

        result = CSV.parse(string)
        rows, columns = result.size, result.first.size

        expect(rows).to eq(2)
        expect(columns).to eq(3)
      end
    end
  end

  describe ".maybe_parse" do
    it "needs to be written" do
      skip # TODO write this test
    end
  end

  describe ".parse_csv" do
    let(:string) { "name,email\nstephen,test@example.com"}
    let(:quote_character) { "\"" }

    it "works" do
      expect(subject).to receive(:guess_delimeter).with(string, quote_character).and_return(',')
      expect(subject).to receive(:tolerate_escaping).with(string, quote_character).and_return(string)

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
