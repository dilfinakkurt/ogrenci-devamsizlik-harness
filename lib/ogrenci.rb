# frozen_string_literal: true

class Ogrenci
  GECERLI_DURUMLAR = [:aktif, :donduruldu, :mezun].freeze

  attr_reader :ad, :durum, :devamsizlik

  def initialize(ad:, durum: :aktif, devamsizlik: 0)
    raise ArgumentError, "Ad String olmalıdır" unless ad.is_a?(String)
    raise ArgumentError, "Geçersiz durum: #{durum}" unless GECERLI_DURUMLAR.include?(durum)
    raise ArgumentError, "Devamsızlık Integer olmalıdır" unless devamsizlik.is_a?(Integer)
    raise ArgumentError, "Devamsızlık 0 ile 10 arasında olmalıdır" unless devamsizlik.between?(0, 10)

    @ad = ad
    @durum = durum
    @devamsizlik = devamsizlik
  end

  GECERLI_DURUMLAR.each do |durum_adi|
    define_method("#{durum_adi}?") do
      @durum == durum_adi
    end
  end
end
