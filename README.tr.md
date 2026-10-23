<div align="center">

# claude-token-saver

**Claude'u tek komutla daha hızlı, daha kısa ve daha ucuz çalıştır.**

**Claude Code** ve **Claude.ai Projects** için hazır kural, komut ve güvenlik şablonu.

🇬🇧 [English](README.md) · 🇹🇷 Türkçe

![license](https://img.shields.io/badge/license-MIT-blue) ![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey) ![languages](https://img.shields.io/badge/docs-EN%20%7C%20TR-green)

</div>

---

## İçindekiler

1. [Neden var?](#neden-var)
2. [Özellikler](#özellikler)
3. [Hızlı başlangıç](#hızlı-başlangıç)
4. [Ne kurulur?](#ne-kurulur)
5. [Slash komutları](#slash-komutları)
6. [Token tasarrufu nasıl çalışır?](#token-tasarrufu-nasıl-çalışır)
7. [Güvenlik kuralları ve izinler](#güvenlik-kuralları-ve-izinler)
8. [Özelleştirme](#özelleştirme)
9. [Claude.ai Projects kurulumu](#claudeai-projects-kurulumu)
10. [Kurulum scripti referansı](#kurulum-scripti-referansı)
11. [Sık sorulan sorular](#sık-sorulan-sorular)
12. [Sorun giderme](#sorun-giderme)
13. [Kaldırma](#kaldırma)
14. [Yol haritası](#yol-haritası)
15. [Katkı](#katkı)
16. [Lisans](#lisans)

---

## Neden var?

Claude'a giden her mesaj bağlam taşır: kuralların, okuduğu dosyalar, sohbet geçmişi ve kendi önceki çıktıları. Maliyet ve hız bu bağlamla birlikte artar. Sık görülen israflar:

- **Gevezelik:** selamlama, soruyu tekrar etme, kapanış cümleleri ("Başka bir şey lazım olursa…").
- **Tüm dosyayı yazdırma:** üç satırı değiştirmek için 400 satırlık dosyayı baştan yazma.
- **Körlemesine okuma:** lock dosyaları, `node_modules`, build çıktısı veya tüm klasörleri açma.
- **Şişkin kural dosyası:** büyük bir `CLAUDE.md` *her* oturumda yüklenir.
- **Çelişkili kurallar:** "asla soru sorma" ile "yıkıcı işlemde onay iste" yan yana olunca model tereddüt eder veya fazla açıklama yapar.
- **Yanlış model seçimi:** biçimlendirme işini ağır bir modele yaptırmak.

`claude-token-saver`, bu alışkanlıkları kaynağında gideren, test edilmiş küçük bir şablondur. Her sohbette aynı talimatları tekrar yazmak zorunda kalmazsın.

> Sabit bir yüzde vaat etmez. Tasarruf projene ve alışkanlıklarına göre değişir. Amaç, faydalı token'ları azaltmak değil, boşa giden token'ları azaltmaktır.

## Özellikler

- **Tek komutla kurulum:** macOS, Linux, WSL, Git Bash ve Windows PowerShell.
- **Güvenli kurulum scripti:** `--force` vermedikçe var olan dosyaları ezmez; `--force` ile `.bak` yedeği alır. `--dry-run` desteği var.
- **Yalın `CLAUDE.md`:** kısa, çelişkisiz, İngilizce yazılmış çekirdek kurallar (Türkçeden daha az token). Cevaplar yine *senin* dilinde gelir.
- **Altı hazır slash komutu:** `/review`, `/refactor`, `/lint`, `/test`, `/audit`, `/compact-ctx`.
- **Okuma koruması:** `settings.json`, bağımlılık, lock, build, coverage ve `.env` dosyalarının okunmasını engeller.
- **Yıkıcı komut koruması:** `rm -rf`, `git push --force`, `git reset --hard` engelli.
- **Model yönlendirme:** basit komutlarda hızlı/ucuz model, zor işlerde güçlü model önerisi.
- **İhtiyaç anında doküman:** mimari ve hata notları sadece ilgili olunca okunur.
- **Claude.ai desteği:** yapıştırmaya hazır Project talimatı.
- **İki dilli doküman:** İngilizce ve Türkçe.

## Hızlı başlangıç

Claude'u kullandığın proje klasöründe çalıştır.

**macOS / Linux / WSL / Git Bash**

```bash
curl -fsSL https://raw.githubusercontent.com/yaldizemre/claude-token-saver/main/install.sh | bash
```

**Windows PowerShell**

```powershell
irm https://raw.githubusercontent.com/yaldizemre/claude-token-saver/main/install.ps1 | iex
```

**Ya da klonla ve çalıştır**

```bash
git clone https://github.com/yaldizemre/claude-token-saver.git
cd claude-token-saver
bash install.sh --dry-run --dir /projenin/yolu   # önizleme
bash install.sh --dir /projenin/yolu             # kurulum
```

Sonra:

1. `.claude/docs/architecture.md` dosyasını aç, `<FILL IN>` yazan teknoloji satırını doldur.
2. Projende `claude` çalıştır. Kurallar otomatik yüklenir.
3. `/review` veya `/compact-ctx` komutunu dene.

> İpucu: Bir scripti `bash`'e yönlendirmeden önce oku. `install.sh` kısadır ve gizli adım içermez.

## Ne kurulur?

```
projen/
├── CLAUDE.md                      # çekirdek kurallar, her oturumda yüklenir
└── .claude/
    ├── settings.json              # izin engelleri (okuma ve riskli komutlar)
    ├── docs/
    │   ├── architecture.md        # teknoloji ve standartlar (stack'ini yaz)
    │   └── error-handbook.md      # kötü alışkanlıklar ve projeye özel hata kaydı
    ├── security/
    │   └── guardrails.md          # sır ve yıkıcı işlem kuralları
    └── commands/
        ├── review.md              # /review
        ├── refactor.md            # /refactor
        ├── lint.md                # /lint
        ├── test.md                # /test
        ├── audit.md               # /audit
        └── compact-ctx.md         # /compact-ctx
```

Repoda ayrıca `claude-ai/` klasörü var (Claude.ai Project talimatı ve notlar). Bu klasör dokümandır, projene kurulmaz.

## Slash komutları

| Komut | Ne yapar | Model | Çıktı |
|---|---|---|---|
| `/review [yol]` | Verilen yolu, boşsa mevcut `git diff`'i inceler. Sızıntı, güvenlik açığı, eksik tip, taslak kod arar. | oturum modeli | Kritik / İyileştirme / Düzeltme, başka bir şey yok |
| `/refactor <yol>` | Performans, tipleme ve okunabilirliği dokümanlarına göre iyileştirir. Dosyayı yerinde düzenler. | oturum modeli | En fazla 3 maddelik özet |
| `/lint <yol>` | Kullanılmayan import/değişkenleri, ölü kodu ve debug loglarını temizler. | Haiku | Açıklama yok |
| `/test <yol>` | Anlamlı testler yazar (uç durumlar, async hataları, sınırlar), çalıştırır, hataları düzeltir. | oturum modeli | Test dosyası |
| `/audit <yol>` | Kırmızı takım taraması: düşmanca girdiler, üretimde ilk kırılma noktası, bağımlılık doğrulama. | oturum modeli | Sadece uygulanabilir hatalar ve çözümleri |
| `/compact-ctx` | Oturumu 300 kelimenin altında özetler, yeni sohbete taşıyabilirsin. | Haiku | Tek Markdown bloğu |

Komutlar `.claude/commands/` içindeki düz Markdown dosyalarıdır. İstediğin gibi düzenle veya yenisini ekle.

## Token tasarrufu nasıl çalışır?

| Teknik | Nerede | Etki |
|---|---|---|
| Dolgu yok, tekrar yok, kapanış teklifi yok | `CLAUDE.md` | Her turda daha kısa çıktı |
| Tüm dosya yerine yalnızca değişen kısım | `CLAUDE.md` | Büyük dosya düzenlemelerinde belirgin tasarruf |
| Önce ara, sadece gereken satırları oku | `CLAUDE.md` | Daha az girdi bağlamı |
| Lock, bağımlılık, build okumayı engelle | `settings.json` | Yanlışlıkla dev okumaları önler |
| İngilizce kural metni | tüm kural dosyaları | Türkçeye göre kural başına daha az token |
| Kısa çekirdek dosya, ayrıntılar `.claude/docs` içinde | yapı | Küçük sürekli bağlam; ayrıntılar sadece gerekince |
| Mekanik işlerde ucuz model | `/lint`, `/compact-ctx` | Görev başına düşük maliyet |
| Uzayan sohbeti özetleyip yeniden başlat | `/compact-ctx` | Geçmişin kartopu gibi büyümesini durdurur |
| Önce statik kurallar, sona değişken girdi | `architecture.md` yönergesi | Daha iyi prompt önbellek isabeti |

## Güvenlik kuralları ve izinler

- **Sırlar:** Claude'a anahtar, token ve parola yazdırmaması söylenir; `process.env.AD` veya `<PLACEHOLDER>` kullanılır.
- **Onay şart** olan yıkıcı işlemler: `rm -rf`, `DROP DATABASE/TABLE`, `git reset --hard`, `git push --force`, çekirdek dosya silme, global güvenlik mantığını değiştirme.
- **`settings.json` içinde kesin engeller:**
  - Okuma: `.env`, `.env.*`, `secrets/**`, `node_modules/**`, `dist/**`, `build/**`, `.next/**`, `coverage/**`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`
  - Komut: `rm -rf`, `git push --force`, `git reset --hard`

> **Dürüst sınırlar:** izin kuralları bir korkuluktur, güvenlik duvarı (sandbox) değildir. Desen tabanlı engeller dolaylı komutlarla aşılabilir (örneğin dosyayı başka bir araçla okumak). Gerçek sırları repoda tutma; kritik her şey için işletim sistemi ve git yetkilerini kullan.

## Özelleştirme

- **Teknolojin:** `.claude/docs/architecture.md` dosyasını düzenle.
- **Tekrarlayan hataların:** `.claude/docs/error-handbook.md` içine tek satırlık kayıtlar ekle ("belirti → neden → kural"). Kısa tut; okunduğunda her satır token harcar.
- **Cevap dili:** Claude yazdığın dilde cevap verir. Zorlamak için `CLAUDE.md`'ye bir satır ekle, örn. `Always reply in Turkish.`
- **Engelli bir yola izin ver:** `.claude/settings.json` içinden ilgili satırı sil.
- **Komut ekle:** `.claude/commands/ad.md` oluştur ve başına front matter koy:

  ```markdown
  ---
  description: Ne yaptığı
  model: haiku
  ---
  Şunun için görev: $ARGUMENTS
  ```
- **Kural dili:** Türkçe çalışan ekiplerde bile kural dosyalarını İngilizce tut; sadece cevapların dili senin dilin olsun.

## Claude.ai Projects kurulumu

Claude.ai `.claude/` klasörünü **okumaz**. Bunun yerine talimat metnini kullan:

1. claude.ai → **Projects → New project**.
2. `claude-ai/project-instructions.md` içeriğini proje talimatlarına yapıştır.
3. Project knowledge'a yalnızca kısa ve sık gereken dosyaları ekle. Tüm repoyu yükleme.
4. Konu değişince yeni sohbet aç.

Ayrıntılar: [`claude-ai/README.tr.md`](claude-ai/README.tr.md).

## Kurulum scripti referansı

| Seçenek | Anlamı |
|---|---|
| *(yok)* | Geçerli klasöre kurar; var olan dosyaları atlar |
| `--dir <yol>` | Başka bir klasöre kurar |
| `--dry-run` | Ne yapacağını yazar, hiçbir şeyi değiştirmez |
| `--force` | Farklı olan dosyaların üzerine yazar; her biri için `<dosya>.bak` yedeği alır |

Ortam değişkenleri: `CT_REPO` (varsayılan `yaldizemre/claude-token-saver`) ve `CT_BRANCH` (varsayılan `main`) ile bir fork'tan veya daldan kurabilirsin.

Aynı olan dosyalara dokunulmaz, yani yeniden çalıştırmak güvenlidir.

## Sık sorulan sorular

**Başka yapay zekâ araçlarında çalışır mı?** Claude Code ve Claude.ai için hazırlandı. Kural metni düz Markdown olduğu için uyarlanabilir.

**Mevcut `CLAUDE.md` dosyamı bozar mı?** Hayır. `--force` kullanmadıkça var olan dosyalar atlanır; `--force` ile de `.bak` kopyası tutulur. Kuralları elle birleştirebilirsin.

**Türkçe projede neden İngilizce kurallar?** Kural metni sık yüklenir; İngilizce genelde daha az token tutar. Cevaplar yine senin dilinde gelir.

**Claude Code kısmı Claude.ai'da kullanılır mı?** Hayır. `.claude/` yalnızca Claude Code tarafından okunur. Projects bölümüne bak.

**Tasarruf ölçüldü mü?** Sabit bir benchmark ile değil. Kendi kullanımını öncesi ve sonrası karşılaştır.

**Bir komuttaki `model: haiku` yok sayılıyor.** Model takma adları Claude Code sürümüne ve planına bağlıdır. Satırı sil veya tam model adı yaz.

## Sorun giderme

| Sorun | Çözüm |
|---|---|
| Kurulumda `curl: (22)` / 404 | Repo public olmalı ve `main` dalı bulunmalı |
| `template/ not found` | `template/` klasörü olmayan bir fork veya dal kullanıyorsun |
| Tekrar çalıştırınca dosyalar atlanıyor | Zaten varlar; `--force` kullan (yedek alınır) |
| Slash komutları görünmüyor | Proje kökünde `claude`'u yeniden başlat; `.claude/commands/*.md` var mı bak |
| Claude gereken bir dosyayı okuyamıyor | `.claude/settings.json` içindeki bir engelle eşleşiyor; o satırı sil |
| PowerShell scripti engelliyor | Normal PowerShell penceresinde çalıştır; politika `iex`'e izin vermiyorsa klonlama yöntemini kullan |

## Kaldırma

Kurulum scriptinin oluşturduklarını sil:

```bash
rm -rf .claude CLAUDE.md
```

`--force` kullandıysan `.bak` dosyalarını geri yükle.

## Yol haritası

- İsteğe bağlı hook'lar (büyük okuma öncesi uyarı, otomatik lint)
- Teknoloji hazır ayarları: `--stack node|python|go`
- Kurulumu doğrulayan `install.sh --check`
- Dokümanlar için daha fazla dil

## Katkı

Issue ve pull request'ler memnuniyetle karşılanır. Kuralları kısa ve çelişkisiz tut: eklenen her satır bağlama yüklenir ve token harcar. Değişiklikleri `bash install.sh --dry-run` ile dene.

## Lisans

MIT. Bkz. [LICENSE](LICENSE).
