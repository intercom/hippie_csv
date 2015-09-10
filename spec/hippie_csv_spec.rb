require "spec_helper"
require "csv"

describe HippieCSV do
  let(:string) { "test" }

  describe ".read" do
    let(:path) { double }

    it "converts to string and parses" do
      expect(subject::Support).to receive(:file_path_to_string).with(path).and_return(string)
      expect(subject).to receive(:parse).with(string)

      subject.read(path)
    end
  end

  describe ".parse" do
    it "encodes the string" do
      expect(subject::Support).to receive(:encode).with(string)
      allow(subject::Support).to receive(:maybe_parse).and_return(double)

      subject.parse(string)
    end

    it "defers to support parse method" do
      result = double
      expect(subject::Support).to receive(:maybe_parse).with(string).and_return(result)

      expect(subject.parse(string)).to eq(result)
    end

    context "when unable to parse" do
      before do
        expect(subject::Support).to receive(:maybe_parse).and_return(nil)
      end

      it "raises an error" do
        expect {
          subject.parse(string)
        }.to raise_error(
          subject::UnableToParseError,
          "Something went wrong. Report this CSV: https://github.com/intercom/hippie_csv"
        )
      end
    end
  end

  context "integration cases: hard/encountered problems" do
    it "works when a BOM is present in the file" do
      path = fixture_path(:with_byte_order_mark)
      expect { CSV.read(path) }.to raise_error(CSV::MalformedCSVError)

      import = subject.read(path)
      expect(import[0]).to eq(["Name", "Email Address", "Date Added"])
    end

    it "works with a malformed CSV" do
      path = fixture_path(:malformed)
      expect { CSV.read(path) }.to raise_error(CSV::MalformedCSVError)

      import = subject.read(path)
      expect(import[0]).to eq(%w(site lon lat max min precip snow snowdepth))
    end

    it "works with odd encoding & emoji!" do
      path = fixture_path(:encoding)
      expect { CSV.read(path) }.to raise_error(ArgumentError)

      import = subject.read(path)
      expect(import[0].count).to eq(4)
    end

    it "works with an excel export" do
      path = fixture_path(:excel)

      import = subject.read(path)
      expect(import[0].count).to eq(24)
    end

    it "works with escaped quotes" do
      path = fixture_path(:escaped_quotes)

      import = subject.read(path)
      expect(import[0][1]).to eq("Lalo \"ElPapi\" Neymar")
      expect(import[0][2]).to eq("lalo@example.com")
    end

    it "works with an invalid escaped quotes case" do
      path = fixture_path(:escaped_quotes_semicolons)

      import = subject.read(path)
      expect(import[0][0]).to eq("133")
      expect(import[0][1]).to eq("z3268856")
      expect(import[0][2]).to eq("stephen@example.com")
    end

    it "works for a complicated case involving bad newlines and quote chars" do
      path = fixture_path(:dos_line_ending)

      import = subject.read(path)
      expect(import[0].count).to eq(9)
    end

    it "works for a hard case" do
      path = fixture_path(:accents_semicolon_windows_1252)

      import = subject.read(path)
      expect(import[0][1]).to eq("Jérome")
      expect(import[1][0]).to eq("Héloise")
    end

    it "deals with a long, challenging file (and quickly)" do
      start_time = Time.now
      path = fixture_path(:never_ordered)

      import = subject.read(path)

      expect(import[0].count).to eq(10)
      expect(import.count).to eq(32803)
      expect(Time.now).to be_within(5).of(start_time)
    end

    it "strips leading/trailing blank lines" do
      path = fixture_path(:trailing_leading_lines)

      import = subject.read(path)
      expect(import.first).not_to be_empty
      expect(import.last).not_to be_empty
    end
  end
end
