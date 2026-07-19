---
name: gif-animation
description: Animasyonlu GIF ve kısa döngü animasyon üretimi standartları — mesajlaşma platformları (Telegram, Slack, WhatsApp), dokümantasyon (ürün demo GIF'i), sosyal medya ve e-posta için optimize GIF/WebP üretimi. Kullanıcı GIF üretme, emoji/tepki GIF'i, ekran kaydından demo GIF'i, animasyonlu banner, sticker veya döngü animasyon istediğinde MUTLAKA bu skill'i kullan. "GIF yap", "demo GIF", "ekran kaydını GIF'e çevir", "animasyonlu görsel", "sticker üret", "loop animasyon" gibi ifadeler geçtiğinde de kullan. Video montaj media-editing'e tabidir — bu skill kısa döngü formatının üretim ve optimizasyon disiplinini taşır.
---

# GIF Animation (Animasyonlu GIF / Kısa Döngü)

Kısa döngü animasyon üretimi ve optimizasyonu. Kaynak video işleme (kesme, hız) media-editing'in ffmpeg standartlarına, tasarım dili brand-ui'ye tabidir.

## Temel ilkeler

1. **Dosya boyutu bütçesi önce**: Hedef platform bütçesi baştan belirlenir — mesajlaşma emoji/sticker: <256KB; sohbet GIF'i: <2MB; dokümantasyon demo: <5MB; e-posta: <1MB (e-postada animasyon ilk kare düşer varsayımıyla, kritik bilgi ilk karede olur). Bütçesiz "güzel oldu ama 40MB" üretimi yasak.
2. **GIF son çaredir**: Modern hedeflerde önce WebP/animasyonlu WebP veya kısa MP4/WebM önerilir (10× küçük); GIF yalnızca platform zorunluluğunda (eski sistemler, bazı sticker formatları) üretilir. Kullanıcıya bu takas tek cümleyle söylenir.
3. **Döngü tasarımı**: Loop dikişsiz olmalı — son kare ilk kareye doğal bağlanır (palindrom oynatma veya döngüsel hareket). "Pat diye başa saran" GIF üretilmez.
4. **Kısa ve tek mesaj**: 2-6 saniye varsayılan; demo GIF'inde tek akış gösterilir (tıkla → sonuç). Uzun süreç GIF değil video olur (media-editing).

## Üretim tekniği (ffmpeg)

- Ekran kaydı → GIF: iki geçişli palet yöntemi zorunlu (`palettegen` + `paletteuse`) — tek geçiş bantlı/kirli renk verir.
- Optimizasyon sırası: fps düşür (demo için 10-15fps yeter) → boyut küçült (genişlik hedef kullanım kadar) → renk paleti sınırla (64-128 renk çoğu iş için yeterli) → gerekiyorsa `gifsicle -O3` son sıkıştırma.
- Metin okunabilirliği: küçültme sonrası ekran yazıları okunmuyorsa kayıt yakınlaştırılarak tekrar alınır; bulanık metinli demo teslim edilmez.
- Programatik üretim (koddan animasyon): kareler deterministik üretilir (gorsel-uretim/jeneratif-desen ilkeleriyle) → PIL veya ffmpeg ile birleştirilir; seed ve parametreler kaydedilir.

## Platform notları

- Sticker/emoji üretiminde platformun boyut-piksel-süre kuralları üretimden önce doğrulanır (değişkendir, varsayılmaz — güncel kural web'den kontrol edilir).
- Demo GIF'lerinde gerçek ürün ekranı kullanılır; mock ekranla "gerçekmiş gibi" demo yasak. Ekranda gerçek kullanıcı verisi görünmez (security-baseline log hijyeni ilkesi — test verisiyle kayıt alınır).
- Dokümantasyon GIF'leri repo'da kaynak kayıtla birlikte saklanır (yeniden üretilebilirlik).
