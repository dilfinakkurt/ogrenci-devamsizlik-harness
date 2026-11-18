# frozen_string_literal: true

require "minitest/autorun"

begin
  require_relative "../lib/ogrenci"
  require_relative "../lib/devamsizlik_kontrol"
rescue LoadError
  # Windows üzerinde Türkçe/özel karakterli kullanıcı adlarında (örn. DİLFİN -> OEM kod sayfası)
  # require_relative yerine yerel göreli require kullanılır.
  require "./lib/ogrenci"
  require "./lib/devamsizlik_kontrol"
end

class OgrenciTest < Minitest::Test
  # 1. Varsayılan öğrenci oluşturma
  def test_varsayilan_ogrenci_degerleri
    ogr = Ogrenci.new(ad: "Ahmet")
    assert_equal "Ahmet", ogr.ad
    assert_equal :aktif, ogr.durum
    assert_equal 0, ogr.devamsizlik
  end

  # 2. Geçerli öğrenci durumları
  def test_gecerli_ogrenci_durumlari
    [:aktif, :donduruldu, :mezun].each do |gecerli_durum|
      ogr = Ogrenci.new(ad: "Zeynep", durum: gecerli_durum)
      assert_equal gecerli_durum, ogr.durum
    end
  end

  # 3. Geçersiz öğrenci durumu
  def test_gecersiz_ogrenci_durumu_hata_firlatir
    assert_raises(ArgumentError) do
      Ogrenci.new(ad: "Mehmet", durum: :bilinmeyen)
    end
  end

  # 4. Devamsızlık 0
  def test_devamsizlik_sifir_gecerlidir
    ogr = Ogrenci.new(ad: "Ali", devamsizlik: 0)
    assert_equal 0, ogr.devamsizlik
  end

  # 5. Devamsızlık 10
  def test_devamsizlik_on_gecerlidir
    ogr = Ogrenci.new(ad: "Fatma", devamsizlik: 10)
    assert_equal 10, ogr.devamsizlik
  end

  # 6. Negatif devamsızlık reddedilmeli
  def test_negatif_devamsizlik_hata_firlatir
    assert_raises(ArgumentError) do
      Ogrenci.new(ad: "Can", devamsizlik: -1)
    end
  end

  # 7. 10'dan fazla devamsızlık reddedilmeli
  def test_ondan_fazla_devamsizlik_hata_firlatir
    assert_raises(ArgumentError) do
      Ogrenci.new(ad: "Deniz", devamsizlik: 11)
    end
  end

  # 8. Yanlış veri türleri reddedilmeli
  def test_yanlis_veri_turleri_hata_firlatir
    assert_raises(ArgumentError) do
      Ogrenci.new(ad: 123)
    end

    assert_raises(ArgumentError) do
      Ogrenci.new(ad: "Ece", devamsizlik: "uc")
    end

    assert_raises(ArgumentError) do
      Ogrenci.new(ad: "Ece", devamsizlik: 3.5)
    end
  end

  # 9. define_method ile üretilen durum sorguları
  def test_durum_sorgulari
    ogr_aktif = Ogrenci.new(ad: "Kemal", durum: :aktif)
    assert ogr_aktif.aktif?
    refute ogr_aktif.donduruldu?
    refute ogr_aktif.mezun?

    ogr_donduruldu = Ogrenci.new(ad: "Selin", durum: :donduruldu)
    refute ogr_donduruldu.aktif?
    assert ogr_donduruldu.donduruldu?
    refute ogr_donduruldu.mezun?

    ogr_mezun = Ogrenci.new(ad: "Emre", durum: :mezun)
    refute ogr_mezun.aktif?
    refute ogr_mezun.donduruldu?
    assert ogr_mezun.mezun?
  end

  # 10. respond_to? metotların gerçekten tanımlandığını doğrular
  def test_respond_to_metotlarin_gercekligini_dogrular
    ogr = Ogrenci.new(ad: "Barış")
    assert_respond_to ogr, :aktif?
    assert_respond_to ogr, :donduruldu?
    assert_respond_to ogr, :mezun?
  end

  # 11. Bilinmeyen metot çağrısında NoMethodError
  def test_bilinmeyen_metot_nomethoderror_verir
    ogr = Ogrenci.new(ad: "Gizem")
    assert_raises(NoMethodError) do
      ogr.bilinmeyen_metot?
    end
  end

  # 12. 2 devamsızlıkta riskli olmaması
  def test_devamsizlik_2_ise_kural_listesi_bos_olmali
    ogr = Ogrenci.new(ad: "Oğuz", devamsizlik: 2)
    assert_empty DevamsizlikKontrol.durum(ogr)
  end

  # 13. Tam 3 devamsızlıkta riskli olması (Sınır testi)
  def test_devamsizlik_tam_3_ise_riskli_olmali
    ogr = Ogrenci.new(ad: "Burak", devamsizlik: 3)
    sonuc = DevamsizlikKontrol.durum(ogr)
    assert_includes sonuc, :riskli
    refute_includes sonuc, :kaldi
    refute_includes sonuc, :burs_kesilir
    assert_equal [:riskli], sonuc
  end

  # 14. 4 devamsızlıkta kalması
  def test_devamsizlik_4_ise_riskli_ve_kaldi_olmali
    ogr = Ogrenci.new(ad: "Hale", devamsizlik: 4)
    sonuc = DevamsizlikKontrol.durum(ogr)
    assert_includes sonuc, :riskli
    assert_includes sonuc, :kaldi
    refute_includes sonuc, :burs_kesilir
    assert_equal [:riskli, :kaldi], sonuc
  end

  # 15. 5 devamsızlıkta bursunun kesilmesi (Özgün kural)
  def test_devamsizlik_5_ise_burs_kesilir
    ogr = Ogrenci.new(ad: "Tuna", devamsizlik: 5)
    sonuc = DevamsizlikKontrol.durum(ogr)
    assert_includes sonuc, :riskli
    assert_includes sonuc, :kaldi
    assert_includes sonuc, :burs_kesilir
    assert_equal [:riskli, :kaldi, :burs_kesilir], sonuc
  end

  # 16. Kuralların birden fazla koşulu aynı anda sağladığı durumlar
  def test_coklu_kural_eslesmesi
    ogr = Ogrenci.new(ad: "Melis", devamsizlik: 7)
    sonuc = DevamsizlikKontrol.durum(ogr)
    assert_equal [:riskli, :kaldi, :burs_kesilir], sonuc
  end

  # 17. Mezun ve dondurulmuş öğrencilerin devamsızlık kurallarına tabi olmaması
  def test_mezun_ve_dondurulan_ogrenciler_kurallara_tabi_degildir
    ogr_donduruldu = Ogrenci.new(ad: "Kaan", durum: :donduruldu, devamsizlik: 6)
    assert_empty DevamsizlikKontrol.durum(ogr_donduruldu)

    ogr_mezun = Ogrenci.new(ad: "Aslı", durum: :mezun, devamsizlik: 8)
    assert_empty DevamsizlikKontrol.durum(ogr_mezun)
  end
end
