---
name: jeneratif-desen
description: Jeneratif/algoritmik sanat ve dekoratif desen üretimi standartları (p5.js, SVG, canvas) — arka plan desenleri, jeneratif kapak görselleri, veri estetiği, marka desenleri. Kullanıcı jeneratif sanat, algoritmik desen, p5.js sketch, arka plan pattern'i, jeneratif kapak, parçacık animasyonu veya "koddan sanat" istediğinde MUTLAKA bu skill'i kullan. "Jeneratif desen", "p5.js", "pattern üret", "algoritmik arka plan", "generative art" gibi ifadeler geçtiğinde de kullan. Ürün arka planı olarak kullanım brand-ui'nin doku kurallarına tabidir — bu skill üretim tekniğini ve estetik disiplini taşır.
---

# Jeneratif Desen (Algoritmik Sanat ve Desen)

Kodla üretilen desen/sanat standartları. Ürün arayüzünde kullanım brand-ui'nin "arka plan ve doku" kurallarına bağlıdır; bu skill üretimin kendisini taşır.

## Temel ilkeler

1. **Seed disiplini**: Her üretim seed'li rastgelelik kullanır — beğenilen sonuç seed'iyle kaydedilir ve yeniden üretilebilir. Seed'siz "bir daha tutturamadık" üretimi yasak.
2. **Parametre yüzeyi küçük**: 3-6 anlamlı parametre (yoğunluk, palet, ölçek, karmaşıklık); 20 parametreli kontrol paneli değil. Her parametrenin görsel etkisi tek cümleyle açıklanabilir olmalı.
3. **Palet markadan**: Renkler brand-ui paletinden veya ondan türetilmiş kısıtlı paletten gelir; rastgele RGB yasak. Tek görselde 2-4 renk disiplini.
4. **Sadelik estetiği**: Az kuralın tekrarından doğan düzen, çok efektin yığılmasından iyidir. Blur + glow + gradient + noise aynı anda kullanılıyorsa geri adım at.

## Teknik standartlar

- **Araç seçimi**: etkileşimli/animasyonlu → p5.js (artifact veya HTML); statik yüksek çözünürlük → SVG üretip PNG'ye dönüştür (ölçek bağımsız); ürün arka planı → mümkünse saf CSS/SVG pattern (JS yükü olmadan).
- **Çözünürlük**: statik çıktı hedef kullanımın 2×'i üretilir (retina); vektörel kalabilenler vektörel teslim edilir.
- **Performans**: canlı animasyonda parçacık sayısı/karmaşıklık mobilde 60fps hedefiyle sınırlanır; requestAnimationFrame dışı döngü yasak; sekme görünmezken durdurulur.
- **Deterministik varyasyon**: seri üretimde (ör. her blog yazısına benzersiz kapak) seed = içerik hash'i — aynı içerik hep aynı görseli alır.

## Kullanım kalıpları

- Marka deseni: logodan/ürün konseptinden türetilen tek geometrik motifin varyasyonu (metraj → grid/nesting motifi, borsa → çizgi/mum deseni) — soyut ama markayla ilişkili.
- Veri estetiği: gerçek veriden görsel (yıllık aktivite, fiyat serisi) — dekoratif kullanımda bile veri gerçek olur, sahte "veri görünümlü" desen üretilmez (ai-report dürüstlük ilkesiyle tutarlı).
- Sosyal içerik: jeneratif kapaklar media-content'in seri şablon tutarlılığı kuralına uyar (aynı seri = aynı motif ailesi).
