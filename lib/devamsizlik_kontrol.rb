# frozen_string_literal: true

class DevamsizlikKontrol
  KURALLAR = {
    riskli: ->(ogr) { ogr.devamsizlik >= 3 },
    kaldi: ->(ogr) { ogr.devamsizlik >= 4 },
    burs_kesilir: ->(ogr) { ogr.devamsizlik >= 5 }
  }.freeze

  def self.durum(ogr)
    return [] unless ogr.aktif?

    KURALLAR.select { |_kural, kosul| kosul.call(ogr) }.keys
  end
end
