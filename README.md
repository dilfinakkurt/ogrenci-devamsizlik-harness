# YZM379 · İleri Ruby ve Harness: Öğrenci Devamsızlık ve Durum Kontrol Sistemi

> **"Sihir senin, dizgin harness'ın. Ajan = Model + Harness."**  
> Samsun Üniversitesi · Yazılım Mühendisliği Bölümü · YZM379 İleri Ruby ve Harness Dersi Ödevi

[![Testler ve Dogrulama (CI)](https://github.com/dilfinakkurt/ogrenci-devamsizlik-harness/actions/workflows/ci.yml/badge.svg)](https://github.com/dilfinakkurt/ogrenci-devamsizlik-harness/actions/workflows/ci.yml)

---

## 1. Proje Başlığı ve Tanımı
Bu proje, Samsun Üniversitesi Yazılım Mühendisliği Bölümü YZM379 İleri Ruby ve Harness dersi kapsamında geliştirilmiştir. Projenin ana odağı sadece çalışan bir Ruby programı yazmak değil; modern yapay zekâ yazılım mühendisliğinde **Ajan = Model + Harness** yaklaşımını pratik, ölçülebilir ve kanıtlanabilir bir deneyle ortaya koymaktır.

Proje kapsamında öğrencilerin devamsızlık durumlarını inceleyen bir kural motoru geliştirilmiş; rehbersiz ham koşu (**A Koşusu**), hataların kalıcı kural ve sensörlere dönüştürüldüğü aşama (**Ratchet**) ve harness destekli koşu (**B Koşusu**) gerçekleştirilerek gerçek metriklerle kıyaslanmıştır.

---

## 2. Projenin Amacı
1. **Açık, Sade ve Aranabilir Ruby:** Kod tabanında gizli sihirler (`method_missing`, monkey patch) yerine grep ile taranabilir açık servisler ve `define_method` kullanımı sağlamak.
2. **Rehber (AGENTS.md):** Proje kural ve sözleşmelerini yapay zekâ ajanına her turda açıkça bildirerek niyet sapmalarını önlemek.
3. **Sensör (Minitest):** Sınır değerleri (`>= 3`, `>= 4`, `>= 5`) ve tip kontrollerini tavizsiz yakalayan birim test ağı kurmak.
4. **Otomasyon (bin/kontrol):** Test kontrolünü insan gözüne bırakmadan otomatik kanca ile yürütmek.
5. **Ratchet (Mandal) Mekanizması:** Gözlemlenen her hatayı kalıcı bir kurala (`AGENTS.md`) ve sensör testine (`test/ogrenci_test.rb`) dönüştürerek aynı hatanın tekrarını engellemek.
6. **Gerçekçi Ölçüm:** Yapılmamış deney veya uydurma token/maliyet değerleri üretmeden, sistemin gerçek çalışma loglarından elde edilen verilerle A ve B koşularını karşılaştırmak.

---

## 3. Kullanılan Teknolojiler
- **Programlama Dili:** Ruby 3.4.12 (`ruby 3.4.12 (2026-10-23 revision 366f5fdc00) +PRISM [x64-mingw-ucrt]`)
- **Test Çerçevesi:** Minitest 5.25.4 (Ruby Standart Kütüphanesi ile birlikte gelen sürüm)
- **Paket Bağımlılığı:** Harici hiçbir gem veya 3. parti paket kullanılmamıştır.
- **Doğrulama Kancaları:** Shell Script (`bin/kontrol`), Windows Batch (`bin/kontrol.bat`), PowerShell (`bin/kontrol.ps1`)
- **İşletim Sistemi / Ortam:** Windows 11, PowerShell, Windows CMD

---

## 4. Proje Klasör Yapısı

```text
ogrenci-devamsizlik-harness/
│
├── .ruby-version             # Ruby sürüm kısıtı: '3.4'
├── AGENTS.md                 # Yapay zekâ ajanı için tek talimat rehberi
├── CLAUDE.md                 # AGENTS.md ikizi / aynası (Windows symlink alternatifi)
├── README.md                 # Ayrıntılı proje dokümantasyonu ve ölçüm raporu
├── RATCHET_LOG.md            # A'dan B'ye hata-mandal dönüşüm günlüğü
│
├── lib/
│   ├── ogrenci.rb            # Ogrenci modeli ve define_method durum sorguları
│   └── devamsizlik_kontrol.rb# DevamsizlikKontrol kural motoru (Hash ve lambda blokları)
│
├── test/
│   └── ogrenci_test.rb       # Minitest sensörleri (17 test, 55 assertion)
│
├── bin/
│   ├── kontrol               # Linux / Git Bash / macOS uyumlu doğrulama betiği
│   ├── kontrol.bat           # Windows CMD uyumlu doğrulama betiği
│   └── kontrol.ps1           # PowerShell uyumlu doğrulama betiği
│
└── experiments/
    ├── A/                    # Rehbersiz Ham Koşu (Ham Prompt)
    │   ├── ilk_kod.rb        # Ajanın ilk denemede ürettiği ham kod
    │   ├── sonuc.log         # A koşusunun terminal çalıştırma çıktısı
    │   └── olcum.json        # A koşusu gerçek log metrikleri
    │
    └── B/                    # Harness Destekli Koşu (AGENTS.md + Sensör)
        ├── sonuc.log         # B koşusu Minitest ve bin/kontrol çıktısı
        └── olcum.json        # B koşusu gerçek log metrikleri
```

---

## 5. Kurulum
Proje harici bir gem bağımlılığı içermemektedir. Ruby 3.4 kurulu bir ortamda doğrudan çalıştırılabilir:

```bash
# Ruby sürümünü doğrulayın
ruby -v

# Proje dizinine gidin
cd ogrenci-devamsizlik-harness
```

---

## 6. Ruby Sürüm Kontrolü
Ders sözleşmesi gereği projenin kök dizininde bulunan `.ruby-version` dosyası tam olarak `3.4` içermektedir:

```bash
cat .ruby-version
# Çıktı: 3.4
```

---

## 7. Uygulamanın Çalıştırılması

Uygulamanın görsel tablo çıktısını doğrudan terminalde görmek için hazır demo betiğini çalıştırabilirsiniz:

```bash
ruby main.rb
```

Ayrıca sınıfları etkileşimli kabukta (`irb`) veya kendi Ruby betiğinizde kullanmak için:

```ruby
require_relative "lib/ogrenci"
require_relative "lib/devamsizlik_kontrol"

# Öğrenci tanımlama (keyword argümanlar ile)
ogr1 = Ogrenci.new(ad: "Ahmet Yılmaz", durum: :aktif, devamsizlik: 3)
ogr2 = Ogrenci.new(ad: "Ayşe Kaya", durum: :aktif, devamsizlik: 5)
ogr3 = Ogrenci.new(ad: "Mehmet Demir", durum: :donduruldu, devamsizlik: 6)

# Durum sorguları (define_method ile dinamik)
puts ogr1.aktif?       # => true
puts ogr3.donduruldu?  # => true

# Devamsızlık kuralları değerlendirmesi
puts DevamsizlikKontrol.durum(ogr1).inspect # => [:riskli]
puts DevamsizlikKontrol.durum(ogr2).inspect # => [:riskli, :kaldi, :burs_kesilir]
puts DevamsizlikKontrol.durum(ogr3).inspect # => [] (Aktif olmadığı için kurallara tabi değildir)
```

---

## 8. Testlerin Çalıştırılması

Tüm birim testleri Minitest sensörleri ile koşturmak için:

### Standart Test Komutu:
```bash
ruby test/ogrenci_test.rb
```

### Otomatik Doğrulama Kancası (bin/kontrol):
- **Linux / Git Bash / macOS:**
  ```bash
  sh bin/kontrol
  # veya
  ./bin/kontrol
  ```
- **Windows (CMD / PowerShell):**
  ```cmd
  bin\kontrol.bat
  ```

Çalıştırma sonucunda tüm testlerin yeşil olduğu doğrulanır:
```text
Run options: --seed 12333

# Running:

.................

Finished in 0.001916s, 8872.6514 runs/s, 28705.6367 assertions/s.

17 runs, 55 assertions, 0 failures, 0 errors, 0 skips
```

---

## 9. Devamsızlık Kuralları ve Alan Tasarımı

Kurallar `DevamsizlikKontrol::KURALLAR` Hash yapısında lambda blokları olarak tutulur:

1. **`riskli` Kuralı:** Devamsızlık tam 3 veya daha fazlaysa tetiklenir (`ogr.devamsizlik >= 3`). Tam 3 devamsızlığı olan öğrenci riskli kabul edilir.
2. **`kaldi` Kuralı:** Devamsızlık 4 veya daha fazlaysa tetiklenir (`ogr.devamsizlik >= 4`).
3. **Özgün Kural (`burs_kesilir`):** Devamsızlık 5 veya daha fazlaysa tetiklenir (`ogr.devamsizlik >= 5`).
4. **Çoklu Kural Eşleşmesi:** Bir öğrenci 5 devamsızlığa ulaştığında her üç şartı da sağladığından `[:riskli, :kaldi, :burs_kesilir]` dizisi döndürülür.
5. **Akademik Durum Tasarım Kararı:**
   - **Tasarım:** Sadece `:aktif` durumdaki öğrenciler devamsızlık değerlendirmesine tabi tutulur. Durumu `:donduruldu` veya `:mezun` olan öğrenciler için kural motoru boş dizi `[]` döndürür.
   - **Gerekçe:** Kaydı dondurulmuş bir öğrenci dönem derslerine devam etmekle yükümlü değildir; dolayısıyla devamsızlık nedeniyle dersten kalması veya bursunun bu aşamada kesilmesi akademik ve mantıksal açıdan hatalıdır. Benzer şekilde mezun olmuş bir öğrenci için devamsızlık takibi anlamsızdır. Bu durum `test/ogrenci_test.rb` dosyasında `test_mezun_ve_dondurulan_ogrenciler_kurallara_tabi_degildir` testi ile güvenceye alınmıştır.

---

## 10. A/B Koşusu ve Ölçüm Raporu

Deney ortamı Antigravity subagent altyapısında gerçek iki bağımsız oturum açılarak koşturulmuştur. Metrikler arka plan görev kayıtlarından (`transcript.jsonl`) doğrudan okunmuş, tahmini veya yapay hiçbir sayı kullanılmamıştır.

### A/B Karşılaştırma Tablosu

| Metrik | A Koşusu (Rehbersiz Ham Koşu) | B Koşusu (Harness Destekli Koşu) |
|---|---|---|
| **Kullanılan Model** | Google Gemini 3.8 Flash (`gemini-3.8-flash-tiered`) | Google Gemini 3.8 Flash (`gemini-3.8-flash-tiered`) |
| **Verilen Talimat** | Yalnızca genel prompt (Rehbersiz, testsiz) | `AGENTS.md` + Minitest Test Dosyası + `bin/kontrol` |
| **Tur Sayısı (num_turns)** | 7 | 43 |
| **İlk Denemede Hata Sayısı** | 6 majör gereksinim hatası | 0 sözleşme hatası (1 ortam karakter hatası) |
| **Toplam Düzeltme Sayısı** | 0 (Düzeltme yapacak sensör verilmedi) | 2 (Dosya yolu ve Windows terminal kodlama adaptasyonu) |
| **Girdi Tokenı (input_tokens)** | 30.138 | 119.449 |
| **Çıktı Tokenı (output_tokens)** | 6.637 | 12.181 |
| **Sabit Bağlam (cache_read)** | 83.546 | 1.203.676 |
| **Süre (saniye)** | 80,0 sn (~1 dk 20 sn) | 435,0 sn (~7 dk 15 sn) |
| **Toplam Maliyet ($)** | Ölçülemedi (API hesabı doğrudan faturalandırılmadı) | Ölçülemedi (API hesabı doğrudan faturalandırılmadı) |
| **Test Sonucu** | Test yok (0 test, geçersiz mimari) | **17 runs, 55 assertions, 0 failures, 0 skips** |

---

### Ölçüm Soruları ve Analitik Yanıtlar

#### 1. Harness kullanımı hata sayısını azalttı mı?
**Evet, dramatik şekilde sıfıra indirdi.**  
A koşusunda ajana herhangi bir rehber verilmediğinde, ajan tamamen kendi ezberine dayanarak alakasız bir `DevamsizlikTakipSistemi` sınıfı uydurmuş, `> 30.0` kullanarak sınır değerini kaçırmış, `define_method` kullanmamış ve tip kontrollerini göz ardı etmiştir. B koşusunda ise `AGENTS.md` ve Minitest sensörleri sayesinde 17 test senaryosunun tamamını ilk kod yazımında eksiksiz karşılamıştır.

#### 2. AGENTS.md girdi tokenını artırdı mı?
**Evet, artırdı.**  
A koşusunda toplam girdi tokenı 30.138 iken, B koşusunda 119.449'a çıkmıştır. Bunun iki somut sebebi vardır:
1. `AGENTS.md` ve `test/ogrenci_test.rb` dosyalarının ajanın bağlamına (context window) yüklenmesi her adımda taban token miktarını artırmıştır.
2. B koşusunda ajan testleri terminalde çalıştırıp çıktıları okuduğu için test çalıştırma raporları girdi bağlamına eklenmiştir. Ancak bu token maliyeti, yazılımın %100 doğru ve doğrulanabilir üretilmesini sağlamıştır.

#### 3. Testler hataları hangi aşamada yakaladı?
**Kod yazımı biter bitmez ilk test yürütme aşamasında.**  
B koşusunda ajan `lib/ogrenci.rb` ve `lib/devamsizlik_kontrol.rb` dosyalarını oluşturduktan sonra `ruby test/ogrenci_test.rb` komutunu çalıştırdığında, testler anında devreye girmiştir. Kodun ilk yazımında hiçbir mantıksal test hatası çıkmamış (`17 runs, 55 assertions, 0 failures`), yalnızca Windows ortamındaki Türkçe karakterli dizin yolu (`DİLFİN`) ile ilgili require kontrolü yapılmış ve doğrulanmıştır.

#### 4. B koşusunda ajanın aynı hataları yapması engellendi mi?
**Evet, istisnasız tüm hatalar engellendi.**  
- A koşusundaki `> 30.0` sınır hatası, B koşusunda `>= 3` olarak kilitlenmiştir.
- A koşusunda unutulan `define_method`, B koşusunda `GECERLI_DURUMLAR.each { |d| define_method("#{d}?") ... }` şeklinde eksiksiz uygulanmıştır.
- A koşusunda yazılmayan `burs_kesilir` kuralı ve Hash/lambda yapısı B koşusunda eksiksiz kurulmuştur.

#### 5. Harness'ın avantajları ve maliyetleri nelerdi?
- **Avantajlar:** İnsan denetimine ihtiyaç duymadan sıfır hata ile üretim, tam test güvencesi, projenin sınır değerlerde beklenmedik sürprizler üretmemesi ve aranabilir temiz kod.
- **Maliyetler:** Tur sayısının (7'den 43'e) ve girdi tokenının artması, ajanın dosyaları okuyup testleri koşturmasından kaynaklanan ek süre (80 saniyeden 435 saniyeye).

---

## 11. Ratchet (Mandal) Yaklaşımı
Ratchet prensibi şudur: *"Aynı hata ikinci kez olursa harness'ın hatasıdır, ajanın değil."*

Bir ajanın hata yapması doğaldır; ancak bu hata fark edildiğinde yalnızca o anlık düzeltilip bırakılırsa bir sonraki koşuda model aynı hatayı tekrarlar. Ratchet yaklaşımı hatayı iki taraflı kilitler:
1. **Rehber Tarafı (AGENTS.md):** Kuralı ajanın anlayacağı kesin ve kısa bir dille talimata ekler (*"Devamsızlık tam 3 olduğunda riskli kabul edilir (>= 3)"*).
2. **Sensör Tarafı (Minitest):** Kuralı zorlayıcı bir sınır testiyle kilitler (*`assert_includes DevamsizlikKontrol.durum(ogr_3), :riskli`*).

Bu iki katman birleştiğinde model hata yapsa bile sensör kodu teslim etmesine izin vermez; ajan turunu bitirmeden önce hatayı düzeltmek zorunda kalır.

---

## 12. Teknik Tasarım Kararları

### 1. `define_method` Tercihi
Öğrencinin durum sorguları (`aktif?`, `donduruldu?`, `mezun?`) sonlu ve bilinen bir kümedir (`[:aktif, :donduruldu, :mezun]`). Bu metotlar `define_method` ile dinamik olarak tanımlanmıştır:
- Metotlar `instance_methods` listesinde görünür.
- `respond_to?(:aktif?)` doğru şekilde `true` döner.
- Grep ile arandığında `define_method` tanım noktası açıkça bulunur.

### 2. Açık Servis ve Hash/Lambda Kuralları
Kurallar karmaşık DSL veya `instance_eval` gibi gizli bağlam değiştiren yapılar yerine açık bir Hash içinde lambda blokları olarak tutulmuştur:
```ruby
KURALLAR = {
  riskli: ->(ogr) { ogr.devamsizlik >= 3 },
  kaldi: ->(ogr) { ogr.devamsizlik >= 4 },
  burs_kesilir: ->(ogr) { ogr.devamsizlik >= 5 }
}.freeze
```
Bu tasarım hem insan geliştirici hem de yapay zekâ ajanı için en okunaklı, genişletilebilir ve yan etkisiz Ruby yapısıdır.

---

## 13. Yasaklanan Ruby Yaklaşımları

1. **`method_missing` ve `respond_to_missing?` Yasağı:**
   - *Neden Yasak:* Bilinmeyen bir metot çağrıldığında sessizce yakalanması yazım hatalarını gizler (`mezn?` çağrısı sessizce `false` döner), ajan hatayı asla anlayamaz. Bu projede bilinmeyen metotlar doğal `NoMethodError` fırlatır.
2. **Monkey Patch Yasağı:**
   - *Neden Yasak:* `Date`, `Integer` veya `Object` gibi standart Ruby sınıflarına metot yamamak, kodun kaynağını belirsizleştirir ve projeyi okuyan ajanın bağlam maliyetini fırlatır.
3. **Gereksiz DSL ve Metaprogramlama:**
   - *Neden Yasak:* `instance_eval` veya harici gemlerle karmaşık kural dilleri üretmek yerine düz bloklar ve lambda yapıları tercih edilmiştir.

---

## 14. Yapamadıklarım (Ortam Kısıtları ve Dürüst Bildirimler)

Ödev ilkeleri doğrultusunda yapılamayan veya ortam kısıtları nedeniyle alternatif çözümlere gidilen noktalar dürüstçe aşağıda listelenmiştir:

1. **Windows Üzerinde Sembolik Bağ (Symlink) Kısıtı:**
   - `CLAUDE.md` dosyasının `AGENTS.md` dosyasına sembolik bağ (`mklink` veya `ln -s`) ile bağlanması Windows ortamında Yönetici (Administrator) izni gerektirmektedir. Yönetici yetkisi olmadan symlink oluşturulamadığı için ders slaytında (Slayt 9) önerilen alternatif uygulanmış; `CLAUDE.md` içine `@AGENTS.md` referansı ve kuralların tam kopyası eklenmiştir.
2. **Windows OEM Kod Sayfası ve Türkçe Karakter Uyumsuzluğu:**
   - Windows PowerShell ve CMD varsayılan olarak Türkçe sistemlerde OEM 857 kod sayfasını kullanır. Bu durum kullanıcı adı klasöründeki `İ` harfinin (`C:\Users\DİLFİN\...`) Ruby'nin ANSI dosya sistemi API'lerinde `D?LF?N` şeklinde çözülmesine ve `require_relative` fonksiyonunun `LoadError` fırlatmasına neden olmuştur.
   - **Kalıcı Çözüm (Ratchet):** `test/ogrenci_test.rb` içerisine `rescue LoadError` koruması eklenerek yerel göreli `require "./lib/..."` mekanizması devreye sokulmuş, `bin/kontrol.bat` içine ise otomatik `chcp 65001` (UTF-8) kod sayfası geçişi eklenmiştir. Artık her iki ortamda da testler hatasız çalışmaktadır.
3. **PowerShell Script Yürütme İlkesi (ExecutionPolicy):**
   - Windows PowerShell varsayılan olarak `.ps1` betiklerinin çalıştırılmasını engellemektedir (`Restricted ExecutionPolicy`). Bu nedenle `bin/kontrol.ps1` doğrudan çalıştırıldığında yetki hatası vermektedir. Yerine Windows ortamında sıfır kısıtla çalışan `bin/kontrol.bat` hazırlanmış ve testler başarıyla doğrulanmıştır.
3. **Maliyetin ($) Doğrudan Hesaplanamaması:**
   - Çalışma ortamındaki API katmanı doğrudan dolar bazlı bir fatura veya harcama çıktısı üretmediği için toplam maliyet tahmin edilmemiş, ödev talimatına uygun şekilde "Ölçülemedi" olarak raporlanmıştır.
4. **Git CLI Bağımlılığı:**
   - Yerel makinede Git CLI kurulu olmadığı ve kurulum yönetici onayı gerektirdiği için Git commit/push adımları ajan tarafından doğrudan çalıştırılamamış; öğrencinin kendi terminalinde çalıştırabilmesi için gerekli Git komutları dokümana eklenmiştir.

---

## 15. Sonuç ve Değerlendirme
Bu çalışma, modern yapay zekâ destekli yazılım mühendisliğinde en kritik bileşenin modelin kendisinden ziyade onu çevreleyen **Harness** olduğunu somut verilerle kanıtlamıştır:

1. Aynı model (`Gemini 3.8 Flash`), harnessesız çalıştırıldığında (A Koşusu) hatalı sınır koşulları ve gereksinim dışı bir mimari üretmiştir.
2. Doğru tasarlanmış bir rehber (`AGENTS.md`) ve tavizsiz bir sensör (`Minitest`) ile desteklendiğinde (B Koşusu), model ilk denemede 17 testin tamamını geçiren profesyonel, aranabilir ve hatasız bir Ruby kodu ortaya koymuştur.
3. Ratchet günlüğü sayesinde yapılan hiçbir hata unutulmamış, kalıcı bir kalite güvence mekanizmasına dönüştürülmüştür.
