# frozen_string_literal: true

begin
  require_relative "lib/ogrenci"
  require_relative "lib/devamsizlik_kontrol"
rescue LoadError
  require "./lib/ogrenci"
  require "./lib/devamsizlik_kontrol"
end

def cizgi
  puts "=" * 65
end

def ara_cizgi
  puts "-" * 65
end

cizgi
puts "     YZM379 · ÖĞRENCİ DEVAMSIZLIK VE DURUM KONTROL SİSTEMİ"
puts "                  (Ajan = Model + Harness Demo)"
cizgi

# Farklı durum ve devamsızlık senaryolarındaki örnek öğrenciler
ornek_ogrenciler = [
  Ogrenci.new(ad: "Ahmet Yılmaz",   durum: :aktif,      devamsizlik: 0),
  Ogrenci.new(ad: "Ayşe Kaya",      durum: :aktif,      devamsizlik: 2),
  Ogrenci.new(ad: "Mehmet Demir",   durum: :aktif,      devamsizlik: 3), # Sınır değeri (riskli)
  Ogrenci.new(ad: "Zeynep Çelik",   durum: :aktif,      devamsizlik: 4), # Kalan (riskli + kaldi)
  Ogrenci.new(ad: "Can Aksoy",      durum: :aktif,      devamsizlik: 5), # Bursu kesilen (+ burs_kesilir)
  Ogrenci.new(ad: "Deniz Arda",     durum: :aktif,      devamsizlik: 8), # Çoklu kural
  Ogrenci.new(ad: "Selin Öztürk",   durum: :donduruldu, devamsizlik: 6), # Dondurulmuş (Muaf)
  Ogrenci.new(ad: "Emre Yıldız",    durum: :mezun,      devamsizlik: 7)  # Mezun (Muaf)
]

puts sprintf("%-16s | %-12s | %-11s | %-18s", "ÖĞRENCİ ADI", "DURUM", "DEVAMSIZLIK", "UYGULANAN KURALLAR")
ara_cizgi

ornek_ogrenciler.each do |ogr|
  kurallar = DevamsizlikKontrol.durum(ogr)
  kurallar_metni = kurallar.empty? ? "[TEMİZ / MUAF]" : kurallar.map { |k| ":#{k}" }.join(", ")
  
  durum_bilgisi = if ogr.aktif?
                    "Aktif"
                  elsif ogr.donduruldu?
                    "Donduruldu"
                  elsif ogr.mezun?
                    "Mezun"
                  end

  puts sprintf("%-16s | %-12s | %-11d | %-18s", ogr.ad, durum_bilgisi, ogr.devamsizlik, kurallar_metni)
end

cizgi
puts "KURAL ÖZETİ:"
puts " • Devamsızlık >= 3 : :riskli (Tam 3 devamsızlık sınırdır)"
puts " • Devamsızlık >= 4 : :kaldi"
puts " • Devamsızlık >= 5 : :burs_kesilir (Özgün kural)"
puts " • Dondurulmuş veya Mezun öğrenciler devamsızlık kurallarına tabi tutulmaz."
cizgi
