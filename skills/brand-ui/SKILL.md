---
name: brand-ui
description: Marka kimliği ve UI tutarlılık standartları (renk paleti, tipografi, component görünümü, Türkçe arayüz dili). Kullanıcı arayüz tasarımı, tema/renk sistemi, landing page görünümü, dashboard tasarımı, dark mode, component stili veya marka tutarlılığı istediğinde MUTLAKA bu skill'i kullan. "Tasarımı güzelleştir", "renkleri ayarla", "tema kur", "arayüzü düzenle", "landing tasarla", "dashboard görünümü" gibi ifadeler geçtiğinde de kullan. Tailwind üzerinde semantik, tutarlı, profesyonel marka arayüzleri üretir.
---

# Brand UI

Marka kimliği ve UI tutarlılığı standartları (Tailwind CSS üzerinde). Projeye özel değerler (paletin hex kodları, font aileleri, logo dosyaları, ton) CLAUDE.md'dedir — bu skill değerlerin NASIL sisteme bağlanacağını ve tutarlı kullanılacağını taşır. Kod tarafı kuralları için `code-standards` geçerlidir; bu skill görünüme odaklanır.

## Renk sistemi

**Semantik katman zorunlu**: hex kodları doğrudan class'larda kullanılmaz; Tailwind config'te (veya CSS değişkenlerinde) semantik adlarla tanımlanır ve her yerde o adlar kullanılır:

```
primary        # marka ana rengi (CTA, vurgu, aktif durum)
secondary      # ikincil marka rengi (rozet, ikincil vurgu)
success / warning / danger / info   # durum renkleri
```

- Her semantik rengin ton skalası türetilir (50-950); açık tonlar zemin/hover, koyu tonlar metin olarak kullanılır.
- **Kullanım oranı**: arayüzün büyük çoğunluğu nötr (beyaz/gri skalası); marka rengi vurgu içindir. "Her yer mor" markalaşma değil yorgunluktur — primary'yi CTA, aktif menü, önemli rozetlerde tut.
- Durum renkleri marka paletinden BAĞIMSIZ evrenseldir: success yeşil, danger kırmızı ailesinde kalır; kullanıcı alışkanlığıyla oynama.
- Erişilebilirlik: metin/zemin kontrastı normal metinde en az 4.5:1 (büyük başlıkta 3:1). Marka rengi açıksa üzerine beyaz metin koymadan önce kontrast doğrula; gerekirse metin için koyu tonu kullan.

## Tipografi

- En fazla 2 font ailesi: başlık + gövde (tek aile de olur, ağırlıkla ayrışır). `next/font` ile yüklenir, Türkçe karakter desteği İLK kontroldür (ğ/ş/ı/İ örnek metinle bakılır).
- Ölçek disiplini: Tailwind'in hazır ölçeği kullanılır (`text-sm/base/lg/xl/2xl...`); keyfi `text-[17px]` değerleri YASAK. Sayfa başlığı, bölüm başlığı, gövde, yardımcı metin için sabit eşleme belirle ve her sayfada aynı kullan.
- Gövde metni `text-base` altına düşmez (mobil okunabilirlik); yardımcı/etiket metinler `text-sm`, en küçük `text-xs` yalnızca rozet/damga.

## Boşluk, köşe, gölge

- Spacing yalnızca Tailwind ölçeğinden (`p-4`, `gap-6`...); keyfi piksel yok. Kart içi dolgu, kartlar arası boşluk, bölüm arası boşluk için üçlü standart seç (ör. `p-6 / gap-4 / space-y-10`) ve sapma.
- Köşe yarıçapı tek karakterde: proje ya `rounded-lg` ailesi ya `rounded-xl` ailesi kullanır — aynı ekranda karışık yarıçap olmaz. Buton ve input yarıçapı eşleşir.
- Gölge ölçülü: kart `shadow-sm`, açılır menü/modal `shadow-lg`; dekoratif ağır gölgeler kullanılmaz. Zemin ayrımı önce açık gri zemin + beyaz kart deseniyle sağlanır.

## Component görünüm standartları

- **Buton hiyerarşisi**: primary (dolu, marka rengi) / secondary (kenarlıklı) / ghost (çıplak) — sayfada TEK primary aksiyon. Yıkıcı işlemler danger renkli. Tüm butonlarda hover + focus-visible + disabled durumları tanımlı.
- **Form**: her alanda label (placeholder label DEĞİLDİR), hata mesajı alanın hemen altında danger renginde, focus ring marka renginde. Zorunlu alan işareti tutarlı.
- **Tablo/liste**: başlık satırı ayrışık (zemin veya ağırlıkla), satır hover'ı, sayısal kolon sağa hizalı, boş durum tasarımı ("Henüz kayıt yok" + eylem önerisi) zorunlu.
- **Durum görünümleri her ekranda**: loading (skeleton veya spinner), boş, hata. Bunlar tasarlanmadan ekran bitmiş sayılmaz.
- Rozet/etiket renkleri anlam taşır ve projede tek sözlüğe bağlanır (ör. durum → renk eşlemesi tek dosyada).

## Türkçe arayüz dili

- Tüm UI metinleri Türkçe; ton CLAUDE.md'de tanımlı değilse "siz" ile net-kibar profesyonel.
- Buton metinleri fiilli ve sonuç söyler: "Kaydet", "Teklif Oluştur" — "Tamam/Gönder" belirsizliği yerine.
- Tarih/para/sayı formatları `Intl.*('tr-TR')` ile; elle string formatlanmaz.
- Onay diyalogları sonucu açıkça söyler: "Bu kaydı silmek geri alınamaz. Silinsin mi?" + butonlar "Vazgeç / Sil".

## Dark mode (istenirse)

- Semantik katman doğru kurulduysa dark mode CSS değişkeni/`dark:` varyantı işidir; component'lere tek tek renk yazılmışsa önce o borç temizlenir.
- Dark'ta saf siyah zemin yerine koyu gri (`gray-900/950`), metin saf beyaz yerine `gray-100`; marka renginin dark uyumlu tonu ayrıca seçilir (açık zemindeki ton koyuda cıyak kalabilir).

## Çıktı formatı

- Tema kurulum işi: Tailwind config bloğu + semantik kullanım örnekleri dosya yollarıyla.
- Ekran tasarım işi: önce yerleşim özeti (2-3 cümle), sonra component kodu; loading/boş/hata durumları dahil.
- Mevcut arayüz iyileştirmede: tespit listesi (neyin neden değiştiği) + değişen kod — "güzelleştirdim" değil gerekçeli değişiklik.
