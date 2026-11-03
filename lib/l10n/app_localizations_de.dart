// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Refuge';

  @override
  String get tabEmergency => 'Notfall';

  @override
  String get tabPrepare => 'Vorsorge';

  @override
  String get tabTools => 'Werkzeuge';

  @override
  String get tabMore => 'Mehr';

  @override
  String get onbLanguageTitle => 'Sprache wählen';

  @override
  String get onbCountryTitle => 'In welchem Land sind Sie?';

  @override
  String get onbCountryHint =>
      'Für die Notrufnummer und lokale Warnungen. Sie können es später ändern.';

  @override
  String get onbReadyTitle => 'Alles bereit';

  @override
  String onbReadyBody(String number) {
    return 'Die App funktioniert ohne Internet. Im Notfall rufen Sie $number an.';
  }

  @override
  String get onbStart => 'Los geht\'s';

  @override
  String get onbDownload => 'Lexika herunterladen (optional)';

  @override
  String get onbOptionalTitle => 'Optional: Offline-Lexika';

  @override
  String get onbOptionalBody =>
      'Die Notfallkarten sind bereits enthalten. Solange Sie Internet haben, können Sie zusätzlich laden:';

  @override
  String get onbPackWikimed => 'WikiMed (Englisch)';

  @override
  String get onbPackWikimedBody =>
      'Medizinisches Lexikon: Krankheiten, Symptome, Medikamente, Verletzungen, Erste Hilfe. Etwa 2 GB.';

  @override
  String get onbPackWikipedia => 'Wikipedia in Ihrer Sprache';

  @override
  String get onbPackWikipediaBody =>
      'Das gesamte Allgemeinwissen: Geschichte, Orte, Wissenschaft, Technik, wie Dinge funktionieren. Von wenigen GB (Kurzfassung) bis zu mehreren Dutzend GB (vollständig).';

  @override
  String get onbPackWikivoyage => 'Wikivoyage';

  @override
  String get onbPackWikivoyageBody =>
      'Länder und Städte: Fortbewegung, Grenzen, Krankenhäuser, praktische Informationen. Einige hundert MB.';

  @override
  String get onbDownloadNote =>
      'Sie brauchen WLAN und freien Speicher. Das geht auch später unter Vorsorge.';

  @override
  String callNumber(String number) {
    return '$number anrufen';
  }

  @override
  String get sosLight => 'SOS-Licht';

  @override
  String get searchHint => 'Suche: Blut, Jod, Erdbeben…';

  @override
  String get searchTip =>
      'Schreiben Sie, was passiert oder was Sie brauchen. Funktioniert auch mit unvollständigen Wörtern oder Tippfehlern.';

  @override
  String get searchEmpty => 'Keine Ergebnisse.';

  @override
  String get whatsHappening => 'Was ist passiert?';

  @override
  String get search => 'Suchen';

  @override
  String get readAloud => 'Vorlesen';

  @override
  String get allSteps => 'Alle Schritte';

  @override
  String get neverDo => 'Nicht tun';

  @override
  String get sources => 'Quellen';

  @override
  String stepOf(int n, int total) {
    return 'Schritt $n von $total';
  }

  @override
  String get previous => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get countryIT => 'Italien';

  @override
  String get countryFR => 'Frankreich';

  @override
  String get countryDE => 'Deutschland';

  @override
  String get countryES => 'Spanien';

  @override
  String get countryAT => 'Österreich';

  @override
  String get countryCH => 'Schweiz';

  @override
  String get countryBE => 'Belgien';

  @override
  String get countryNL => 'Niederlande';

  @override
  String get countryLU => 'Luxemburg';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'Vereinigtes Königreich';

  @override
  String get countryIE => 'Irland';

  @override
  String get countryOther => 'Anderes europäisches Land';

  @override
  String get officialAlerts => 'amtliche Warnungen';

  @override
  String get sirenFR =>
      'Warnung: auf- und abschwellender Heulton, 1 Minute 41 Sekunden, dreimal wiederholt. Entwarnung: 30 Sekunden Dauerton. Probealarm am ersten Mittwoch des Monats um 12 Uhr.';

  @override
  String get sirenDE =>
      'Warnung: 1 Minute auf- und abschwellender Heulton. Entwarnung: 1 Minute Dauerton.';

  @override
  String get sirenAT =>
      'Warnung: 3 Minuten gleichbleibender Dauerton. Alarm: 1 Minute auf- und abschwellender Heulton. Entwarnung: 1 Minute gleichbleibender Dauerton.';

  @override
  String get sirenCH =>
      'Allgemeiner Alarm: 1 Minute auf- und abschwellender Heulton, nach 2 Minuten wiederholt. Radio hören und Anweisungen befolgen.';

  @override
  String get noteIodineDE =>
      'In Deutschland sind Jodtabletten für Personen über 45 Jahre nicht vorgesehen.';

  @override
  String yourCountry(String name) {
    return 'Ihr Land: $name';
  }

  @override
  String get emergencyNumber => 'Notrufnummer';

  @override
  String get serviceAmbulance => 'Rettungsdienst';

  @override
  String get serviceFire => 'Feuerwehr';

  @override
  String get servicePolice => 'Polizei';

  @override
  String get servicePoison => 'Giftnotruf';

  @override
  String get serviceDeafSms => 'Notruf-SMS für Gehörlose';

  @override
  String get phoneAlerts => 'Warnungen aufs Handy';

  @override
  String phoneAlertsBody(String name) {
    return '$name: Die Warnungen kommen automatisch aufs Handy, auch ohne App. Lassen Sie sie in den Handy-Einstellungen aktiviert.';
  }

  @override
  String get sirens => 'Sirenen';

  @override
  String get checklists => 'Listen';

  @override
  String get offlineContent => 'Herunterladen, solange es Internet gibt';

  @override
  String get downloadEncyclopedias => 'Lexika herunterladen';

  @override
  String get downloadEncyclopediasBody =>
      'Wikipedia und WikiMed in Ihrer Sprache, ohne Netz lesbar.';

  @override
  String get library => 'Bibliothek';

  @override
  String get libraryBody =>
      'Offline-Lexika und offizielle europäische Dokumente';

  @override
  String get originalTexts => 'Originaltexte';

  @override
  String get originalTextsBody =>
      'Volltexte des italienischen Zivilschutzes (auf Italienisch)';

  @override
  String get originalTextsNote =>
      'Vollständige Texte in der Originalsprache, zum Vertiefen.';

  @override
  String get language => 'Sprache';

  @override
  String get country => 'Land';

  @override
  String get about => 'Info';

  @override
  String get aboutBody => 'Quellen, Lizenzen und Hinweise';

  @override
  String get aboutText =>
      'Open-Source-App, die ohne Internet funktioniert.\n\nDie Notfallkarten folgen europäischen Leitlinien: Erste Hilfe des Europäischen Rats für Wiederbelebung (ERC 2025) und des Roten Kreuzes (IFRC), Vorsorge nach den Leitlinien der Europäischen Union zu 72 Stunden, und Empfehlungen der nationalen Katastrophenschutzbehörden. Originaldokumente und Lexika finden Sie in der Bibliothek, mit Quellen und Lizenzen.\n\nDiese App ersetzt keinen Erste-Hilfe-Kurs und keine Anweisungen der Behörden.';

  @override
  String get documents => 'Dokumente';

  @override
  String get documentsBody =>
      'Offizielle europäische und internationale Dokumente, in Ihrer Sprache, wenn vorhanden, sonst auf Englisch. Einige sind schon in der App, die anderen werden von der offiziellen Website geladen.';

  @override
  String get torchTitle => 'Taschenlampe und SOS';

  @override
  String get torchSubtitle => 'Licht, blinkendes SOS, Bildschirmlicht';

  @override
  String get torchKeywords =>
      'taschenlampe licht dunkel sos blinken signal nacht lampe';

  @override
  String get torchOn => 'Taschenlampe an';

  @override
  String get torchOff => 'Taschenlampe aus';

  @override
  String get torchMissing =>
      'Keine Taschenlampe auf diesem Gerät. Nutzen Sie das Bildschirmlicht.';

  @override
  String get sosBlinking => 'SOS blinken';

  @override
  String get sosStop => 'SOS stoppen';

  @override
  String get screenLight => 'Bildschirmlicht';

  @override
  String get sosInfo =>
      'SOS = ··· ─── ··· wiederholt. Internationales Notsignal, nachts auch aus der Ferne sichtbar.';

  @override
  String get tapToClose => 'Zum Schließen tippen';

  @override
  String get morseTitle => 'Morse';

  @override
  String get morseSubtitle => 'Eine Nachricht mit Licht senden';

  @override
  String get morseKeywords => 'morse morsecode code signal licht nachricht';

  @override
  String get morseMessage => 'Nachricht';

  @override
  String get useTorchToo => 'Auch Taschenlampe nutzen';

  @override
  String get repeat => 'Wiederholen';

  @override
  String morseSpeed(int ms) {
    return 'Tempo: Punkt = $ms ms';
  }

  @override
  String get transmit => 'Senden';

  @override
  String get stop => 'Stopp';

  @override
  String get morseTable => 'Tabelle';

  @override
  String get compassTitle => 'Kompass';

  @override
  String get compassSubtitle => 'Richtung und Himmelsrichtungen';

  @override
  String get compassKeywords => 'kompass norden richtung orientierung';

  @override
  String get compassUnavailable => 'Kein Kompass auf diesem Gerät.';

  @override
  String get compassWaiting => 'Warte auf Sensor…';

  @override
  String get compassHint =>
      'Halten Sie das Handy waagerecht, fern von Metall und Magneten. Wenn die Richtung seltsam ist, bewegen Sie das Handy in Form einer 8.';

  @override
  String get cardinals => 'N,NO,O,SO,S,SW,W,NW';

  @override
  String get locationTitle => 'Standort';

  @override
  String get locationSubtitle => 'GPS-Koordinaten für den Notruf';

  @override
  String get locationKeywords =>
      'standort position gps koordinaten wo bin ich karte utm mgrs';

  @override
  String get locServiceOff =>
      'Die Ortung ist ausgeschaltet. Schalten Sie sie in den Handy-Einstellungen ein: GPS funktioniert auch im Flugmodus.';

  @override
  String get locDenied =>
      'Standortzugriff verweigert. Sie können ihn in den Handy-Einstellungen erlauben.';

  @override
  String get locUnavailable => 'Standort auf diesem Gerät nicht verfügbar.';

  @override
  String gpsError(String error) {
    return 'GPS-Fehler: $error';
  }

  @override
  String get searchingSats => 'Suche Satelliten… Im Freien geht es schneller.';

  @override
  String get fmtDecimal => 'Dezimal';

  @override
  String get fmtDms => 'Grad, Minuten, Sekunden';

  @override
  String get fmtMgrs => 'MGRS (Militär, Rettungsdienste)';

  @override
  String get altitude => 'Höhe';

  @override
  String get accuracy => 'Genauigkeit';

  @override
  String get copy => 'Kopieren';

  @override
  String get copied => 'Kopiert';

  @override
  String locHint(String number) {
    return 'Am Telefon mit der $number die Dezimal-Koordinaten durchgeben.';
  }

  @override
  String get westLetter => 'W';

  @override
  String get suppliesTitle => 'Vorräte';

  @override
  String get suppliesSubtitle => 'Wasser und Essen für Personen und Tage';

  @override
  String get suppliesKeywords =>
      'vorrat vorräte wasser essen lebensmittel rationen wie viel berechnen';

  @override
  String get people => 'Personen';

  @override
  String get days => 'Tage';

  @override
  String get suppliesNote =>
      'Die EU empfiehlt mindestens 72 Stunden Selbstversorgung; länger ist besser. Die Berechnung nimmt 4 Liter Wasser pro Person und Tag (3 zum Trinken, 1 zum Kochen und Waschen) und 2000 kcal an. Das sind Richtwerte für Erwachsene: Hitze, Anstrengung, Kinder und ältere Menschen verändern den Bedarf. Verbrauchen Sie zuerst die ältesten Vorräte.';

  @override
  String get falloutTitle => 'Fallout';

  @override
  String get falloutSubtitle =>
      'Timer nach einer Explosion: was wann zu tun ist';

  @override
  String get falloutKeywords =>
      'fallout strahlung radioaktiv dosimeter atom nuklear 7 10 zerfall';

  @override
  String get measuredRate => 'Gemessene Dosisleistung';

  @override
  String falloutDose(String dose) {
    return 'Bei 24 Stunden im Freien: etwa $dose. Drinnen, in der Mitte eines massiven Gebäudes oder im Keller, ist es viel weniger.';
  }

  @override
  String get resetChecklistQ => 'Liste zurücksetzen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String doneOf(int done, int total) {
    return '$done von $total';
  }

  @override
  String get encyclopedias => 'Offline-Lexika';

  @override
  String get noEncyclopedias =>
      'Kein Lexikon auf dem Handy. Laden Sie es herunter, solange Sie Internet haben: Danach funktioniert es auch ohne Netz.';

  @override
  String get iosImportHint =>
      'Sehr große Dateien: Laden Sie sie am Computer von download.kiwix.org herunter und kopieren Sie sie mit dem Finder oder der Dateien-App in den Ordner Refuge › zim. Tippen Sie dann auf ↻.';

  @override
  String get deleteFromDevice => 'Vom Handy löschen';

  @override
  String deleteQ(String title) {
    return '„$title“ löschen?';
  }

  @override
  String deleteBody(String size) {
    return 'Dadurch werden $size frei. Um es wieder zu nutzen, müssen Sie es erneut herunterladen.';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get dlWaiting => 'Wartet (WLAN nötig, falls eingestellt)…';

  @override
  String get dlRetrying => 'Verbindung verloren, neuer Versuch…';

  @override
  String dlPaused(String pct) {
    return 'Pausiert · $pct%';
  }

  @override
  String get resume => 'Fortsetzen';

  @override
  String get pause => 'Pause';

  @override
  String get catalogSearchHint => 'Im Kiwix-Katalog suchen';

  @override
  String get catalogUnreachable =>
      'Katalog nicht erreichbar. Eine Internetverbindung ist nötig.';

  @override
  String get recWikimed => 'WikiMed: medizinisches Lexikon (Englisch)';

  @override
  String get recWikipediaMedicine => 'Wikipedia: nur Medizin';

  @override
  String get recWikipedia => 'Wikipedia komplett';

  @override
  String get recWikivoyage => 'Wikivoyage: Länder und Städte';

  @override
  String get recMedicalTextbooks => 'Medizinische Lehrbücher (Englisch)';

  @override
  String resultsFor(String query) {
    return 'Ergebnisse für „$query“';
  }

  @override
  String get flavourMini => 'Mini, nur Einleitungen';

  @override
  String get flavourNopic => 'Ohne Bilder';

  @override
  String get flavourMaxi => 'Mit Bildern';

  @override
  String get flavourFull => 'Komplett';

  @override
  String get zimitUnsupported =>
      'Archivierte Website: Format noch nicht unterstützt';

  @override
  String get download => 'Herunterladen';

  @override
  String downloadQ(String size) {
    return '$size herunterladen?';
  }

  @override
  String get downloadBody =>
      'Prüfen Sie, ob genug Speicher frei ist. Der Download läuft auch bei geschlossener App weiter und setzt dort fort, wo er unterbrochen wurde.';

  @override
  String get wifiOnly => 'Nur über WLAN';

  @override
  String get externalLink => 'Externer Link: offline nicht verfügbar.';

  @override
  String get mainPage => 'Hauptseite';

  @override
  String get searchByTitle => 'Nach Titel suchen';

  @override
  String get searchByTitleTip =>
      'Geben Sie den Anfang eines Artikeltitels ein.';

  @override
  String get searchDocument => 'Im Dokument suchen (auf Englisch)';

  @override
  String pagesN(int n) {
    return '$n Seiten';
  }

  @override
  String get license => 'Lizenz';

  @override
  String get reproducedInFull =>
      'Dokument vollständig und unverändert wiedergegeben.';

  @override
  String get notAvailable => 'In dieser Version nicht verfügbar.';

  @override
  String entryMissing(String title) {
    return 'Artikel „$title“ nicht gefunden: Laden Sie WikiMed in der Bibliothek herunter, um ihn offline zu lesen.';
  }

  @override
  String get needsTitle => 'Bedarf';

  @override
  String get summaryTitle => 'Übersicht';

  @override
  String get inventoryTitle => 'Bestand';

  @override
  String get inventoryHint =>
      'Fügen Sie Bereich für Bereich hinzu, was Sie zu Hause haben. Tippen Sie dann auf +, wenn Sie etwas kaufen, und auf −, wenn Sie etwas verbrauchen.';

  @override
  String get catWater => 'Wasser';

  @override
  String get catFood => 'Essen';

  @override
  String get catGas => 'Gas zum Kochen';

  @override
  String get catOther => 'Sonstiges';

  @override
  String coversDays(String days) {
    return 'Reicht für $days Tage';
  }

  @override
  String missingWater(String liters, int bottles) {
    return 'Es fehlen $liters L ≈ $bottles Flaschen à 1,5 L';
  }

  @override
  String missingFood(String kcal, String kg) {
    return 'Es fehlen $kcal kcal ≈ $kg kg Nudeln oder Reis';
  }

  @override
  String missingGas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Kartuschen',
      one: '1 Kartusche',
    );
    return 'Es fehlen $_temp0 à 220 g';
  }

  @override
  String mealsHave(int have, int need) {
    return '$have / $need warme Mahlzeiten';
  }

  @override
  String get addItem => 'Hinzufügen';

  @override
  String get addOne => 'Eins hinzufügen';

  @override
  String get consumeOne => 'Eins entfernen';

  @override
  String get itemName => 'Name';

  @override
  String get unitSize => 'Inhalt einer Packung';

  @override
  String get kcalPer100 => 'kcal pro 100 g';

  @override
  String get quantity => 'Menge';

  @override
  String get save => 'Speichern';

  @override
  String get chooseProduct => 'Was möchten Sie hinzufügen?';

  @override
  String get chooseSize => 'Größe';

  @override
  String get otherSize => 'Andere Größe';

  @override
  String get addToInventory => 'Zum Bestand hinzufügen';

  @override
  String get otherItemHint => 'Gegenstand eingeben, z. B. Taschenlampe';

  @override
  String get suggestions => 'Vorschläge';

  @override
  String get otherSuggestions =>
      'Bargeld,Kopien der Dokumente,Wichtige Nummern auf Papier,Ersatzschlüssel,Decken,Schlafsäcke,Warme Kleidung,Rettungsdecke,Trillerpfeife,Müllbeutel,Gewebeband,Plastikplanen,Seil,Taschenmesser,Feuerlöscher,Tierfutter';

  @override
  String get pWaterBottle => 'Wasserflasche';

  @override
  String get pWaterTank => 'Wasserkanister';

  @override
  String get pPasta => 'Nudeln';

  @override
  String get pRice => 'Reis';

  @override
  String get pDryLegumes => 'Getrocknete Hülsenfrüchte';

  @override
  String get pCannedLegumes => 'Hülsenfrüchte in Dosen';

  @override
  String get pTuna => 'Thunfisch in Dosen';

  @override
  String get pCannedMeat => 'Fleisch in Dosen';

  @override
  String get pCannedVeg => 'Gemüse in Dosen';

  @override
  String get pNuts => 'Nüsse und Trockenobst';

  @override
  String get pBiscuits => 'Kekse, Cracker';

  @override
  String get pBars => 'Riegel';

  @override
  String get pUhtMilk => 'H-Milch';

  @override
  String get pPowderMilk => 'Milchpulver';

  @override
  String get pOil => 'Öl';

  @override
  String get pSugar => 'Zucker';

  @override
  String get pHoney => 'Honig';

  @override
  String get pCustomFood => 'Anderes Lebensmittel';

  @override
  String get pCartridge => 'Gaskartusche';

  @override
  String get pCustomOther => 'Anderer Gegenstand';

  @override
  String get falloutStartIntro =>
      'Wenn es eine Atomexplosion gab, starten Sie den Timer: Er zeigt, wie lange Sie in Deckung bleiben sollen, was zu tun ist und was Sie jeweils tragen sollen.';

  @override
  String get falloutStartNow => 'Explosion jetzt: starten';

  @override
  String get falloutStartAt => 'Uhrzeit der Explosion einstellen';

  @override
  String get falloutResetQ => 'Timer zurücksetzen?';

  @override
  String falloutSince(String time) {
    return 'Explosion: $time';
  }

  @override
  String durationHM(int h, int m) {
    return '$h h $m min';
  }

  @override
  String durationDHM(int d, int h, int m) {
    return '$d T $h h $m min';
  }

  @override
  String get falloutMax =>
      'Strahlung am höchsten: Jetzt ist es am gefährlichsten.';

  @override
  String falloutRemaining(String pct) {
    return 'Strahlung bei etwa $pct des Werts 1 Stunde nach der Explosion.';
  }

  @override
  String falloutNextPhase(String left, String time) {
    return 'Nächste Phase in $left (um $time)';
  }

  @override
  String get whatToWear => 'Wenn Sie hinausmüssen';

  @override
  String get whatToDoNow => 'Was jetzt zu tun ist';

  @override
  String get falloutTimeline => 'Phasen';

  @override
  String get doNotGoOut => 'Nicht hinausgehen';

  @override
  String get falloutBannerOut =>
      'Nur wenn nötig hinausgehen, von Kopf bis Fuß bedeckt';

  @override
  String get wearMask => 'FFP2/FFP3-Maske';

  @override
  String get wearGloves => 'Handschuhe';

  @override
  String get wearCovered => 'Mütze, lange Ärmel, Regenjacke';

  @override
  String get wearBoots => 'Geschlossene Schuhe oder Stiefel';

  @override
  String get phase0Title => 'Höchste Gefahr: sofort Schutz suchen';

  @override
  String get phase0a =>
      'Gehen Sie in das stabilste Gebäude in der Nähe, in die Gebäudemitte oder in den Keller.';

  @override
  String get phase0b =>
      'Türen und Fenster schließen, Lüftung und Klimaanlage ausschalten.';

  @override
  String get phase0c =>
      'Wenn Sie draußen waren: Kleidung ausziehen, in einem Beutel verschließen und sich waschen.';

  @override
  String get phase0d => 'Auf keinen Fall hinausgehen.';

  @override
  String get phase1Title => 'In Deckung bleiben';

  @override
  String get phase1a =>
      'Die Strahlung sinkt schnell: Nach 7 Stunden beträgt sie nur noch etwa ein Zehntel.';

  @override
  String get phase1b => 'Drinnen bleiben, fern von Außenwänden und Dach.';

  @override
  String get phase1c =>
      'Radio, Fernsehen und Warnungen auf dem Handy verfolgen.';

  @override
  String get phase1d =>
      'Nur aus geschlossenen Verpackungen essen und trinken. Nur hinausgehen, wenn Ihr Unterschlupf in Gefahr ist (Brand, Einsturz).';

  @override
  String get phase2Title => 'Nur hinausgehen, wenn unbedingt nötig';

  @override
  String get phase2a =>
      'Folgen Sie den Behörden: Sie können einen Ortswechsel oder eine Evakuierung anordnen.';

  @override
  String get phase2b => 'Nur sehr kurz hinausgehen, von Kopf bis Fuß bedeckt.';

  @override
  String get phase2c =>
      'Bei der Rückkehr die Oberbekleidung vor dem Hineingehen ausziehen und sich waschen.';

  @override
  String get phase3Title => 'Gefahr nimmt ab';

  @override
  String get phase3a =>
      'Nach 2 Tagen ist die Strahlung etwa ein Hundertstel des Anfangswerts.';

  @override
  String get phase3b =>
      'Kurz hinausgehen, wenn nötig, mit Schutz. Staub vermeiden.';

  @override
  String get phase3c =>
      'Keine Lebensmittel essen, die im Freien lagen, und Wasser aus geschlossenen Behältern verwenden.';

  @override
  String get phase4Title => 'Gefahr stark verringert';

  @override
  String get phase4a =>
      'Nach 2 Wochen ist die Strahlung etwa ein Tausendstel des Anfangswerts.';

  @override
  String get phase4b =>
      'Für die Rückkehr zur Normalität den Anweisungen der Behörden folgen.';

  @override
  String get phase4c => 'Vorsichtsmaßnahmen bei Essen und Wasser beibehalten.';

  @override
  String get falloutDisclaimer =>
      'Allgemeine Hinweise nach der 7-10-Regel. Wann Sie hinausgehen können, entscheiden die Behörden und echte Messungen mit einem Dosimeter.';

  @override
  String get haveDosimeter => 'Haben Sie ein Dosimeter?';

  @override
  String inHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Stunden',
      one: '1 Stunde',
    );
    return 'In $_temp0';
  }

  @override
  String get levelFlat => 'Waagerecht';

  @override
  String get levelAlmost => 'Fast waagerecht';

  @override
  String get levelTilted => 'Halten Sie das Handy waagerecht';

  @override
  String tiltDegrees(int n) {
    return 'Neigung $n°';
  }

  @override
  String get mapsTitle => 'Offline-Karten';

  @override
  String get onbMapTitle => 'Offline-Karte';

  @override
  String get onbMapBody =>
      'Wählen Sie, welche Karten auf dem Telefon bleiben sollen. Sie funktionieren ohne Internet, mit Ihrer GPS-Position.';

  @override
  String get mapWorld => 'Welt';

  @override
  String get mapWorldBody => 'Alle Länder, große Städte und Hauptstraßen.';

  @override
  String get mapEurope => 'Europa';

  @override
  String get mapEuropeBody => 'Städte, Orte und Hauptstraßen in ganz Europa.';

  @override
  String mapCountry(String name) {
    return '$name im Detail';
  }

  @override
  String get mapCountryBody =>
      'Alle Straßen, Gassen und Wege, bis zu einzelnen Gebäuden.';

  @override
  String get mapKeepOpen =>
      'Lassen Sie die App geöffnet, bis der Download abgeschlossen ist.';

  @override
  String get mapDownloadSelected => 'Ausgewählte Karten laden';

  @override
  String get mapReady => 'Geladen';

  @override
  String get mapFailed => 'Download fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String mapDownloading(String pct, String size) {
    return '$pct % von $size';
  }

  @override
  String get mapPreparing => 'Vorbereitung…';

  @override
  String get mapSizeCalc => 'Größe wird berechnet…';

  @override
  String get mapSizeUnknown => 'Größe nicht verfügbar (Internet nötig)';

  @override
  String get mapNone =>
      'Keine Offline-Karte vorhanden. Laden Sie eine, um auch ohne Internet zu sehen, wo Sie sind.';

  @override
  String get mapDownloadButton => 'Karten laden';

  @override
  String get mapSkip => 'Überspringen, später erledigen';

  @override
  String get zoomIn => 'Vergrößern';

  @override
  String get zoomOut => 'Verkleinern';

  @override
  String get wholeWorld => 'Ganze Welt';

  @override
  String get myPosition => 'Meine Position';

  @override
  String downloadsActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Downloads laufen',
      one: 'Download läuft',
    );
    return '$_temp0';
  }

  @override
  String get mapsOnPhone => 'Auf dem Telefon';

  @override
  String get mapsInProgress => 'Wird geladen';

  @override
  String get mapsAvailable => 'Verfügbar';

  @override
  String get mapUpdate => 'Auf neueste Version aktualisieren';

  @override
  String mapUpdatedOn(String date) {
    return 'vom $date';
  }

  @override
  String get mapsMoreBody =>
      'Karten der Welt, Europas und einzelner Länder laden, aktualisieren oder löschen';

  @override
  String get energySuggestions =>
      'Stirnlampe,Kerzen,Streichhölzer,Feuerzeug,Batterieradio,Kurbelradio';

  @override
  String get healthSuggestions =>
      'Eigene Medikamente,Schmerzmittel,Erste-Hilfe-Set,Elektrolytpulver,Wasserentkeimungstabletten,FFP2-Masken,Einweghandschuhe,Ersatzbrille,Toilettenpapier,Seife,Handdesinfektion,Feuchttücher,Binden,Windeln,Eimer mit Deckel,Katzenstreu oder Sägemehl';

  @override
  String get catEnergy => 'Energie und Licht';

  @override
  String get catHealth => 'Gesundheit und Hygiene';

  @override
  String get emptySection => 'Noch nichts. Tippen Sie auf „Hinzufügen“.';

  @override
  String get catElectricity => 'Strom';

  @override
  String chargesHave(int have, int need) {
    return '$have / $need Ladungen';
  }

  @override
  String missingCharges(int n, int pb) {
    return 'Es fehlen $n Handyladungen ≈ $pb Powerbanks mit 10.000 mAh';
  }

  @override
  String get electricityBasis =>
      'Berechnung: 1 volle Handyladung pro Person und Tag. Powerbanks mit 65 % und Powerstations mit 85 % der angegebenen Kapazität.';

  @override
  String solarExtra(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Solarpanels',
      one: '1 Solarpanel',
    );
    return 'Zusätzlich $_temp0 zum Laden mit Sonnenlicht';
  }

  @override
  String get pPowerBank => 'Powerbank';

  @override
  String get pPowerStation => 'Powerstation';

  @override
  String get pSolarPanel => 'Solarpanel';

  @override
  String get pBatteriesAA => 'Batterien AA';

  @override
  String get pBatteriesAAA => 'Batterien AAA';

  @override
  String get radioTitle => 'Radio im Notfall';

  @override
  String get radioSubtitle => 'Was hören und auf welchen Frequenzen';

  @override
  String get radioKeywords =>
      'radio frequenz ukw fm mittelwelle dab nachrichten behörden funkgerät walkie talkie pmr';

  @override
  String get radioListen => 'Was hören';

  @override
  String get radioListenBody =>
      'Diese Sender verbreiten im Notfall die offiziellen Meldungen der Behörden.';

  @override
  String get radioFm => 'UKW in den großen Städten';

  @override
  String get radioAm => 'Mittel- und Langwelle (AM)';

  @override
  String get radioAmNote => 'Nachts reichen Mittel- und Langwelle viel weiter.';

  @override
  String get radioDab => 'Digitalradio DAB+';

  @override
  String get radioNationwide => 'Bundesweit';

  @override
  String get radioNoData =>
      'Für dieses Land gibt es noch keine geprüften Daten.';

  @override
  String get radioNotFound => 'Wenn Sie den Sender nicht finden';

  @override
  String get radioTip1 =>
      'Lassen Sie den Sendersuchlauf über das ganze UKW-Band laufen, dann über AM.';

  @override
  String get radioTip2 =>
      'Gehen Sie ans Fenster oder in ein höheres Stockwerk und ziehen Sie die Antenne ganz aus.';

  @override
  String get radioTip3 =>
      'UKW-Frequenzen ändern sich je nach Region: Hier stehen die der großen Städte.';

  @override
  String get radioTip4 =>
      'Hören Sie zu festen Zeiten, zu Beginn jeder Stunde, um Batterien zu sparen.';

  @override
  String get radioWhich => 'Welches Radio zu Hause';

  @override
  String get radioWhich1 =>
      'Ein Kurbel- oder Batterieradio mit UKW, Mittelwelle (AM) und möglichst DAB+ und Kurzwelle.';

  @override
  String get radioWhich2 =>
      'Ersatzbatterien gleicher Größe, getrennt aufbewahrt.';

  @override
  String get radioWhich3 =>
      'Es funktioniert auch, wenn das Handy leer und das Netz ausgefallen ist.';

  @override
  String get pmrTitle => 'PMR446-Funkgeräte';

  @override
  String get pmrBody =>
      'In ganz Europa ohne Lizenz nutzbar (0,5 W, meist 1-3 km). Vereinbaren Sie einen Kanal in der Familie.';

  @override
  String pmrChannel(int n) {
    return 'Kan. $n';
  }

  @override
  String get radioOpsec =>
      'Empfangen ist sicher: Wer zuhört, sendet kein Signal. Senden kann geortet werden: Im Kriegsgebiet wenig, kurz und nur wenn nötig funken.';

  @override
  String radioChecked(String date) {
    return 'Daten am $date anhand offizieller Quellen geprüft.';
  }

  @override
  String radioFinder(String name) {
    return 'Frequenz für Ihre Region finden (online): $name';
  }

  @override
  String get docDownloadFailed =>
      'Download fehlgeschlagen. Verbindung prüfen und erneut versuchen.';

  @override
  String docDownloading(String pct) {
    return 'Wird geladen… $pct %';
  }

  @override
  String docToDownload(String size) {
    return 'Zum Herunterladen · $size';
  }

  @override
  String get docNotDownloaded =>
      'Laden Sie das Dokument zuerst in der Bibliothek herunter.';

  @override
  String get planTitle => 'Notfallplan der Familie';

  @override
  String get planSubtitle => 'Kontakte, Treffpunkte, wer wem hilft';

  @override
  String get planIntro =>
      'Sprechen Sie sich vorher gemeinsam ab: im Notfall funktionieren Telefon und Internet vielleicht nicht.';

  @override
  String get planContacts => 'Notfallkontakte';

  @override
  String get planContactsHint =>
      'Name und Telefon von 2–3 Personen, auch eine außerhalb der Stadt';

  @override
  String get planMeetNear => 'Treffpunkt in der Nähe der Wohnung';

  @override
  String get planMeetNearHint => 'Z. B. vor der Apotheke an der Ecke';

  @override
  String get planMeetFar => 'Treffpunkt außerhalb des Viertels';

  @override
  String get planMeetFarHint => 'Falls Sie nicht nach Hause können';

  @override
  String get planShelter => 'Nächster Schutzraum oder Sammelplatz';

  @override
  String get planShelterHint => 'Den Ihre Gemeinde angibt';

  @override
  String get planChildren => 'Wer holt die Kinder ab';

  @override
  String get planChildrenHint =>
      'Schule, Kita, und wer sie abholt, wenn Sie nicht können';

  @override
  String get planHelp => 'Wer Hilfe braucht';

  @override
  String get planHelpHint =>
      'Ältere Menschen, Menschen mit Behinderung, Haustiere: wer hilft und wie';

  @override
  String get planHealth => 'Medikamente und medizinische Angaben';

  @override
  String get planHealthHint => 'Medikamente, Allergien, medizinische Geräte';

  @override
  String get planNotes => 'Weitere Notizen';

  @override
  String get planCopy => 'Plan kopieren';

  @override
  String get planCopied =>
      'Plan kopiert: in eine Nachricht einfügen oder ausdrucken.';

  @override
  String get planPaper =>
      'Schreiben Sie den Plan auch auf Papier und bewahren Sie ihn bei den Vorräten auf. Geben Sie ihn Ihren Notfallkontakten.';
}
