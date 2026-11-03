# Rifugio — Specifica di progetto

> Nome provvisorio. App open source di sopravvivenza e conoscenza **completamente offline**
> per iOS, Android e desktop (macOS, Windows, Linux).

## 1. Obiettivo

Avere sul telefono, senza rete, senza account e con poca batteria:

1. **Guide pratiche passo-passo** per le emergenze (primo soccorso, acqua, rifugio, rischio NBC…).
2. **Conoscenza generale**: Wikipedia completa e WikiMed, consultabili offline.
3. **Strumenti** utili sul campo (bussola, torcia/SOS, Morse, checklist, calcolatori…).
4. **Mappe offline** (fase successiva).

Fuori dallo scopo per ora: LLM locale, radio/mesh (rimandati a fasi future).

## 2. Principi

| Principio | Conseguenza pratica |
|---|---|
| Offline-first | Internet serve solo per scaricare i contenuti. Tutto il resto funziona in modalità aereo. |
| Zero account, zero telemetria | Nessun server nostro, nessun analytics, nessun tracciamento. |
| Batteria | Tema scuro OLED di default, niente animazioni inutili, nessun lavoro in background. |
| Leggibile sotto stress | Testi brevi, passi numerati, caratteri grandi, avvisi in evidenza. |
| Open source | Codice GPL-3.0, guide CC BY-SA 4.0. Build riproducibili. |
| Multi-piattaforma | Un solo codice per iOS, Android, macOS, Windows, Linux. |

## 3. Scelta tecnologica: Flutter

**Perché Flutter** (rispetto a React Native, Kotlin Multiplatform, app native separate):

- Un solo codice (Dart) per **iOS, Android, macOS, Windows, Linux**: soddisfa "scaricabile da vari dispositivi sin dall'inizio".
- **FFI** verso C/C++ semplice e veloce: le librerie chiave (libzim, zstd, in futuro MapLibre/llama.cpp) sono in C/C++.
- Interfaccia disegnata dal motore stesso: identica su tutte le piattaforme, facile da testare.
- Ottimo supporto F-Droid e build da riga di comando (CI open source).

Kotlin Multiplatform è valido ma su desktop/iOS l'interfaccia condivisa è meno matura; React Native è più debole su desktop e su FFI.

### Componenti

| Area | Soluzione |
|---|---|
| UI | Flutter (Material 3, tema scuro) |
| Guide | File Markdown + front-matter YAML inclusi nell'app (asset), renderizzati nativamente |
| Lettore ZIM (Wikipedia/WikiMed) | Lettore ZIM in Dart (header, indici, cluster) + decompressione zstd/xz. Ricerca per titolo nativa nel formato. Ricerca full-text (indice Xapian) in una fase successiva via `libzim` FFI |
| Visualizzazione articoli | WebView alimentata da un mini server HTTP locale (`127.0.0.1`) che serve le pagine dal file ZIM — stesso approccio di `kiwix-serve` |
| Catalogo download | Catalogo OPDS ufficiale di Kiwix (`library.kiwix.org`) → nessun server nostro da mantenere |
| Download | Download riprendibili, verifica checksum, scelta cartella (scheda SD su Android, importazione da Files/computer su iOS) |
| Sensori | Bussola (magnetometro), GPS, barometro, torcia |
| Dati utente | Database locale; sezione documenti cifrata (AES-GCM, chiave da PIN) |
| Mappe (fase 3) | MapLibre Native + file PMTiles (OpenStreetMap / Protomaps) |

## 4. Funzionalità

### 4.1 Guide passo-passo (cuore dell'app)

Formato di ogni guida: titolo, categoria, livello di urgenza, tempo di lettura, materiali, **passi numerati**,
avvisi ("NON fare"), fonti con licenza.

Categorie iniziali:

1. **Primo soccorso**: emorragie e laccio emostatico, RCP, soffocamento, ustioni, fratture, shock, ipotermia.
2. **Acqua**: quanta ne serve, potabilizzazione (bollitura, cloro, filtri, SODIS), conservazione.
3. **Rischio nucleare / radiologico**: allarme, riparo, regola 7-10 del fallout, decontaminazione, iodio.
4. **Rischio chimico / biologico**: riparo, sigillatura stanza, decontaminazione.
5. **Bombardamenti e rifugi**: dove ripararsi in casa, cosa fare durante e dopo.
6. **Cibo**: scorte, conservazione senza frigo, razionamento.
7. **Fuoco, calore, riparo**.
8. **Orientamento e spostamenti**: evacuazione, posti di blocco, documenti.
9. **Igiene e malattie**: servizi igienici di fortuna, diarrea e reidratazione orale.
10. **Comunicazioni**: piano famiglia, PMR446, segnali.

Fonti riutilizzabili (licenza da verificare per ciascuna): manuali dell'esercito USA (pubblico dominio),
*Nuclear War Survival Skills* (C. Kearny), linee guida OMS e Protezione Civile, ricerca in WikiMed.
Ogni guida riporta le fonti. **Revisione da parte di personale sanitario prima del rilascio pubblico.**

### 4.2 Biblioteca offline

- Catalogo: Wikipedia (IT, EN, mini/nopic/maxi), WikiMed (`mdwiki`), Wikivoyage, Wiktionary, iFixit, Gutenberg…
- Ricerca per titolo istantanea; ricerca full-text in seguito.
- Segnalibri, cronologia, articoli preferiti.
- Collegamenti dalle guide agli articoli WikiMed/Wikipedia correlati.

Profili di download consigliati:

| Profilo | Contenuto | Spazio circa |
|---|---|---|
| Essenziale | Guide + strumenti + WikiMed + Wikipedia IT "nopic" | 5-10 GB |
| Standard | + Wikipedia IT con immagini, Wikivoyage | 40-50 GB |
| Completo | + Wikipedia EN completa e altri ZIM | 150+ GB |

### 4.3 Strumenti

| Strumento | Fase |
|---|---|
| Torcia + SOS lampeggiante | 1 |
| Morse: testo → luce/suono, tabella di riferimento | 1 |
| Bussola + coordinate GPS (gradi decimali, DMS, UTM/MGRS) | 1 |
| Checklist (zaino 72h, scorte casa, prime ore) con spunte salvate | 1 |
| Calcolatore scorte acqua/cibo (persone × giorni) | 1 |
| Calcolatore decadimento fallout (regola 7-10) | 1 |
| Scheda medica e piano famiglia (punti di ritrovo, contatti) | 2 |
| Archivio documenti cifrato + PIN | 2 |
| Barometro/altimetro, livella | 2 |
| Alba/tramonto, fasi lunari | 2 |
| Frasario d'emergenza multilingue | 2 |
| Condivisione contenuti telefono ↔ telefono senza internet | 3 |
| Dosimetri Bluetooth (es. Radiacode) | 4 |

### 4.4 Mappe (fase 3)

Mappa mondiale base (basso dettaglio, circa 1-2 GB) + regioni dettagliate scaricabili, waypoint, traccia GPS,
punti di interesse (ospedali, farmacie, acqua). Instradamento offline in una fase successiva.

### 4.5 Politica dei contenuti

Priorità: **testi ufficiali scritti da persone, riprodotti integralmente**, con fonte e licenza.

| Stato (`status:`) | Significato | In app |
|---|---|---|
| `ufficiale` | Testo integrale di una fonte istituzionale con licenza che ne permette la ridistribuzione | Bollino verde + attribuzione |
| `verificata` | Testo adattato e controllato da personale qualificato | Bollino verde |
| `bozza` | Riassunto non verificato | Etichetta BOZZA + avviso |

Fonti importate:

- **Io non rischio – Protezione Civile** (CC BY 4.0): pagine "Cosa fare" e "Cosa sapere" per nucleare, industriale, terremoto,
  alluvione, maremoto, incendi, dighe e vulcani. Importazione automatica: `python3 -I tool/import_iononrischio.py`.
- **Documenti PDF integrali** (`assets/documents/`, elenco con licenza e SHA-256 in `catalog.json`), aperti nella Biblioteca:
  US Army ATP 4-02.11 *First Aid* (2026), US Army ATP 3-50.21 *Survival* (2018), IFRC *First Aid Guidelines* 2020 (non commerciale), Kearny *Nuclear War Survival Skills* (1987).

- **Primo soccorso (stato `estratti`)**: brani fedeli di Wikipedia in italiano (CC BY-SA 4.0), ognuno con la sua citazione,
  più rimandi alle pagine di ATP 4-02.11, IFRC e ATP 3-50.21 e alle guide della Protezione Civile. Dove Wikipedia contraddice
  i manuali (es. allentare il laccio, raffreddare piano nel colpo di calore) la guida mostra in cima la citazione letterale
  del manuale ufficiale. Importazione: `python3 -I tool/import_wikipedia_it.py`.

Fonti italiane di primo soccorso escluse: INAIL (riproduzione vietata, solo citazione), Ministero della Salute (blocca
le richieste automatiche), Croce Rossa Italiana (licenza non dichiarata).

Fonti valutate:

| Fonte | Licenza | Note |
|---|---|---|
| protezionecivile.gov.it | CC BY 4.0 | Compatibile |
| US Army ATP 3-50.21 *Survival*, FEMA/Ready.gov, CDC | Pubblico dominio (governo USA) | In inglese |
| *Nuclear War Survival Skills* (Kearny, 1987) | Riproducibile gratis mantenendo la nota di copyright | In inglese |
| IFRC *First Aid Guidelines* | Copie permesse solo per uso non commerciale | In inglese, non "libera" |
| Ministero della Salute | CC 2.5 non commerciale, senza modifiche | Non "libera" |
| Hesperian *Where There Is No Doctor* | "Open copyright", solo distribuzione gratuita/non profit | Permesso richiesto per alcuni usi |

## 5. Roadmap

| Fase | Contenuto |
|---|---|
| **1 — MVP** | Struttura app, guide (motore + prime guide), strumenti fase 1, tema scuro, build iOS/Android/desktop |
| **2 — Biblioteca** | Lettore ZIM, catalogo Kiwix, download, WikiMed + Wikipedia, strumenti fase 2 |
| **3 — Mappe** | MapLibre + PMTiles, gestione regioni, waypoint |
| **4 — Comunicazioni** | Meshtastic (BLE), mesh tra telefoni |
| **5 — LLM** | Modello locale con RAG su guide e ZIM |

## 6. Distribuzione

| Piattaforma | Canale |
|---|---|
| Android | GitHub Releases (APK), F-Droid |
| iOS | Build personale con Xcode (gratis, 7 giorni) o account sviluppatore (99 €/anno) per TestFlight/App Store |
| macOS / Windows / Linux | GitHub Releases |

Nota iOS: la GPL e l'App Store hanno attriti noti; Kiwix (GPL-3.0) è comunque presente sull'App Store.
Da rivalutare prima di una pubblicazione.

## 7. Struttura del repository

```
lib/
  main.dart
  app/            tema, navigazione
  features/
    guides/       modello, parser Markdown, schermate
    tools/        torcia, morse, bussola, checklist, calcolatori
    library/      lettore ZIM, catalogo, download (fase 2)
assets/
  guides/<categoria>/<guida>.md
  checklists/*.yaml
```

## 7b. Lingue, paesi e schede d'emergenza

- **Interfaccia** in italiano, inglese, francese, tedesco e spagnolo (`lib/l10n/app_*.arb`, generati con `flutter gen-l10n`).
  La lingua si sceglie al primo avvio (lingua, paese, pronto) e si cambia da Altro.
- **Schede d'emergenza** (`assets/cards/cards.json`): contenuto standard europeo, scritto una volta e tradotto nelle
  5 lingue, un passo per schermata. Fonti di riferimento in inglese: linee guida ERC (European Resuscitation Council),
  IFRC, manuali dell'esercito USA, protezione civile. Le fonti sono visibili solo su richiesta.
- **Paese** (`lib/app/countries.dart`): solo le differenze reali, cioè numeri di emergenza, nome del sistema di
  allerta sul telefono (IT-alert, FR-Alert, ES-Alert, NL-Alert, Cell Broadcast/NINA…), segnale delle sirene
  (FR, DE, AT, CH) e note specifiche (es. iodio sopra i 45 anni in Germania).
- **Menu**: Emergenza · Prepararsi · Strumenti · Altro (Biblioteca, testi originali, impostazioni).
- **Ricerca unica** su schede, strumenti, liste, testi originali, documenti ed enciclopedie scaricate, con sinonimi
  e tolleranza agli errori di battitura (`lib/features/search/`).
- Le schede vanno riviste da un medico o soccorritore madrelingua prima della distribuzione pubblica.

## 8. Stato della fase 2 (Biblioteca)

Fatto: lettore ZIM in Dart puro (`lib/features/library/zim/`, decompressione zstd/xz), server locale 127.0.0.1 + WebView,
ricerca per titolo, catalogo Kiwix (raccolte consigliate + ricerca), download riprendibili in background, cartella `zim`
visibile in File/Finder su iOS ed esclusa dal backup iCloud.

Limiti noti:

- Gli archivi **zimit** (siti web archiviati, es. NHS) non sono ancora supportati: servirebbe il riproduttore wabac.js.
- Niente ricerca nel testo completo (indice Xapian): solo per titolo.
- La WebView non esiste su Windows e Linux: lì la Biblioteca ZIM non è disponibile.

## 9. Decisioni aperte

- Nome definitivo dell'app.
- Lingue delle guide: italiano per primo, poi inglese.
- Ricerca full-text: libzim via FFI o indice proprio.
