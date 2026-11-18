# CLAUDE.md (AGENTS.md İkizi / Referansı)
# Windows ortamında yönetici ayrıcalığı olmadan symlink oluşturulamadığı için bu dosya AGENTS.md içeriğini yansıtmaktadır.
@AGENTS.md

## Çalışma Ortamı
- Ruby sürümü: 3.4 (.ruby-version dosyası '3.4' içermeli).
- Yalnızca Ruby standart kütüphanesi ve Minitest kullanılacak. Harici gem yasak.

## Mimari ve Kod Sözleşmesi
- `lib/ogrenci.rb`: `Ogrenci` sınıfı `ad:`, `durum: :aktif`, `devamsizlik: 0` keyword argümanlarını alır.
- `devamsizlik`: 0 ile 10 arasında Integer olmalıdır; aralık dışı değerler `ArgumentError`, yanlış tipler `TypeError` veya `ArgumentError` fırlatmalıdır.
- `durum`: `:aktif`, `:donduruldu`, `:mezun` sembolleri kabul edilir; geçersiz durumlarda `ArgumentError` fırlatılmalıdır.
- Özellikler `attr_reader` ile dışa açılır.
- Durum sorguları (`aktif?`, `donduruldu?`, `mezun?`) `define_method` ile dinamik olarak tanımlanmalıdır.
- `method_missing` ve `respond_to_missing?` kesinlikle yasaktır. Bilinmeyen metotlarda doğal `NoMethodError` oluşmalıdır.
- Standart Ruby sınıflarına monkey patch yapılması kesinlikle yasaktır.
- `lib/devamsizlik_kontrol.rb`: `DevamsizlikKontrol` açık sınıfında `KURALLAR` Hash ve lambda bloklarıyla tutulur.

## Alan Kuralları
- `riskli`: Devamsızlık tam 3 veya daha fazlaysa (`ogr.devamsizlik >= 3`).
- `kaldi`: Devamsızlık 4 veya daha fazlaysa (`ogr.devamsizlik >= 4`).
- `burs_kesilir`: Devamsızlık 5 veya daha fazlaysa (`ogr.devamsizlik >= 5`).
- Sadece `:aktif` öğrenciler devamsızlık değerlendirmesine tabi tutulur; `:donduruldu` veya `:mezun` öğrenciler için boş dizi `[]` döndürülür.
- `DevamsizlikKontrol.durum(ogr)` şartları sağlayan kural sembollerini dizi (`Array`) olarak döndürür.

## Test ve Doğrulama
- Test komutu: `ruby test/ogrenci_test.rb` (Minitest).
- Kod değişikliklerinden sonra mutlaka `bin/kontrol` çalıştırılacaktır.
- Testler başarısızsa işlem tamamlanmış sayılmaz.
