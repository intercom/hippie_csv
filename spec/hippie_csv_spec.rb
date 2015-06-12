require "spec_helper"
require "csv"

describe HippieCsv do

  context 'hard/encountered problem cases' do
    it 'works when a BOM is present in the file' do
      path = fixture_path(:with_byte_order_mark)
      expect { CSV.read(path) }.to raise_error(CSV::MalformedCSVError)

      import = HippieCsv.parse(path)
      expect(import[0]).to eq(["Name", "Email Address", "Date Added"])
    end

    it "works with a malformed CSV" do
      path = fixture_path(:malformed)
      expect { CSV.read(path) }.to raise_error(CSV::MalformedCSVError)

      import = HippieCsv.parse(path)
      expect(import[0]).to eq(%w(site lon lat max min precip snow snowdepth))
    end

    it "works with odd encoding & emoji!" do
      path = fixture_path(:encoding)
      expect { CSV.read(path) }.to raise_error(ArgumentError)

      import = HippieCsv.parse(path)
      expect(import[0].count).to eq(4)
    end

    it "works with an excel export" do
      path = fixture_path(:excel)

      import = HippieCsv.parse(path)
      expect(import[0].count).to eq(24)
    end

    it "works with escaped quotes" do
      path = fixture_path(:escaped_quotes)

      import = HippieCsv.parse(path)
      expect(import[0][1]).to eq("Lalo \"ElPapi\" Neymar")
      expect(import[0][2]).to eq("lalo@example.com")
    end

    it "works with an invalid escaped quotes case" do
      path = fixture_path(:escaped_quotes_semicolons)

      import = HippieCsv.parse(path)
      expect(import[0][0]).to eq("133")
      expect(import[0][1]).to eq("z3268856")
      expect(import[0][2]).to eq("stephen@example.com")
    end

    it "works for a complicated case involving bad newlines and quote chars" do
      path = fixture_path(:dos_line_ending)

      import = HippieCsv.parse(path)
      expect(import[0].count).to eq(9)
    end
  end
end
