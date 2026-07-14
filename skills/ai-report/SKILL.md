---
name: ai-report
description: Veriden LLM ile otomatik rapor/yorum üretme standartları (Anthropic API). Kullanıcı AI yorum katmanı, otomatik analiz raporu, LLM ile veri yorumlama, AI komite/persona yaklaşımı, zamanlanmış AI raporu veya prompt şablonu tasarımı istediğinde MUTLAKA bu skill'i kullan. "AI yorum eklesin", "rapor üretsin", "LLM'e yorumlat", "analiz yazısı oluştur", "prompt hazırla" gibi ifadeler geçtiğinde de kullan. Deterministik veri + kontrollü LLM yorumu ile güvenilir otomatik raporlar üretir.
---

# AI Report

Yapılandırılmış veriden LLM (Anthropic API) ile otomatik rapor/yorum üretme standartları. Projeye özel detaylar (rapor içerikleri, personalar, yasak ifadeler, gönderim kanalı) CLAUDE.md'dedir — bu skill evrensel deseni taşır.

## Temel felsefe

1. **Deterministik veri, yorumlayan LLM**: Sayılar, skorlar, hesaplamalar KODDA üretilir; LLM'e HAZIR verilir. LLM hesap yapmaz, veri uydurmaz — yalnızca verilen veriyi yorumlar. Prompt'ta bu açıkça yazılır: "Yalnızca sana verilen verileri kullan, veri dışı sayı üretme."
2. **LLM danışmandır, karar verici değil**: Rapor bilgilendirir; işlem/karar tetiklemez. Otomatik aksiyon gerekiyorsa o deterministik kuralla ayrı kurulur.
3. **Düzenlemeye tabi alanlarda dil sınırı** (finans, sağlık vb.): tavsiye dili YASAK — "almalısınız/satmalısınız" yerine "veriler X yönünde", "tarihsel olarak Y görülmüş". Zorunlu uyarı metni (ör. "yatırım tavsiyesi değildir") şablonda sabittir, LLM'in insafına bırakılmaz.

## Mimari desen

```
veri hazırlama (kod) → prompt şablonu + veri → API çağrısı → çıktı doğrulama (kod) → kayıt/gönderim
```

- Python varsayılan (`anthropic` SDK); Next.js tarafında gerekiyorsa route handler'da aynı desen.
- API key env'den (`ANTHROPIC_API_KEY`); istemci tarafına ASLA sızmaz.
- Model seçimi: rutin rapor/yorum işlerinde maliyet-etkin güncel model (Sonnet sınıfı); model adı config'te tutulur, koda gömülmez — model değişimi tek satır olmalı.
- Rapor üretimi pipeline'ın SON adımıdır; LLM hatası veri işini düşürmez (yorum üretilemezse rapor "yorumsuz" gönderilir veya atlanır, loglanır).

## Prompt şablonu standartları

- Prompt'lar koddan AYRI dosyada yaşar (`prompts/rapor_v1.md` gibi) ve sürümlenir — prompt değişikliği kod değişikliğinden bağımsız izlenebilir olmalı.
- Şablon yapısı:
  1. **Rol tanımı**: kim olarak yazıyor (analist, komite üyesi...)
  2. **Görev**: ne üretecek, kim okuyacak
  3. **Veri bloğu**: yapılandırılmış veri (JSON veya etiketli bölümler halinde enjekte edilir)
  4. **Kurallar**: dil sınırları, uzunluk, YASAK ifadeler listesi, "veri dışına çıkma" emri
  5. **Çıktı formatı**: kesin şema (başlıklar, bölüm sırası, karakter limiti)
- Türkçe çıktı isteniyorsa açıkça belirt ve örnek ton ver; "resmi ama kuru olmayan" gibi soyut tarif yerine 1-2 örnek cümle koy.
- Değişken veri şablona string birleştirmeyle değil net ayraçlarla girer (`<veri>...</veri>` etiketleri) — LLM veri ile talimatı karıştırmasın.

## Persona / komite deseni

Tek konuya birden çok bakış açısı istendiğinde (ör. makro analist + teknik analist + risk yöneticisi):

- Tek API çağrısında tüm komite üretilebilir (prompt'ta her persona ayrı bölüm ister) — ucuz ve tutarlı; varsayılan bu.
- Personalar gerçekten bağımsız görüş üretmeliyse (birbirini görmemeli) ayrı çağrılar yapılır, sonra kod birleştirir. Maliyet farkını kullanıcıya belirt.
- Her personanın rolü, uzmanlık alanı ve ÇATIŞMA hakkı prompt'ta tanımlanır: "Personalar aynı fikirde olmak zorunda değildir" — hepsi aynı şeyi söylüyorsa komite tiyatrodur.

## Çıktı doğrulama (zorunlu katman)

LLM çıktısı doğrulanmadan kullanıcıya/kanala GİTMEZ:

- **Yapı kontrolü**: JSON istendiyse parse edilir (markdown çit temizliği ile); beklenen alanlar/bölümler var mı kontrol edilir. Bozuksa 1 kez yeniden dene, yine bozuksa "yorumsuz" moda düş.
- **İçerik kontrolü** (basit kod kuralları): yasak ifade taraması (tavsiye kalıpları vb.), uzunluk sınırı, zorunlu uyarı metninin varlığı. Kural ihlalinde çıktı kullanılmaz.
- **Sayı tutarlılığı** (kritik raporlarda): LLM metninde geçen anahtar sayılar kaynaktan regex/parse ile doğrulanabilir; uyuşmazlıkta rapor işaretlenir.

## Maliyet ve izleme

- Girdi veriyi buda: LLM'e ham tablo dökme; yorum için gereken özet/öne çıkan satırları gönder. Token = para.
- Her çağrının model, token sayıları ve maliyeti loglanır; günlük zamanlanmış işlerde aylık maliyet tahmini baştan hesaplanıp kullanıcıya söylenir.
- Aynı veriyle tekrar üretim (retry hariç) yapılmaz; üretilen rapor veritabanına kaydedilir (tarih, prompt sürümü, model, çıktı) — hem arşiv hem tekrar-kullanım.

## Çıktı formatı

- Kod dosya yollarıyla: veri hazırlama + prompt dosyası + üretim scripti + doğrulama ayrı ve net.
- Prompt dosyası tam haliyle verilir (özet değil).
- Sonda "Kurulum" notu: env değişkeni, tahmini çağrı maliyeti, test komutu (gerçek gönderim kapalı bayrakla).
