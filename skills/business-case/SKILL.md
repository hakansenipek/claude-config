---
name: business-case
description: İş gerekçesi ve ROI analizi hazırlama standartları — bir yatırımın/projenin/özelliğin maliyet-fayda hesabı, geri dönüş süresi, alternatif karşılaştırması ve karar önerisi. Kullanıcı ROI hesabı, iş gerekçesi, maliyet-fayda analizi, "bu yatırıma değer mi", build vs buy kararı, özellik önceliklendirme gerekçesi veya müşteriye değer kanıtı istediğinde MUTLAKA bu skill'i kullan. "ROI çıkar", "business case", "maliyet fayda", "geri dönüş süresi", "buna değer mi", "hangi seçenek mantıklı" gibi ifadeler geçtiğinde de kullan. Varsayımları görünür, hesabı denetlenebilir karar dokümanları üretir.
---

# Business Case (İş Gerekçesi ve ROI)

Yatırım/proje/özellik kararları için maliyet-fayda analizi standartları.

## Temel ilkeler

1. **Varsayım tablosu zorunlu**: Her hesap, varsayımlar tablosuyla başlar (birim maliyet, saat ücreti, dönüşüm oranı, büyüme kabulü — her biri kaynağıyla: ölçülmüş / sektör ortalaması / tahmin). Tahmin olan varsayım tahmin olarak etiketlenir; gizli varsayım yasak.
2. **Üç senaryo**: Kötümser / baz / iyimser. Tek sayılık "ROI %340" sunumu yasak — aralık ve hangi varsayımın sonucu en çok oynattığı (duyarlılık) gösterilir.
3. **Tüm maliyetler sayılır**: Geliştirme + işletme (hosting, API, bakım saati) + fırsat maliyeti (bu yapılırken yapılmayan şey). "Zaten Claude yazıyor, bedava" muhasebesi yasak — geliştirme süresi saat olarak yine maliyettir.
4. **Karşı senaryo**: Her gerekçe "hiçbir şey yapmazsak ne olur" satırı içerir; kıyas noktasız fayda hesabı anlamsızdır.

## Standart hesap yapısı

- **Maliyet**: tek seferlik (geliştirme saati × saat değeri, kurulum) + aylık tekrarlayan (altyapı, API, bakım payı).
- **Fayda**: gelir artışı ve/veya maliyet tasarrufu ve/veya risk azaltımı — her biri ayrı satır, ayrı gerekçe. Tasarruf hesabında kazanılan saat gerçekten başka işe dönüşüyorsa sayılır.
- **Geri dönüş süresi**: birikimli net fayda ne zaman maliyeti geçer (ay). 12 ayı aşan geri dönüş açıkça vurgulanır.
- Para-zaman değeri gereken uzun vadeli kıyaslarda basit NPV (iskonto oranı varsayım tablosunda); gereksizse eklenmez.

## Build vs buy kararları

Karşılaştırma tablosu: geliştirme maliyeti + bakım yükü + esneklik ↔ hazır çözüm aboneliği + entegrasyon + bağımlılık riski. Ponytail ilkesiyle tutarlı varsayılan: hazır ve yeterli olan satın alınır/kullanılır; fark yaratmayan şey yazılmaz.

## Teslim formatı

Tek sayfalık karar dokümanı: karar sorusu → varsayımlar tablosu → üç senaryo sonucu → duyarlılık notu (kritik varsayım) → öneri + gözden geçirme tarihi ("6 ay sonra gerçek veriyle güncelle"). Karar verildiyse gerçekleşen değerlerle geriye dönük doğrulama yapılır — tahmin/gerçek sapması sonraki hesapların kalibrasyonudur.
