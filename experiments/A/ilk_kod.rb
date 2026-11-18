# frozen_string_literal: true

# Öğrenci Devamsızlık Kontrol Sistemi
# Devamsızlık Sınırı: %30

class Ogrenci
  attr_reader :id, :ad_soyad, :toplam_ders_saati, :devamsizlik_saati, :not_ortalamasi

  DEVAMSIZLIK_SINIRI_YUZDESI = 30.0 # Devamsızlık sınırı %30
  RISK_ESIGI_YUZDESI = 20.0          # %20 ve üzeri kritik / riskli bölge

  def initialize(id:, ad_soyad:, toplam_ders_saati:, devamsizlik_saati:, not_ortalamasi: 70.0)
    @id = id
    @ad_soyad = ad_soyad
    @toplam_ders_saati = toplam_ders_saati.to_f
    @devamsizlik_saati = devamsizlik_saati.to_f
    @not_ortalamasi = not_ortalamasi.to_f
  end

  # Devamsızlık yüzdesi hesaplama
  def devamsizlik_orani
    return 0.0 if @toplam_ders_saati <= 0
    (@devamsizlik_saati / @toplam_ders_saati) * 100.0
  end

  # Devamsızlık sınırının aşılıp aşılmadığı (%30 üstü)
  def devamsizlik_sinirini_asti_mi?
    devamsizlik_orani > DEVAMSIZLIK_SINIRI_YUZDESI
  end

  # Devamsızlık oranına göre risk durumu kontrolü (%20 ile %30 arası)
  def riskli_mi?
    devamsizlik_orani >= RISK_ESIGI_YUZDESI && !devamsizlik_sinirini_asti_mi?
  end

  # Öğrencinin sınıfı geçip geçmediği kontrolü
  # Devamsızlık sınırı aşıldıysa not ne olursa olsun kalır
  def sinifi_gecti_mi?
    return false if devamsizlik_sinirini_asti_mi?

    @not_ortalamasi >= 50.0
  end

  # Durum metni
  def durum_aciklamasi
    if devamsizlik_sinirini_asti_mi?
      "KALDI (Devamsızlık sınırı %#{DEVAMSIZLIK_SINIRI_YUZDESI.to_i} aşıldı)"
    elsif riskli_mi?
      "RİSKLİ / UYARI (Devamsızlık oranı sınıra yaklaşıyor)"
    else
      "GÜVENLİ (Devamsızlık oranı kabul edilebilir düzeyde)"
    end
  end

  def rapor
    oran = devamsizlik_orani.round(2)
    risk_metni = if devamsizlik_sinirini_asti_mi?
                   "LİMİT AŞILDI (Devamsızlıktan Kaldı)"
                 elsif riskli_mi?
                   "EVET (Riskli - Kritik Eşik Aşıldı)"
                 else
                   "HAYIR (Güvenli Bölge)"
                 end

    gecme_metni = sinifi_gecti_mi? ? "GEÇTİ" : "KALDI"

    <<~RAPOR
      --------------------------------------------------
      Öğrenci No        : #{@id}
      Ad Soyad          : #{@ad_soyad}
      Toplam Ders Saati : #{@toplam_ders_saati.to_i}
      Devamsızlık Saati : #{@devamsizlik_saati.to_i}
      Devamsızlık Oranı : %#{oran}
      Risk Durumu       : #{risk_metni}
      Devamsızlık Analizi: #{durum_aciklamasi}
      Not Ortalaması    : #{@not_ortalamasi}
      Sınıfı Geçti mi?  : #{gecme_metni}
      --------------------------------------------------
    RAPOR
  end
end

class DevamsizlikTakipSistemi
  def initialize
    @ogrenciler = []
  end

  def ogrenci_ekle(ogrenci)
    @ogrenciler << ogrenci
  end

  def toplu_rapor_yazdir
    puts "=================================================="
    puts "      ÖĞRENCİ DEVAMSIZLIK KONTROL SİSTEMİ         "
    puts "         (Devamsızlık Sınırı: %#{Ogrenci::DEVAMSIZLIK_SINIRI_YUZDESI.to_i})         "
    puts "=================================================="

    @ogrenciler.each do |ogrenci|
      puts ogrenci.rapor
    end

    ozet_istatistikler
  end

  def ozet_istatistikler
    toplam = @ogrenciler.size
    kalanlar = @ogrenciler.count { |o| !o.sinifi_gecti_mi? }
    gecenler = @ogrenciler.count(&:sinifi_gecti_mi?)
    risktekiler = @ogrenciler.count(&:riskli_mi?)
    devamsizliktan_kalanlar = @ogrenciler.count(&:devamsizlik_sinirini_asti_mi?)

    puts "GENEL İSTATİSTİK ÖZETİ:"
    puts "  Toplam Öğrenci Sayısı        : #{toplam}"
    puts "  Sınıfı Geçen Öğrenci Sayısı  : #{gecenler}"
    puts "  Sınıfta Kalan Öğrenci Sayısı : #{kalanlar}"
    puts "  Devamsızlıktan Kalanlar      : #{devamsizliktan_kalanlar}"
    puts "  Risk Altındaki Öğrenciler    : #{risktekiler}"
    puts "=================================================="
  end
end

# Çalıştırma / Demo
if __FILE__ == $PROGRAM_NAME
  sistem = DevamsizlikTakipSistemi.new

  # Farklı senaryoları test etmek için örnek öğrenciler (100 ders saati üzerinden)
  sistem.ogrenci_ekle(Ogrenci.new(id: "101", ad_soyad: "Ahmet Yılmaz", toplam_ders_saati: 100, devamsizlik_saati: 10, not_ortalamasi: 85))
  sistem.ogrenci_ekle(Ogrenci.new(id: "102", ad_soyad: "Ayşe Kaya",    toplam_ders_saati: 100, devamsizlik_saati: 22, not_ortalamasi: 75))
  sistem.ogrenci_ekle(Ogrenci.new(id: "103", ad_soyad: "Mehmet Demir", toplam_ders_saati: 100, devamsizlik_saati: 29, not_ortalamasi: 65))
  sistem.ogrenci_ekle(Ogrenci.new(id: "104", ad_soyad: "Zeynep Çelik", toplam_ders_saati: 100, devamsizlik_saati: 35, not_ortalamasi: 92))
  sistem.ogrenci_ekle(Ogrenci.new(id: "105", ad_soyad: "Can Aksoy",    toplam_ders_saati: 100, devamsizlik_saati: 15, not_ortalamasi: 40))

  sistem.toplu_rapor_yazdir
end
