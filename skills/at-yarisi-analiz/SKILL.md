---
name: at-yarisi-analiz
description: At yarışı tahmin ve analiz standartları (form trendi, sınıf değişimi, zemin uyumu, jokey/at-jokey istatistiği, AGF-value, koşu karakteri, kupon stratejisi). Kullanıcı at yarışı tahmini, koşu analizi, altılı/kupon stratejisi, jokey-antrenör değerlendirmesi, banko/sürpriz seçimi veya yarış yorumu istediğinde MUTLAKA bu skill'i kullan. "Tahmin yap", "bu koşuyu analiz et", "altılı kur", "banko var mı", "sürpriz aday", "jokey analizi", "zemin etkisi" gibi ifadeler geçtiğinde de kullan. Deterministik skorlama + veriye dayalı yorum ilkesiyle, uydurma istatistik içermeyen analizler üretir.
---

# At Yarışı Analiz Standartları

## 0. Temel İlke: Skor Motordan, Yorum Veriden

Bu skill LLM'e skorlama YAPTIRMAZ. Sayısal tahmin her zaman projenin
deterministik skorlama motorundan gelir; LLM'in görevi motor çıktısını
gerçek veriyle YORUMLAMAK ve strateji önermektir (bkz. ai-report skill'i —
aynı ilkenin at yarışı uygulaması).

Üç mutlak kural:

1. **Uydurma istatistik yasak.** Jokey/antrenör/at hakkında yüzde, oran
   veya "güçlü/zayıf" hükmü ancak veritabanı sorgusuna dayanıyorsa yazılır.
   Ezberden isim, ezberden yüzde YAZILMAZ. Hangi tablo/view'ın
   kullanılacağı projenin CLAUDE.md'sinde tanımlıdır.
2. **Veri yoksa "veri yetersiz" denir.** Boşluk genel at yarışı bilgisiyle
   doldurulmaz. Az veri (ör. 3'ten az ortak koşu) varsa istatistik verilir
   ama örneklem küçüklüğü açıkça belirtilir.
3. **Kesinlik dili yasak.** "Kazanır" değil "öne çıkıyor", "şansı yüksek
   görünüyor", "tabela adayı". Her tahmin çıktısının sonunda sorumluluk
   reddi zorunlu (metin projenin CLAUDE.md'sinde).

## 1. Standart Analiz Akışı (Koşu Başına)

Sırayla, her adımda kaynağı belirterek:

1. **Koşu bağlamı:** mesafe, pist türü, zemin durumu (varsa), koşu cinsi,
   kayıtlı at sayısı.
2. **Motor skorları:** ilk 4-5 at, ham skor + bileşen değerleri. Motor
   sıralaması analizin omurgasıdır; LLM sıralamayı DEĞİŞTİRMEZ, zenginleştirir.
3. **Form trendi:** son 5-6 koşunun sadece dereceleri değil YÖNÜ:
   - Yükselen (5-3-2 gibi iyileşme) → güçlü işaret
   - Stabil (2-3-2-4) → güvenilir, plase profili
   - Düşen (1-4-7) → skor yüksek olsa bile temkin notu
4. **Sınıf değişimi:** önceki koşusuna göre grup/ikramiye seviyesi farkı.
   Sınıf düşen at avantajlı, yükselen dezavantajlı — belirginse mutlaka not et.
5. **Kilo ve dinlenme:** son koşuya göre kilo değişimi; koşular arası gün
   sayısı (7-21 gün normal bant; 45+ gün dönüş = risk VE sürpriz sinyali).
6. **Jokey katmanı:** jokeyin genel istatistiği + varsa BU AT ile ortak
   geçmişi (at-jokey ikilisi). Jokey değişimi varsa yönü (yükseltme mi
   düşürme mi) belirtilir.
7. **Zemin uyumu:** atın bugünkü pist türü + zemin kategorisindeki geçmişi.
   O kombinasyonda verisi azsa sadece pist türü bazlı değere geri düş ve
   bunu söyle.
8. **AGF-value analizi:** motor skoru sırası ile AGF sırası karşılaştırılır.
   "Belirgin sapma" GÖRELİ tanımlanır — sabit sıra numarası kullanılmaz,
   çünkü alan büyüklüğü koşudan koşuya değişir (8 atlı koşuda 7. sıra
   neredeyse sonuncudur, 14 atlı koşuda orta sıradır):
   - **Nitelikli value adayı (üçü birden):** motor sıralaması üst %30 içinde
     VE AGF sıralaması alt %50 içinde VE iki sıralama arasındaki fark ≥ 4
     basamak. Koşuda 8'den az at varsa value adayı İLAN EDİLMEZ.
   - Bu üçü sağlanıyor + en az bir destekleyici sinyal (sınıf düşüşü, jokey
     yükseltmesi, yükselen form, zemin uyumu) varsa **güçlü value**;
     destekleyici sinyal yoksa **zayıf value / izlenebilir** — kupona
     girmesi zorunlu değildir.
   - AGF sırası skordan belirgin iyi → "halk favorisi ama veride karşılığı
     zayıf" uyarısı.
   - AGF henüz oluşmamışsa (deklare aşaması) bu adım "AGF verisi henüz yok"
     notuyla atlanır ve value adayı ilan edilmez.
9. **Tahmin anı bağlamı:** her analizde tahminin HANGİ VERİYLE üretildiği
   bellidir ve söylenir (ör. "sabah skoru, AGF'siz"). Aynı koşunun farklı
   veri anlarındaki skorları (AGF'siz sabah / AGF'li öğleden sonra) ayrı
   şeylerdir; biri diğerinin yerine geçmez, karşılaştırılırken karıştırılmaz.
10. **Veri kapsaması:** motor her at için veri yokluğundan atlanan
    feature'ları bildirir (bkz. scoring-engine — `veri_kapsama`). Kapsama
    eşiğin altındaysa (varsayılan %70) o atın skoru "az veriyle üretilmiş"
    sayılır: metinde **Bilinmezlik riski** notu ZORUNLUdur ("pist/mesafe/
    zemin tecrübesi veride yok → skor eksik bilgiyle üretildi") ve at banko
    adayı olamaz. Eksik veri skordan puan düşülerek cezalandırılmaz,
    GÖRÜNÜR kılınır.

## 2. Zemin Etkisi Çerçevesi

Bu tablo GENEL ÖNSELDİR (prior) — atın kendi zemin geçmişi her zaman bu
tablodan önceliklidir; ikisi çelişiyorsa atın verisi kazanır.

| Zemin | Öne çıkma eğilimi | Geride kalma eğilimi |
|---|---|---|
| Çim — kuru/normal | hız ve finiş atları | — |
| Çim — ıslak/yumuşak/ağır | dayanıklı, geriden gelen atlar | saf hız atları, ağır kilolular |
| Kum — normal | iyi start alan, erken hızlananlar | — |
| Kum — ıslak/ağır | kondisyonu yüksek, kum geçmişi olanlar | hız bağımlı atlar |

Zemin ağırlaştıkça dayanıklılık faktörünün ağırlığı artar; yorumda bunu
ancak zemin verisi gerçekten mevcutsa kullan.

## 3. Koşu Karakteri (Kupon Kararının Girdisi)

Kupon önerisinden ÖNCE her koşuya iki eksende etiket verilir. Etiketler
motorun ürettiği sayılardan çıkar; LLM göz kararıyla etiket koymaz. Eşikler
projenin config'inde tanımlıdır, aşağıdakiler varsayılandır.

**Eksen 1 — skor dağılımı (her zaman yazılır):**

- **Net koşu:** 1. ile 2. arasındaki skor farkı, ilk 4 atın skor aralığının
  %25'inden büyük. → dar tutulur, tek ata ağırlık meşrudur.
- **Dengeli / zor koşu:** ilk 3-4 atın skorları birbirine yakın. → geniş
  tutulur, banko YOK.

**Eksen 2 — piyasa uyumu (yalnızca AGF varsa):**

- **Piyasayla uyumlu:** motor 1.si ile AGF 1.si aynı at veya bir basamak fark.
- **Sürprize açık:** AGF 1.si motorda 3. veya daha geride, ya da koşuda
  nitelikli value adayı var. → value ayağı kupona girer, piyasa favorisi tek
  başına taşınmaz.

İki etiket birlikte yazılır ("Net koşu / sürprize açık"). AGF yoksa yalnız
birinci eksen yazılır ve "piyasa ekseni AGF'siz değerlendirilemedi" denir.

## 4. Kupon Stratejisi (Altılı ve Türevleri)

Matematik her öneride açık gösterilir:

- **Maliyet** = ayak başına at sayılarının çarpımı × birim fiyat.
- **Asimetrik dağılım:** güçlü ayak dar (1-2 at), karışık ayak geniş
  (3-4 at). Her ayağa eşit at yazmak anti-pattern. Ayak genişliği Bölüm 3'teki
  koşu karakteri etiketine göre belirlenir — "dengeli/zor" etiketli ayak
  daraltılmaz.
- **Banko kriteri (üçü birden):** motor skoru açık ara önde VE form trendi
  yükselen/stabil VE zemin-mesafe uyumu veride destekli. İkisi varsa
  "güçlü aday", banko değil.
- **Kırılgan Favori (sinyal çelişkisi):** motor 1.si + şunlardan EN AZ BİRİ
  varsa at banko adaylığından otomatik düşer: form trendi düşen, 45+ gün ara,
  sert sınıf yükselişi, zemin/mesafe uyumsuzluğu, veri kapsaması eşik altı.
  Çelişki analiz metninin İLK cümlesinde açıkça yazılır ("Motor skoru 1. ama
  form trendi belirgin düşüşte → Kırılgan Favori"). Çelişki yumuşatılmaz,
  "yine de güçlü" diye kapatılmaz; at ancak başka destekleyici sinyaller
  varsa "güçlü aday" olarak kullanılır.
- **Sürpriz/value kriteri:** Bölüm 1 madde 8'deki nitelikli value tanımı
  geçerlidir. Sürpriz ayağına 1-2 value adayı eklenir; "zayıf value" adayı
  yalnızca bütçe elveriyorsa girer.
- **Bütçe ilkesi:** kullanıcı bütçe verdiyse kombinasyon o bütçeye göre
  kurulur; vermediyse dar/orta/geniş üç varyant sunulur.

## 5. Ölçüm ve Değerlendirme Disiplini (Model Performansı Konuşulurken)

Model "iyi mi kötü mü" sorusu bu kurallarla cevaplanır:

- **Örneklem eşiği:** ~100 koşunun altındaki isabet oranları "gösterge
  bile değil" muamelesi görür — sayı verilir ama yanına örneklem uyarısı
  ZORUNLU eklenir ve bu örneklemden model/kod hükmü çıkarılmaz. Tek günlük
  sonuçla "model bozuldu/düzeldi" denmez.
- **Baseline zorunlu:** hiçbir isabet oranı tek başına raporlanmaz; aynı
  koşu setinde en az bir kıyas verilir — piyasa favorisi (AGF 1.si) ve/veya
  rastgele seçim taban oranı. "%X tuttu" tek başına anlamsızdır.
- **Elmalarla elmalar:** backtest hangi veriyle ölçüldüyse canlı kıyas o
  veri koşuluyla yapılır. Final/yarış-sonu verisiyle ölçülen backtest,
  eksik veriyle üretilen canlı tahminin tavanıdır, beklentisi değil.
- **Doğru hedef sıralaması:** piyasa favorisini birincilik isabetinde
  geçmek en zor hedeftir ve modelin tek başarı ölçüsü DEĞİLDİR. Gerçekçi
  değer sırası: (1) tabela/plase isabetinde katkı, (2) value adaylarında
  (düşük AGF + yüksek skor) artı getiri, (3) piyasayı yakalamak, (4) en son
  piyasayı geçmek. Yorumlarda model bu çerçeveyle savunulur/eleştirilir.
- **Getiri ölçümü:** kupon/value stratejisinin uzun vade değeri simüle ROI
  ile ölçülür (bkz. scoring-engine). ROI yalnızca GERÇEK ödeme verisi
  (ganyan/plase tutarları) veritabanında varsa hesaplanır; tahmini ödemeyle
  ROI üretmek uydurmadır ve Bölüm 0'daki birinci kuralı ihlal eder.
- **Versiyon ayrımı:** farklı veri anı veya farklı ağırlıkla üretilen
  tahminler ayrı model versiyonu olarak izlenir; sonraki tahmin öncekini
  ezerek ölçüm geçmişini yok etmez.

## 6. Çıktı Formatı

Koşu analizi çıktısı:

1. Tek cümlelik koşu özeti (mesafe, pist, zemin, aday sayısı)
2. Koşu karakteri etiketi (iki eksen, Bölüm 3)
3. İlk 4-5 at: her biri için 1-2 cümle — skor + en güçlü 1-2 sinyal +
   varsa risk notu. Bileşen sayıları metne gömülür, tablo şart değil.
   Kırılgan Favori varsa çelişki ilgili atın İLK cümlesinde yazılır.
4. "Öne çıkanlar" satırı (1. ve 2. aday)
5. Varsa value/sürpriz adayı (gerekçesiyle, güçlü/zayıf ayrımıyla, tek cümle)
6. Kupon istendiyse Bölüm 4 formatında öneri + maliyet
7. Sorumluluk reddi (zorunlu, atlanamaz)

## 7. Sık Hatalar (Yapma)

- Ezberden jokey/antrenör ismi ve yüzdesi yazmak — bu skill'in varlık sebebi
  bunu engellemek.
- Padok gözlemi, vücut kondisyon skoru gibi VERİDE OLMAYAN faktörleri
  analize katmak.
- Motor sıralamasını LLM sezgisiyle ezip yeniden sıralamak.
- Düşen formdaki atı sırf skoru yüksek diye banko ilan etmek.
- Sinyal çelişkisini "yine de güçlü görünüyor" diyerek yumuşatmak veya
  Kırılgan Favori'yi kupona banko yazmak.
- Koşu karakteri etiketini motor sayılarına değil sezgiye dayandırmak.
- Sadece "AGF düşük" diye value ilan etmek; küçük alanda (8 attan az) veya
  AGF boşken value analizi yapmış gibi yazmak.
- Eksik veriyle üretilmiş skoru tam veriymiş gibi sunmak (Bilinmezlik riski
  notunu atlamak).
- Küçük örneklemden (tek gün, birkaç düzine koşu) model hükmü çıkarmak.
- İsabet oranını baseline'sız, çıplak yüzde olarak sunmak.
- Gerçek ödeme verisi yokken ROI/getiri rakamı üretmek.
- Farklı veri anlarında üretilmiş tahminleri aynı şeymiş gibi kıyaslamak.
- Sorumluluk reddini unutmak veya kısaltmak.
