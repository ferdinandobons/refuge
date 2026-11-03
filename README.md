# Refuge

App open source per le emergenze e la preparazione, che funziona **senza internet**. Per iPhone e Android (Flutter),
in 5 lingue: italiano, inglese, francese, tedesco, spagnolo.

## Cosa contiene

- **Emergenza**: 22 schede brevi, passo per passo (primo soccorso, allarme aereo, nucleare, alluvione, terremoto,
  incendio, blackout, acqua…), con numero di emergenza e allerte del paese scelto e SOS luminoso.
- **Prepararsi**: piano di emergenza della famiglia, scorte di casa e zaino, mappe offline ed enciclopedie da scaricare.
- **Strumenti**: radio in emergenza (frequenze per paese), timer del fallout, scorte, manuali e guide, torcia e SOS,
  posizione e mappe (punti, distanza, percorso), bussola, Morse.
- **Manuali e guide**: documenti ufficiali europei e internazionali (inclusi o scaricabili dal sito dell'ente),
  guide della Protezione Civile, enciclopedie offline Wikipedia e WikiMed (Kiwix).

## Da dove vengono i contenuti

Le schede seguono le fonti ufficiali europee: linee guida ERC 2025 e IFRC 2025 per il primo soccorso, linee guida UE
sulla preparazione (72 ore), protezioni civili nazionali (Italia, Germania, Svezia, Paesi Bassi, Regno Unito), OMS.
Ogni frase delle schede ha la sua fonte in [docs/verifica-schede.md](docs/verifica-schede.md); la ricerca sulle fonti
europee e le licenze è in [docs/fonti-ue.md](docs/fonti-ue.md). Nell'app: Altro › Licenze e attribuzioni.

L'app non sostituisce un corso di primo soccorso né le indicazioni delle autorità.

## Licenze

- Codice: [GPL-3.0](LICENSE).
- Testi delle schede e traduzioni scritte per l'app: CC BY-SA 4.0.
- Contenuti di terzi con la loro licenza (Protezione Civile CC BY 4.0, Commissione europea CC BY 4.0, OpenStreetMap
  ODbL, Wikipedia CC BY-SA 4.0…): l'elenco completo è in `assets/legal/attributions.json`.

## Sviluppo

```bash
flutter pub get
flutter test
flutter run
```

Specifica del progetto: [SPEC.md](SPEC.md).
