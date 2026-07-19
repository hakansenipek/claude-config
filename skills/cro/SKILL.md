---
name: cro
description: Dönüşüm oranı optimizasyonu (CRO) standartları — landing page, form, kayıt akışı ve fiyatlandırma sayfası dönüşümünü artırma. Kullanıcı dönüşüm artırma, form optimizasyonu, kayıt akışı iyileştirme, A/B test tasarımı, funnel analizi veya "neden kayıt olmuyorlar" tipi bir soru sorduğunda MUTLAKA bu skill'i kullan. "Dönüşümü artır", "form çok uzun mu", "CTA nereye", "A/B test", "funnel", "bounce yüksek" gibi ifadeler geçtiğinde de kullan. Ölçüme dayalı, hipotez-test döngüsüyle çalışan dönüşüm iyileştirmeleri üretir.
---

# CRO (Dönüşüm Oranı Optimizasyonu)

Landing page, form ve kayıt akışlarında dönüşümü artırma standartları. Metin yazımı copywriting'e, görsel dil brand-ui'ye aittir — bu skill "neyi, neden, nasıl ölçerek değiştireceğiz" kararını taşır.

## Temel ilkeler

1. **Önce ölç, sonra değiştir**: Mevcut dönüşüm oranı ve düşüş noktası bilinmeden değişiklik önerme. Veri yoksa ilk adım ölçüm eklemektir (sayfa görüntüleme → form başlama → form bitirme → doğrulama adımları).
2. **Hipotez formatı**: Her değişiklik "X'i Y yaparsak Z metriği artar çünkü..." cümlesiyle yazılır. Gerekçesiz değişiklik önerilmez.
3. **Tek değişken kuralı**: Bir testte tek şey değişir. Başlık + form + renk aynı anda değişirse sonuç yorumlanamaz.
4. **İstatistiksel dürüstlük**: Düşük trafikli sayfalarda (aylık <1000 ziyaret) A/B test yerine sıralı test (önce/sonra + dönem karşılaştırması) kullan ve belirsizliği açıkça söyle. Uydurma "anlamlılık" iddiası yasak.

## Form ve kayıt akışı

- **Alan başına maliyet**: Her form alanı dönüşüm düşürür. Kayıtta yalnızca zorunlu minimum (e-posta + şifre); geri kalanı onboarding'e ertele.
- **Tek kolon, tek CTA**: Form tek kolon; sayfada birbiriyle yarışan iki birincil CTA olmaz.
- **Hata anında göster**: Validation submit'te değil alan bazında, alanın yanında, Türkçe ve çözüm söyleyerek ("Geçersiz" değil → "E-posta @ içermeli").
- **Sürtünme envanteri**: Kayıt akışını adım adım yürüyüp her adımda "kullanıcı burada neden vazgeçer?" sorusunu listele; en maliyetli sürtünmeden başla.

## Sayfa hiyerarşisi

- İlk ekranda (fold üstü) cevaplanması gerekenler: ne işe yarar, kimin için, sonraki adım ne. Üçünden biri eksikse önce onu düzelt.
- Sosyal kanıt CTA'ya yakın durur (müşteri sayısı, logo, yorum) — ama uydurma kanıt asla eklenmez; yoksa o blok atlanır.
- Fiyat sayfasında karar kolaylaştırıcı: önerilen paket vurgusu, karşılaştırma tablosu, SSS'de itiraz cevapları (iptal, veri güvenliği, destek).

## Ölçüm ve raporlama

- Dönüşüm hunisi adımları tanımlı ve Supabase'de/analitikte izlenebilir olmalı; "hissiyatla" iyileştirme raporu yazılmaz.
- Test sonucu raporu şablonu: hipotez → değişiklik → süre/örneklem → sonuç → karar (uygula/geri al/yeniden test).
- Kaybeden varyant da raporlanır; sadece kazananları anlatan rapor yasak.

## Sınırlar

- Dark pattern yasak: gizli ücret, zorlaştırılmış iptal, sahte aciliyet ("son 2 saat!" gerçek değilse), önceden işaretli izin kutuları. KVKK açık rıza kuralları kvkk-legal'e tabidir.
