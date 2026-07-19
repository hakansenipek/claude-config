---
name: virtual-tryon
description: Sanal kıyafet deneme ve ölçü bazlı giydirme standartları — mağaza için AI ile "bu kıyafet müşteride nasıl durur" görselleştirmesi, terzi/gelinlik için vücut ölçüsü şeması ve beden eşleme. Kullanıcı sanal deneme, virtual try-on, kıyafet giydirme, müşteri fotoğrafına kıyafet geçirme, vücut ölçüsü kaydı, beden önerisi, gelinlik/terzi ölçü sistemi veya ürün-müşteri görselleştirmesi istediğinde MUTLAKA bu skill'i kullan. "Sanal kabin", "kıyafeti müşteriye giydir", "try-on", "ölçü al", "beden öner", "üzerinde nasıl durur" gibi ifadeler geçtiğinde de kullan. AI üretim sağlayıcı katmanı api-integration'a, fotoğraf işleme media-editing'e, rıza/veri kuralları kvkk-legal'e tabidir — bu skill deneme hattının kurgusunu ve dürüstlük sınırlarını taşır.
---

# Virtual Try-On (Sanal Deneme ve Ölçü Bazlı Giydirme)

Mağaza/terzi/gelinlik senaryolarında sanal deneme sistemi standartları. İki ayrı katman vardır ve ASLA karıştırılmaz: **görselleştirme** (AI üretimi, temsilidir) ve **beden/ölçü kararı** (deterministik kural, tahmine dayanmaz).

## Temel ilkeler

1. **Görselleştirme temsilidir, satış vaadi değildir**: AI ile üretilen "üzerinde böyle durur" görseli her zaman temsili etiketiyle gösterilir ("Temsili görüntüdür; gerçek görünüm, kumaş ve kesim farklılık gösterebilir"). Kesim/beden kararı görselden değil ölçüden verilir. Gelinlik gibi yüksek bedelli işte bu etiket sözleşme metnine de girer (kvkk-legal/avukat hattı).
2. **Ölçü kararı deterministiktir**: Vücut ölçüsü → beden önerisi, marka/ürün beden tablosuyla kural olarak hesaplanır (scoring-engine disiplini: açıklanabilir, test edilebilir). LLM/AI asla ölçü tahmin etmez, beden "sezmez"; iki beden arasında kalan müşteri "arada — prova önerilir" olarak işaretlenir, yuvarlanmaz.
3. **Müşteri fotoğrafı en hassas veridir**: Boy fotoğrafı + vücut ölçüsü kişiseldir ve müşteri mahremiyetinin merkezindedir. Açık rıza kaydı (kim, ne zaman, hangi metne — kvkk-legal rıza ispatı kuralı) OLMADAN fotoğraf sisteme alınmaz; fotoğraflar her zaman private bucket + süreli signed URL (security-baseline), EXIF/GPS temizliğiyle (media-editing yükleme hattı) saklanır. Saklama süresi kısa ve tanımlıdır; müşteri silme talebi tek adımda çalışır, üretilmiş deneme görselleri de birlikte silinir.
4. **AI sağlayıcıya gönderim = veri aktarımı**: Fotoğrafın try-on modeline (Higgsfield veya başka sağlayıcı) gönderilmesi yurt dışı aktarımı olabilir — aydınlatma metnine yazılır, rıza kapsamındadır; rıza yoksa üretim başlatılmaz (sunucu tarafında zorlanır, UI'da gizlenerek değil). 18 yaş altı müşteride veli rızası akışı zorunludur.

## Fotoğraf çekim standartları (girdi kalitesi = çıktı kalitesi)

- **Ürün fotoğrafı**: düz/nötr fon, ürünün tamamı karede, tutarlı ışık; mağaza başına tek çekim SOP'u (sop-builder formatında) yazılır — personel değişse de kalite değişmez. Arka plan temizliği gerekiyorsa media-editing hattından geçer.
- **Müşteri boy fotoğrafı**: tam boy, düz duruş, sade fon, telefon dik; çekim ekranında canlı rehber çerçeve gösterilir. Uygunsuz kare (yarım boy, aşırı karanlık) üretime gönderilmeden istemci tarafında uyarıyla reddedilir — kredi boşa yakılmaz.
- Ürün ve müşteri fotoğrafları ayrı bucket'larda, ayrı erişim kurallarıyla durur; ürün görseli public olabilir, müşteri görseli asla.

## Üretim hattı

- Sağlayıcı adaptör deseniyle bağlanır (api-integration): try-on modeli değişebilir olmalı — tek `lib/tryon-provider.ts` arayüzü, sağlayıcıya özgü şema içeri sızmaz. Model/sağlayıcı seçimi güncel karşılaştırmayla yapılır (web'den doğrulanır, ezberden model adı yazılmaz).
- Üretim asenkron kuyruktadır (`queued → processing → ready / failed`); mağaza tabletinde bekleme durumu görünür. Failed sessiz kalmaz, yeniden dene + kalıcı hatada personele bildirim.
- **Maliyet disiplini**: aynı müşteri × aynı ürün × aynı fotoğraf kombinasyonu cache'ten döner, yeniden üretilmez; mağaza başına günlük üretim limiti ve birim maliyet takibi vardır (business-case: try-on maliyeti ↔ satış katkısı ölçülür).
- Üretilen görselin üstünde temsili etiketi kalıcıdır (watermark/rozet) — ekran görüntüsü alınıp paylaşılsa da etiket taşınır.

## Terzi/gelinlik ölçü modülü

- Ölçü şeması yapılandırılmış ve birimlidir (cm, tek ondalık): göğüs/bel/kalça/omuz/kol boyu/boy/iç bacak + iş türüne göre ek alanlar; serbest metin ölçü yasak.
- Her ölçü kaydı tarihli ve ölçen kişiye bağlıdır; vücut değişir — sipariş her zaman GÜNCEL tarihli ölçüye bağlanır, eski ölçüyle üretim başlatılırken uyarı çıkar.
- Prova/revizyon geçmişi insert-only tutulur (hangi provada ne değişti); teslim öncesi son ölçü-son ürün karşılaştırması kontrol adımıdır (approval-workflow).
- Beden tabloları marka/ürün bazında versiyonludur; tablo değişince eski siparişlerin bedeni yeniden hesaplanmaz (sipariş, verildiği andaki tabloya bağlı kalır).

## Dürüstlük sınırları

- Try-on çıktısı vücut şeklini değiştirmez/inceltmez — "olduğundan farklı vücut" üretimi yasaktır; amaç kıyafeti göstermek, müşteriyi değiştirmek değil.
- Müşteri fotoğrafı ve deneme görselleri pazarlama/sosyal medya içeriğinde KULLANILMAZ (media-content bu kaynaktan beslenemez); ayrı ve açık bir izin olsa bile bu izin ayrı rıza kaydıdır, deneme rızasına gömülemez.
- Stokta olmayan/tedariki belirsiz ürün için deneme üretilip satış baskısı kurulmaz.
