---
name: pdf-generation
description: Web uygulamasından PDF üretim standartları (teklif, fatura, rapor, sözleşme çıktıları). Kullanıcı PDF oluşturma, PDF indirme butonu, teklif/rapor PDF'i, html2canvas + jsPDF, sunucu tarafı PDF veya PDF şablonu istediğinde MUTLAKA bu skill'i kullan. "PDF oluştur", "PDF indir", "teklifi PDF yap", "rapor çıktısı al", "yazdırılabilir versiyon" gibi ifadeler geçtiğinde de kullan. Mobil uyumlu, Türkçe karakter sorunsuz, çok sayfalı PDF üretimi sağlar.
---

# PDF Generation

Web uygulamalarından PDF üretim standartları (teklif, fatura, rapor tipi belgeler). Projeye özel detaylar (belge şablonları, marka öğeleri, alan içerikleri) CLAUDE.md'dedir — bu skill evrensel üretim desenini taşır.

## Yöntem seçimi

İki ana yol; ihtiyaca göre seç:

1. **Client-side görüntü tabanlı (html2canvas + jsPDF)** — varsayılan pratik yol:
   - HTML/CSS ile tasarlanan görünüm görüntüye çevrilip PDF'e basılır.
   - Artı: tasarım özgürlüğü tam (Tailwind ile), Türkçe font sorunu yok (tarayıcı render eder), sunucu maliyeti sıfır.
   - Eksi: metin seçilemez/aranamaz, dosya boyutu büyür. Teklif/rapor gibi "görsel belge" işlerinde kabul edilebilir.
2. **Sunucu tarafı gerçek PDF** (metin seçilebilir olmalıysa, arşivleme/resmi belge gereksinimiyse):
   - Node tarafında Puppeteer/Playwright ile HTML → PDF (Vercel'de `@sparticuz/chromium` ile). Vercel function limitlerine dikkat: süre ve boyut; yoğun kullanım varsa ayrı endpoint/queue düşün.
   - Basit tablolu belgelerde `pdf-lib`/`jspdf` ile programatik çizim de olur ama Türkçe font gömme gerekir; karmaşık tasarımda HTML → PDF tercih et.

Karar sorusu: "Bu PDF'te metin aranabilir/seçilebilir olmalı mı?" Hayırsa yöntem 1, evetse yöntem 2.

## Client-side desen (html2canvas + jsPDF)

**Şablon component kuralları:**
- PDF görünümü ayrı bir component'tir (`TeklifPdfSablonu` gibi), ekran görünümünden bağımsız; sabit genişlikte tasarlanır (A4 oranı: 794px genişlik referansı, 96dpi).
- Şablon render edilirken ekran dışında konumlandırılır (`position: absolute; left: -9999px`) — kullanıcıya görünmez ama DOM'da ölçülebilir olur. `display: none` KULLANMA (html2canvas boş çıktı verir).
- Görseller (logo dahil) CORS güvenli olmalı: aynı origin'den servis et veya `crossOrigin` ayarla; harici URL görseli sessizce boş çıkabilir.
- `oklch()` gibi yeni CSS renk fonksiyonları html2canvas'ta sorun çıkarabilir (Tailwind v4'e dikkat); şablonda hex/rgb kullan.

**Çok sayfalı üretim (sayfa sayfa yakalama):**
- Tek uzun canvas'ı dilimlemek yerine her sayfa AYRI bir DOM bloğu olarak tasarlanır (`.pdf-sayfa` class'ı, A4 oranında sabit yükseklik) ve her blok ayrı `html2canvas` çağrısıyla yakalanıp `jsPDF.addPage()` ile eklenir. Bu, satır ortasından bölünme sorununu kökten çözer.
- İçerik dinamik uzunluktaysa (kalem listesi gibi): kalemleri sayfa kapasitesine göre gruplara böl (ör. sayfa başına N satır), her grup bir `.pdf-sayfa` bloğu olur. Kapasiteyi içerik yüksekliğine göre hesapla, sabit sayıya körü körüne güvenme.
- Çözünürlük: `html2canvas(el, { scale: 2 })` — baskı netliği için; `scale: 3+` dosyayı gereksiz şişirir.
- Canvas → PDF: JPEG (`quality 0.9`) kullan; PNG dosyayı 3-5 kat büyütür.

**İndirme (mobil uyumluluk kritik):**
- Masaüstü: `pdf.save('dosya-adi.pdf')` yeterli.
- iOS Safari `save()` ile sorunludur: blob URL üret + yeni sekmede aç veya `navigator.share` (Web Share API, dosya paylaşımı destekliyorsa) kullan. Android WebView'larda da blob + anchor click deseni daha güvenilir.
- Desen: önce `navigator.canShare` kontrolü → paylaşılabiliyorsa share sheet → değilse blob URL ile indirme → son çare yeni sekmede açma. Kullanıcıya "İndiriliyor..." durumu göster; üretim 1-3 saniye sürebilir.
- Dosya adı anlamlı ve tarihli: `teklif-{no}-{yyyy-mm-dd}.pdf`; Türkçe karakter ve boşluk kullanma (bazı ortamlar bozar).

## Belge tasarım standartları

- Her sayfada: üstbilgi (logo + belge adı), altbilgi (sayfa no, tarih, iletişim). İlk sayfada belge kimliği (no, tarih, taraflar) net blok halinde.
- Tablolarda: başlık satırı her sayfada tekrar eder (sayfalara bölerken gruba başlık ekle), sayısal kolonlar sağa hizalı, para birimi ve binlik ayracı Türkçe formatta (`1.250,00 ₺` — `Intl.NumberFormat('tr-TR')` kullan).
- Toplam/özet bloğu son sayfada; ara toplam, KDV, genel toplam ayrı satırlar.
- Yazdırma dostu: beyaz zemin, koyu metin; büyük renk blokları mürekkep israfıdır, marka rengini vurgu olarak kullan.

## Kalite kontrol listesi

- [ ] Türkçe karakterler tüm alanlarda doğru (özellikle programatik çizimde font gömme)
- [ ] Satır/tablo ortasından sayfa bölünmesi yok
- [ ] iOS ve Android'de indirme test edildi
- [ ] Logo ve görseller çıktıda görünüyor (CORS)
- [ ] Dosya boyutu makul (tipik teklif < 2MB)
- [ ] Para/tarih formatları tr-TR

## Çıktı formatı

- Kod dosya yollarıyla: şablon component + üretim fonksiyonu (`generatePdf`) + indirme yardımcısı ayrı ve net.
- Kurulum: `npm install jspdf html2canvas` (veya seçilen yöntemin paketleri).
- Mobil indirme akışının hangi sırayla denendiğini kısa yorumla belgele.
