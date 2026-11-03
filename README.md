# Rifugio

App open source di sopravvivenza e conoscenza **completamente offline** per iOS, Android e desktop (Flutter).

- **Guide**: testi ufficiali della Protezione Civile (CC BY 4.0) riprodotti integralmente; primo soccorso con estratti
  fedeli di Wikipedia (CC BY-SA 4.0) e rimandi ai manuali ufficiali.
- **Documenti**: manuali ufficiali integrali in PDF (esercito USA, Croce Rossa internazionale, *Nuclear War Survival Skills*).
- **Biblioteca**: Wikipedia, WikiMed e altre raccolte Kiwix (file ZIM) scaricabili e leggibili senza rete.
- **Strumenti**: torcia/SOS, Morse, bussola, coordinate GPS/UTM/MGRS, checklist, scorte, fallout.

Specifica, fonti e licenze: [SPEC.md](SPEC.md).

## Sviluppo

```bash
flutter pub get
flutter test
flutter run
```

Aggiornare i testi importati:

```bash
python3 -I tool/import_iononrischio.py
python3 -I tool/import_wikipedia_it.py
```

Test sui file ZIM reali (non inclusi nel repository): `ZIM_TEST_DIR=/cartella/con/file.zim flutter test test/zim_test.dart`.
