---
name: media-editing
description: Görsel ve video düzenleme/işleme standartları (boyutlandırma, kırpma, format dönüşümü, sıkıştırma, arka plan kaldırma, upscale, metin bindirme, video montaj). Kullanıcı görsel boyutlandırma, format çevirme (webp, mp4 vb.), logo/watermark ekleme, görsel optimizasyonu, video kesme/birleştirme, ffmpeg veya PIL ile işlem istediğinde MUTLAKA bu skill'i kullan. "Resmi küçült", "webp'ye çevir", "arka planı kaldır", "videoyu kes", "watermark ekle", "görseli optimize et" gibi ifadeler geçtiğinde de kullan. Programatik-öncelikli, kayıpsız ve tekrarlanabilir medya işleme üretir.
---

# Media Editing

Görsel ve video düzenleme/işleme standartları. Projeye özel detaylar (marka renkleri, fontlar, logo dosyaları, hedef platform boyutları) CLAUDE.md'dedir. İçeriğin NE olacağı (senaryo, konsept) `media-content` skill'inin işidir; bu skill dosyanın kendisini işler.

## Araç seçim önceliği

1. **Programatik (PIL/Pillow, ffmpeg)**: Varsayılan. Deterministik, ücretsiz, tekrarlanabilir, toplu işlenebilir. Boyutlandırma, kırpma, format, sıkıştırma, metin/logo bindirme, video kesme/birleştirme işleri BURADA yapılır.
2. **AI araçları (Higgsfield vb.)**: Yalnızca programatik yapılamayan işlerde — arka plan kaldırma (karmaşık kenarlar), upscale, içerik üretme/değiştirme. AI'a giden işte bile son montaj (metin, logo, boyut) programatik yapılır.
3. Tek seferlik ufak iş bile olsa script yaz — komutu/scripti sakla, aynı iş tekrar geldiğinde parametre değiştirip koşulur.

## Görsel işleme (PIL/Pillow)

**Boyutlandırma/kırpma:**
- Oranı koruyarak küçült: `Image.thumbnail()`. Hedef orana kırpmak gerekiyorsa merkezden kırp (ör. 4:5 post için), önemli özne merkezde değilse kırpma kutusunu elle parametre yap.
- Asla küçük görseli büyütme (kalite kaybı) — büyütme gerekiyorsa AI upscale'e yönlendir.
- Yeniden örnekleme: küçültmede `Image.LANCZOS`.

**Format ve sıkıştırma:**
- Web hedefi: WebP (kalite 80-85) varsayılan; şeffaflık gerekiyorsa WebP/PNG; e-posta uyumluluğu gerekiyorsa JPEG.
- JPEG kaydında `quality=85, optimize=True`; meta/EXIF'i web çıktısında temizle (gizlilik + boyut).
- Hedef ağırlıklar: web içerik görseli < 200KB, hero görsel < 400KB, thumbnail < 50KB. Aşıyorsa önce boyut düşür, sonra kalite.

**Metin/logo bindirme:**
- Fontlar dosyadan yüklenir (`ImageFont.truetype`) — marka font dosya yolları CLAUDE.md'de. Sistem varsayılan fontuyla marka işi ÇIKMAZ.
- Türkçe karakter testi zorunlu: bindirmeden sonra ğ/ş/ı/İ kontrol et (font desteklemiyorsa değiştir).
- Okunabilirlik: metin arkasına yarı saydam bant veya hafif gölge; kontrastı düşük bindirme yapma.
- Logo/watermark: köşe yerleşimi + kenarlardan sabit pay (%3-5); opaklık watermark'ta %30-50, imza logoda %100.

**Toplu işleme:** klasör bazlı script deseni — girdi klasörü → işlem → çıktı klasörü (orijinalin ÜZERİNE yazma). Dosya adlarını koru veya anlamlı sonek ekle (`_1080x1350`).

## Video işleme (ffmpeg)

**Temel kurallar:**
- Kayıpsız işler (kesme, birleştirme, ses ayırma) yeniden encode ETMEDEN yapılır: `-c copy`. Yalnızca filtre/boyut değişiminde encode edilir.
- Encode gerekiyorsa: H.264 (`libx264`), `crf 20-23`, `preset medium`, ses `aac 128k`. Sosyal medya dikeyi: 1080x1920, 30fps.
- Kesme: `-ss` ve `-t/-to` giriş dosyasından ÖNCE yazılırsa hızlı ama keyframe'e yuvarlar; hassas kesim için `-ss`'i girdiden sonra ver (yavaş ama net).

**Sık desenler:**
- Birleştirme (aynı codec): concat demuxer + dosya listesi txt.
- Görsellerden video (slayt/şablon içerik): `-framerate` + `-loop` ile görsel başına süre; geçişler `xfade` filtresiyle.
- Ses ekleme/değiştirme: `-map` ile video ve ses akışları açıkça seçilir; süre uyumsuzsa `-shortest`.
- Boyut/kırpma: `scale` ve `crop` filtreleri; 9:16'ya dönüştürmede önemli alan kaybolmasın diye önce `crop` sonra `scale`.
- Metin bindirme: `drawtext` (fontfile ile marka fontu). Çok satır/stilli işlerde: metni PIL ile şeffaf PNG üret + `overlay` filtresiyle bindir — Türkçe ve tipografi kontrolü daha iyi.

**Kontrol:** işlem sonrası `ffprobe` ile süre/çözünürlük/codec doğrula; çıktıyı açıp ilk-orta-son saniyeleri gözle kontrol etme alışkanlığı öner.

## AI destekli işlemler

- Arka plan kaldırma: önce programatik dene (`rembg` kütüphanesi — yerel, ücretsiz); sonuç yetersizse AI servisine geç.
- Upscale: küçük kaynak görseli büyütme ihtiyacında AI upscale kullan; çıktıda yüz/metin bozulması kontrol et.
- AI çıktısı her zaman son montajdan geçer: boyut standardı + marka öğeleri programatik eklenir.

## Kalite kontrol listesi

- [ ] Çıktı boyutu hedef platform standardında
- [ ] Dosya ağırlığı hedefin altında
- [ ] Türkçe karakterler doğru görünüyor
- [ ] Orijinal dosya korunmuş (üzerine yazılmamış)
- [ ] Toplu işse rastgele 2-3 çıktı gözle doğrulanmış

## Çıktı formatı

- Tek iş: çalıştırmaya hazır komut/script + 1 cümle ne yaptığı.
- Toplu/tekrarlanacak iş: parametreli script (girdi/çıktı klasörü, boyut, kalite argümanlarıyla) + örnek çağrı.
- Kurulum gereken paket varsa komutuyla belirt (`pip install pillow rembg`, `apt install ffmpeg`).
