---
name: ic-iletisim
description: İç iletişim dokümanları yazım standartları — durum raporu, ilerleme özeti, karar kaydı, duyuru, SSS ve haftalık özet. Kullanıcı durum raporu, ilerleme raporu, ortağa/ekibe özet, karar dokümanı, iç duyuru, proje güncellemesi veya SSS istediğinde MUTLAKA bu skill'i kullan. "Durum raporu yaz", "ortağa özet geç", "ilerlemeyi raporla", "karar kaydı", "duyuru metni (iç)", "haftalık özet" gibi ifadeler geçtiğinde de kullan. Okuyanın 2 dakikada durumu kavradığı, karar ve riskleri saklamayan iç iletişim üretir.
---

# İç İletişim (Internal Comms)

Ortaklara/ekibe/paydaşlara yönelik iç iletişim standartları. Pazarlama dili copywriting'e aittir — burada süsleme değil netlik esastır.

## Temel ilkeler

1. **Sonuç önce (BLUF)**: İlk cümle ana mesajı verir ("Pilot 2 hafta gecikecek çünkü X"). Kronolojik hikâye anlatımı yasak; detay isteyene alt bölümde.
2. **Durum dili standart**: 🟢 yolunda / 🟡 risk var / 🔴 engel var. 🟡 ve 🔴 her zaman "ne gerekiyor" satırıyla gelir — sorun bildirip çözüm ihtiyacını söylememek eksik rapordur.
3. **Kötü haber ilk raporda**: Risk, küçükken raporlanır. Kötü haberi geciktirmek iç iletişimde en pahalı hatadır; rapor okuyanı şaşırtmamalıdır ("bunu neden şimdi duyuyorum" testi).
4. **Sayı > sıfat**: "İyi ilerliyor" değil → "8 modülden 5'i canlıda, pilot okul 3 haftadır aktif". Ölçülemeyen ilerleme iddiası yazılmaz.

## Doküman türleri

- **Haftalık durum raporu**: tamamlanan (3-5 madde) / devam eden / riskler-engeller / gelecek hafta / karar bekleyenler. Yarım sayfa hedef; boş kategoriler "yok" diye yazılır, sessizce atlanmaz.
- **Karar kaydı (decision log)**: karar → tarih → gerekçe → değerlendirilen alternatifler → kim onayladı. Repo'da tek dosyada birikir; "neden böyle yapmıştık" sorusunun cevabı hafızada değil kayıtta durur.
- **Duyuru**: ne değişti → kimi etkiler → ne yapman gerekiyor (gerekiyorsa) → ne zaman → soru kanalı. Eylem gerektirmeyen duyuruda bu açıkça söylenir.
- **SSS**: gerçek sorulmuş sorulardan derlenir; hayali soru üretilmez. Cevaplar tek paragraf; uzayan cevap ayrı dokümana çıkar ve SSS'den bağlanır.

## Biçim kuralları

- Her doküman tarih ve yazar taşır; güncellenen dokümanda değişiklik notu düşülür.
- Teknik olmayan okuyucu varsa jargon çevrilir ("RLS" değil → "her müşterinin verisini ayıran güvenlik katmanı").
- Otomatikleşebilen raporlar otomatikleşir: metriğe dayalı düzenli özetler ai-report + telegram-bot hattına devredilir; insan yalnızca yorum ve karar kısmını yazar.
