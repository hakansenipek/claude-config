---
name: incident-postmortem
description: Suçlamasız (blameless) olay sonrası inceleme standartları — production kesintisi, veri hatası, güvenlik olayı veya kritik bug sonrası kök neden analizi ve önlem planı. Kullanıcı postmortem, olay raporu, kök neden analizi, "site çöktü ne öğrendik", kesinti incelemesi veya tekrar yaşanmasın planı istediğinde MUTLAKA bu skill'i kullan. "Postmortem yaz", "kök neden", "neden oldu", "olay raporu", "bir daha olmasın", "5 whys" gibi ifadeler geçtiğinde de kullan. Kişiyi değil sistemi düzelten, aksiyonları takip edilebilir olay incelemeleri üretir.
---

# Incident Postmortem (Olay Sonrası İnceleme)

Production olaylarından sistematik öğrenme standartları. Olay anındaki müdahale değil, sonrasındaki inceleme bu skill'in konusudur.

## Temel ilkeler

1. **Suçlamasız**: İnceleme "kim hata yaptı" değil "sistem bu hataya nasıl izin verdi" sorusunu cevaplar. Tek geliştirici kurulumda bile geçerli — hedef kendini yargılamak değil, süreci/otomasyonu düzeltmek.
2. **İnsan hatası kök neden değildir**: "Dikkatsizlik" ile biten analiz bitmemiştir. Doğru soru: hangi kontrol eksikti ki bu hata production'a ulaştı (test, hook, deploy-checklist adımı, monitoring)?
3. **Zaman çizelgesi kanıta dayanır**: Loglar, commit'ler, deploy kayıtları, Telegram bildirimlerinden dakika bazlı kronoloji; hafızadan yazılmış "sanırım şöyle oldu" çizelgesi yasak.
4. **Her önlem sahiplenilir**: Aksiyonlar somut, tarihli ve tamamlanma durumu izlenir. "Daha dikkatli olacağız" aksiyon değildir; "X pattern'i enforcement-hooks'a eklendi" aksiyondur.

## Postmortem şablonu

- **Özet**: ne oldu, ne kadar sürdü, kim/ne etkilendi (kullanıcı sayısı, veri kaybı var/yok).
- **Etki**: ölçülebilir hasar (kesinti süresi, hatalı kayıt sayısı, kaybedilen işlem).
- **Zaman çizelgesi**: tespit → teşhis → müdahale → çözüm, her adım saatiyle. Tespit gecikmesi (olay başlangıcı ile fark etme arası) ayrıca vurgulanır — monitoring boşluğunun ölçüsüdür.
- **Kök neden**: 5 Whys veya katman analizi (tetikleyici ≠ kök neden ayrımı net). Çoğu olayda birden fazla katkı nedeni vardır; tek suçlu aramak yerine hepsi listelenir.
- **İyi giden / şanslı olduğumuz**: neyi erken yakaladık, hangi önlem işe yaradı, neresi tesadüfen kurtardı.
- **Önlemler**: tekrar önleme / tespit hızlandırma / etki azaltma başlıklarıyla; her biri ilgili sisteme bağlanır (test → testing, kural → enforcement-hooks, kontrol → deploy-checklist, uyarı → telegram-bot).

## Süreç kuralları

- Ciddi olaydan sonraki 48 saat içinde yazılır (hafıza tazeyken); kısa olaylar için 10 satırlık mini-postmortem yeterlidir, tören gerekmez.
- Postmortem'ler tek yerde birikir (repo içinde `docs/postmortems/YYYY-MM-DD-baslik.md`); yeni olayda önce eskiler taranır — tekrar eden kalıp, tekil olaydan daha önemli sinyaldir.
- Regresyon kuralı (testing skill'iyle): production'a ulaşmış her bug, kapanmadan önce onu yakalayacak testi kazanır.
