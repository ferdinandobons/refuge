// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Refuge';

  @override
  String get tabEmergency => 'Emergenza';

  @override
  String get tabPrepare => 'Prepararsi';

  @override
  String get tabTools => 'Strumenti';

  @override
  String get tabMore => 'Altro';

  @override
  String get onbLanguageTitle => 'Scegli la lingua';

  @override
  String get onbCountryTitle => 'In che paese sei?';

  @override
  String get onbCountryHint =>
      'Serve per il numero di emergenza e le allerte locali. Puoi cambiarlo dopo.';

  @override
  String get onbReadyTitle => 'Tutto pronto';

  @override
  String onbReadyBody(String number) {
    return 'L\'app funziona senza internet. In emergenza chiama il $number.';
  }

  @override
  String get onbStart => 'Inizia';

  @override
  String get onbPackWikimed => 'WikiMed (inglese)';

  @override
  String get onbPackWikimedBody =>
      'Enciclopedia medica: malattie, sintomi, farmaci, ferite, primo soccorso.';

  @override
  String get onbPackWikipedia => 'Wikipedia nella tua lingua';

  @override
  String get onbPackWikipediaBody =>
      'Tutta la conoscenza generale: storia, luoghi, scienza, tecnica. Molto grande.';

  @override
  String get onbPackWikivoyage => 'Wikivoyage';

  @override
  String get onbPackWikivoyageBody =>
      'Paesi e città: come spostarsi, confini, ospedali, informazioni pratiche.';

  @override
  String get onbDownloadNote =>
      'I download continuano mentre usi l\'app e li vedi in cima alla schermata Emergenza. Puoi aggiungere o togliere contenuti quando vuoi da Strumenti › Manuali e guide.';

  @override
  String callNumber(String number) {
    return 'Chiama $number';
  }

  @override
  String get sosLight => 'SOS luce';

  @override
  String get searchHint => 'Cerca: sangue, iodio, terremoto…';

  @override
  String get searchTip =>
      'Scrivi cosa succede o cosa ti serve. Funziona anche con parole incomplete o con errori.';

  @override
  String get searchEmpty => 'Nessun risultato.';

  @override
  String get whatsHappening => 'Cosa succede?';

  @override
  String get groupBody => 'Primo soccorso';

  @override
  String get groupDanger => 'Pericoli';

  @override
  String get groupSurvive => 'Sopravvivenza';

  @override
  String get search => 'Cerca';

  @override
  String get readAloud => 'Leggi ad alta voce';

  @override
  String get allSteps => 'Tutti i passi';

  @override
  String get neverDo => 'Non fare';

  @override
  String get sources => 'Fonti';

  @override
  String stepOf(int n, int total) {
    return 'Passo $n di $total';
  }

  @override
  String get previous => 'Indietro';

  @override
  String get next => 'Avanti';

  @override
  String get done => 'Fatto';

  @override
  String get countryIT => 'Italia';

  @override
  String get countryFR => 'Francia';

  @override
  String get countryDE => 'Germania';

  @override
  String get countryES => 'Spagna';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryCH => 'Svizzera';

  @override
  String get countryBE => 'Belgio';

  @override
  String get countryNL => 'Paesi Bassi';

  @override
  String get countryLU => 'Lussemburgo';

  @override
  String get countryPT => 'Portogallo';

  @override
  String get countryGB => 'Regno Unito';

  @override
  String get countryIE => 'Irlanda';

  @override
  String get countryOther => 'Altro paese europeo';

  @override
  String get officialAlerts => 'allerte ufficiali';

  @override
  String get sirenFR =>
      'Allarme: suono che sale e scende per 1 minuto e 41 secondi, ripetuto 3 volte. Fine allarme: suono continuo di 30 secondi. Prova il primo mercoledì del mese a mezzogiorno.';

  @override
  String get sirenDE =>
      'Allarme: suono che sale e scende per 1 minuto. Fine allarme: suono continuo di 1 minuto.';

  @override
  String get sirenAT =>
      'Preallarme: suono continuo di 3 minuti. Allarme: suono che sale e scende per 1 minuto. Fine allarme: suono continuo di 1 minuto.';

  @override
  String get sirenCH =>
      'Allarme generale: suono che sale e scende per 1 minuto, ripetuto dopo 2 minuti. Ascolta la radio e segui le istruzioni.';

  @override
  String get noteIodineDE =>
      'In Germania le compresse di iodio non sono indicate per chi ha più di 45 anni.';

  @override
  String yourCountry(String name) {
    return 'Il tuo paese: $name';
  }

  @override
  String get emergencyNumber => 'Numero di emergenza';

  @override
  String get serviceAmbulance => 'Ambulanza';

  @override
  String get serviceFire => 'Vigili del fuoco';

  @override
  String get servicePolice => 'Polizia';

  @override
  String get servicePoison => 'Centro antiveleni';

  @override
  String get serviceDeafSms => 'SMS per persone sorde';

  @override
  String get phoneAlerts => 'Allerte sul telefono';

  @override
  String phoneAlertsBody(String name) {
    return '$name: arrivano da sole sul telefono, anche senza app. Tienile attive nelle impostazioni del telefono.';
  }

  @override
  String get sirens => 'Sirene';

  @override
  String get checklists => 'Provviste e piano';

  @override
  String get offlineContent => 'Da scaricare finché c\'è internet';

  @override
  String get downloadEncyclopedias => 'Scarica enciclopedie';

  @override
  String get downloadEncyclopediasBody =>
      'Wikipedia e WikiMed nella tua lingua, da leggere senza rete.';

  @override
  String get library => 'Manuali e guide';

  @override
  String get libraryBody =>
      'Documenti ufficiali europei, guide della Protezione Civile ed enciclopedie offline';

  @override
  String get originalTexts => 'Testi originali';

  @override
  String get originalTextsBody =>
      'Testi integrali della Protezione Civile italiana (in italiano)';

  @override
  String get originalTextsNote =>
      'Testi completi nella lingua originale, per approfondire.';

  @override
  String get language => 'Lingua';

  @override
  String get country => 'Paese';

  @override
  String get about => 'Informazioni';

  @override
  String get aboutBody => 'Fonti, licenze e avvertenze';

  @override
  String get aboutText =>
      'App open source che funziona senza internet.\n\nLe schede di emergenza seguono le linee guida europee: primo soccorso del Consiglio Europeo di Rianimazione (ERC 2025) e della Croce Rossa (IFRC), preparazione secondo le linee guida dell\'Unione Europea sulle 72 ore, e le indicazioni delle protezioni civili nazionali. I documenti originali e le enciclopedie sono in Manuali e guide, con fonti e licenze.\n\nQuesta app non sostituisce un corso di primo soccorso né le indicazioni delle autorità.';

  @override
  String get documents => 'Documenti';

  @override
  String get documentsBody =>
      'Documenti ufficiali europei e internazionali, nella tua lingua quando esistono, altrimenti in inglese. Alcuni sono già nell\'app, gli altri si scaricano dal sito ufficiale.';

  @override
  String get torchTitle => 'Torcia e SOS';

  @override
  String get torchSubtitle => 'Luce, SOS lampeggiante, luce dello schermo';

  @override
  String get torchKeywords => 'torcia luce buio sos lampeggiante segnale notte';

  @override
  String get torchOn => 'Accendi torcia';

  @override
  String get torchOff => 'Spegni torcia';

  @override
  String get torchMissing =>
      'Torcia non disponibile su questo dispositivo. Usa la luce dello schermo.';

  @override
  String get sosBlinking => 'SOS lampeggiante';

  @override
  String get sosStop => 'Ferma SOS';

  @override
  String get screenLight => 'Luce dello schermo';

  @override
  String get sosInfo =>
      'SOS = ··· ─── ··· ripetuto. Segnale internazionale di soccorso, visibile di notte anche da lontano.';

  @override
  String get tapToClose => 'Tocca per chiudere';

  @override
  String get morseTitle => 'Morse';

  @override
  String get morseSubtitle => 'Trasmetti un messaggio con la luce';

  @override
  String get morseKeywords => 'morse codice segnale luce messaggio';

  @override
  String get morseMessage => 'Messaggio';

  @override
  String get useTorchToo => 'Usa anche la torcia';

  @override
  String get repeat => 'Ripeti';

  @override
  String morseSpeed(int ms) {
    return 'Velocità: punto = $ms ms';
  }

  @override
  String get transmit => 'Trasmetti';

  @override
  String get stop => 'Ferma';

  @override
  String get morseTable => 'Tabella';

  @override
  String get compassTitle => 'Bussola';

  @override
  String get compassSubtitle => 'Direzione e punti cardinali';

  @override
  String get compassKeywords => 'bussola nord direzione orientamento';

  @override
  String get compassUnavailable =>
      'Bussola non disponibile su questo dispositivo.';

  @override
  String get compassWaiting => 'In attesa del sensore…';

  @override
  String get compassHint =>
      'Tieni il telefono in piano, lontano da metalli e magneti. Se la direzione è strana, muovi il telefono disegnando un 8.';

  @override
  String get cardinals => 'N,NE,E,SE,S,SO,O,NO';

  @override
  String get locationTitle => 'Posizione e mappe';

  @override
  String get locationSubtitle =>
      'Coordinate GPS per i soccorsi e mappe offline';

  @override
  String get locationKeywords =>
      'posizione gps coordinate dove sono mappa utm mgrs mappe offline scarica';

  @override
  String get locServiceOff =>
      'La localizzazione è disattivata. Attivala nelle impostazioni del telefono: il GPS funziona anche in modalità aereo.';

  @override
  String get locDenied =>
      'Permesso di posizione negato. Puoi concederlo nelle impostazioni del telefono.';

  @override
  String get locUnavailable =>
      'Posizione non disponibile su questo dispositivo.';

  @override
  String gpsError(String error) {
    return 'Errore GPS: $error';
  }

  @override
  String get searchingSats => 'Ricerca satelliti… All\'aperto è più veloce.';

  @override
  String get fmtDecimal => 'Decimale';

  @override
  String get fmtDms => 'Gradi, minuti, secondi';

  @override
  String get fmtMgrs => 'MGRS (militari, soccorsi)';

  @override
  String get altitude => 'Altitudine';

  @override
  String get accuracy => 'Precisione';

  @override
  String get copy => 'Copia';

  @override
  String get copied => 'Copiato';

  @override
  String locHint(String number) {
    return 'Al telefono con il $number detta le coordinate decimali. Il percorso si registra solo con questa schermata aperta.';
  }

  @override
  String get westLetter => 'O';

  @override
  String get suppliesTitle => 'Scorte';

  @override
  String get suppliesSubtitle => 'Cosa hai, cosa manca e quanto: casa e zaino';

  @override
  String get suppliesKeywords =>
      'scorte acqua cibo razioni quanto calcolo provviste zaino casa inventario';

  @override
  String get people => 'Persone';

  @override
  String get days => 'Giorni';

  @override
  String get suppliesNote =>
      'L\'UE raccomanda almeno 72 ore di autonomia; meglio di più. Il calcolo usa 4 litri d\'acqua a persona al giorno (3 da bere, 1 per cucinare e lavarsi) e 2000 kcal. Sono valori indicativi per adulti: caldo, fatica, bambini e anziani cambiano il fabbisogno. Consuma prima le scorte più vecchie.';

  @override
  String get falloutTitle => 'Fallout';

  @override
  String get falloutSubtitle => 'Timer dopo un\'esplosione: cosa fare e quando';

  @override
  String get falloutKeywords =>
      'fallout radiazioni dosimetro nucleare 7 10 decadimento';

  @override
  String get measuredRate => 'Intensità misurata';

  @override
  String falloutDose(String dose) {
    return 'Restando all\'aperto 24 ore: circa $dose. Al chiuso, al centro di un edificio solido o in cantina, è molto meno.';
  }

  @override
  String get resetChecklistQ => 'Azzerare la lista?';

  @override
  String get cancel => 'Annulla';

  @override
  String get reset => 'Azzera';

  @override
  String doneOf(int done, int total) {
    return '$done di $total';
  }

  @override
  String get encyclopedias => 'Enciclopedie offline';

  @override
  String get noEncyclopedias =>
      'Nessuna enciclopedia sul telefono. Scaricala finché hai internet: poi funziona anche senza rete.';

  @override
  String get iosImportHint =>
      'File molto grandi: scaricali sul computer da download.kiwix.org e copiali con il Finder o l\'app File nella cartella Refuge › zim, poi tocca ↻.';

  @override
  String get deleteFromDevice => 'Elimina dal telefono';

  @override
  String deleteQ(String title) {
    return 'Eliminare «$title»?';
  }

  @override
  String deleteBody(String size) {
    return 'Libererai $size. Per riaverla dovrai scaricarla di nuovo.';
  }

  @override
  String get delete => 'Elimina';

  @override
  String get dlWaiting => 'In attesa (serve il Wi-Fi se richiesto)…';

  @override
  String get dlRetrying => 'Connessione persa, riprovo…';

  @override
  String dlPaused(String pct) {
    return 'In pausa · $pct%';
  }

  @override
  String get resume => 'Riprendi';

  @override
  String get pause => 'Pausa';

  @override
  String get catalogSearchHint => 'Cerca nel catalogo Kiwix';

  @override
  String get catalogUnreachable =>
      'Catalogo non raggiungibile. Serve una connessione a internet.';

  @override
  String get recWikimed => 'WikiMed: enciclopedia medica (inglese)';

  @override
  String get recWikipediaMedicine => 'Wikipedia: solo medicina';

  @override
  String get recWikipedia => 'Wikipedia completa';

  @override
  String get recWikivoyage => 'Wikivoyage: paesi e città';

  @override
  String get recMedicalTextbooks => 'Libri di testo di medicina (inglese)';

  @override
  String resultsFor(String query) {
    return 'Risultati per «$query»';
  }

  @override
  String get flavourMini => 'Mini, solo introduzioni';

  @override
  String get flavourNopic => 'Senza immagini';

  @override
  String get flavourMaxi => 'Con immagini';

  @override
  String get flavourFull => 'Completa';

  @override
  String get zimitUnsupported =>
      'Sito web archiviato: formato non ancora supportato';

  @override
  String get download => 'Scarica';

  @override
  String downloadQ(String size) {
    return 'Scaricare $size?';
  }

  @override
  String get downloadBody =>
      'Controlla di avere abbastanza spazio libero. Il download continua anche ad app chiusa e riprende da dove si era fermato.';

  @override
  String get wifiOnly => 'Solo con Wi-Fi';

  @override
  String get externalLink => 'Link esterno: non disponibile offline.';

  @override
  String get mainPage => 'Pagina principale';

  @override
  String get searchByTitle => 'Cerca per titolo';

  @override
  String get searchByTitleTip => 'Scrivi l\'inizio del titolo di una voce.';

  @override
  String get searchDocument => 'Cerca nel documento (in inglese)';

  @override
  String pagesN(int n) {
    return '$n pagine';
  }

  @override
  String get license => 'Licenza';

  @override
  String get reproducedInFull =>
      'Documento riprodotto integralmente, senza modifiche.';

  @override
  String get notAvailable => 'Non disponibile in questa versione.';

  @override
  String entryMissing(String title) {
    return 'Voce «$title» non trovata: scarica WikiMed da Manuali e guide per leggerla offline.';
  }

  @override
  String get catWater => 'Acqua';

  @override
  String get catFood => 'Cibo';

  @override
  String get catGas => 'Gas per cucinare';

  @override
  String coversDays(String days) {
    return 'Basta per $days giorni';
  }

  @override
  String missingWater(String liters, int bottles) {
    return 'Mancano $liters L ≈ $bottles bottiglie da 1,5 L';
  }

  @override
  String missingFood(String kcal, String kg) {
    return 'Mancano $kcal kcal ≈ $kg kg di pasta o riso';
  }

  @override
  String missingGas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartucce',
      one: '1 cartuccia',
    );
    return 'Mancano $_temp0 da 220 g';
  }

  @override
  String mealsHave(int have, int need) {
    return '$have / $need pasti caldi';
  }

  @override
  String get addItem => 'Aggiungi';

  @override
  String get addOne => 'Aggiungi uno';

  @override
  String get consumeOne => 'Togli uno';

  @override
  String get itemName => 'Nome';

  @override
  String get unitSize => 'Contenuto di una confezione';

  @override
  String get kcalPer100 => 'kcal ogni 100 g';

  @override
  String get quantity => 'Quantità';

  @override
  String get save => 'Salva';

  @override
  String get chooseProduct => 'Cosa vuoi aggiungere?';

  @override
  String get chooseSize => 'Formato';

  @override
  String get otherSize => 'Altro formato';

  @override
  String get addToInventory => 'Aggiungi all\'inventario';

  @override
  String get pWaterBottle => 'Bottiglia d\'acqua';

  @override
  String get pWaterTank => 'Tanica d\'acqua';

  @override
  String get pPasta => 'Pasta';

  @override
  String get pRice => 'Riso';

  @override
  String get pDryLegumes => 'Legumi secchi';

  @override
  String get pCannedLegumes => 'Legumi in scatola';

  @override
  String get pTuna => 'Tonno in scatola';

  @override
  String get pCannedMeat => 'Carne in scatola';

  @override
  String get pCannedVeg => 'Verdure in scatola';

  @override
  String get pNuts => 'Frutta secca';

  @override
  String get pBiscuits => 'Biscotti, cracker';

  @override
  String get pBars => 'Barrette';

  @override
  String get pUhtMilk => 'Latte a lunga conservazione';

  @override
  String get pPowderMilk => 'Latte in polvere';

  @override
  String get pOil => 'Olio';

  @override
  String get pSugar => 'Zucchero';

  @override
  String get pHoney => 'Miele';

  @override
  String get pCustomFood => 'Altro cibo';

  @override
  String get pCartridge => 'Cartuccia di gas';

  @override
  String get pCustomOther => 'Altro oggetto';

  @override
  String get falloutStartIntro =>
      'Se c\'è stata un\'esplosione nucleare, avvia il timer: ti dice per quanto restare al riparo, cosa fare e cosa indossare in ogni momento.';

  @override
  String get falloutStartNow => 'Esplosione adesso: avvia';

  @override
  String get falloutStartAt => 'Imposta l\'ora dell\'esplosione';

  @override
  String get falloutResetQ => 'Azzerare il timer?';

  @override
  String falloutSince(String time) {
    return 'Esplosione: $time';
  }

  @override
  String durationHM(int h, int m) {
    return '$h h $m min';
  }

  @override
  String durationDHM(int d, int h, int m) {
    return '$d g $h h $m min';
  }

  @override
  String get falloutMax =>
      'Radiazioni al massimo: è il momento più pericoloso.';

  @override
  String falloutRemaining(String pct) {
    return 'Radiazioni circa al $pct rispetto a 1 ora dopo l\'esplosione.';
  }

  @override
  String falloutNextPhase(String left, String time) {
    return 'Prossima fase tra $left (alle $time)';
  }

  @override
  String get whatToWear => 'Se devi uscire';

  @override
  String get whatToDoNow => 'Cosa fare adesso';

  @override
  String get falloutTimeline => 'Fasi';

  @override
  String get doNotGoOut => 'Non uscire';

  @override
  String get falloutBannerOut =>
      'Esci solo se necessario, coperto dalla testa ai piedi';

  @override
  String get wearMask => 'Mascherina FFP2/FFP3';

  @override
  String get wearGloves => 'Guanti';

  @override
  String get wearCovered => 'Cappello, maniche lunghe, impermeabile';

  @override
  String get wearBoots => 'Scarpe chiuse o stivali';

  @override
  String get phase0Title => 'Pericolo massimo: al riparo subito';

  @override
  String get phase0a =>
      'Entra nell\'edificio più solido vicino a te e vai al centro o in cantina.';

  @override
  String get phase0b =>
      'Chiudi porte e finestre, spegni ventilazione e condizionatori.';

  @override
  String get phase0c =>
      'Se eri fuori: togli i vestiti, chiudili in un sacchetto e lavati.';

  @override
  String get phase0d => 'Non uscire per nessun motivo.';

  @override
  String get phase1Title => 'Resta al riparo';

  @override
  String get phase1a =>
      'Le radiazioni scendono in fretta: dopo 7 ore sono circa un decimo.';

  @override
  String get phase1b => 'Resta dentro, lontano da muri esterni e tetto.';

  @override
  String get phase1c => 'Ascolta radio, TV e allerte sul telefono.';

  @override
  String get phase1d =>
      'Bevi e mangia solo da confezioni chiuse. Esci solo se il riparo è in pericolo (incendio, crollo).';

  @override
  String get phase2Title => 'Esci solo se indispensabile';

  @override
  String get phase2a =>
      'Segui le autorità: possono indicare di spostarsi o evacuare.';

  @override
  String get phase2b =>
      'Fai solo uscite brevissime, coperto dalla testa ai piedi.';

  @override
  String get phase2c =>
      'Al rientro togli i vestiti esterni prima di entrare e lavati.';

  @override
  String get phase3Title => 'Pericolo in calo';

  @override
  String get phase3a =>
      'Dopo 2 giorni le radiazioni sono circa un centesimo di quelle iniziali.';

  @override
  String get phase3b =>
      'Fai uscite brevi, solo per necessità e con protezione. Evita la polvere.';

  @override
  String get phase3c =>
      'Non mangiare cibi rimasti all\'aperto e usa acqua da contenitori chiusi.';

  @override
  String get phase4Title => 'Pericolo molto ridotto';

  @override
  String get phase4a =>
      'Dopo 2 settimane le radiazioni sono circa un millesimo di quelle iniziali.';

  @override
  String get phase4b => 'Segui le autorità per il ritorno alla normalità.';

  @override
  String get phase4c => 'Continua le precauzioni su cibo e acqua.';

  @override
  String get falloutDisclaimer =>
      'Indicazioni generali basate sulla regola del 7-10. Quando uscire lo decidono le autorità e le misure reali con un dosimetro.';

  @override
  String get haveDosimeter => 'Hai un dosimetro?';

  @override
  String inHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ore',
      one: '1 ora',
    );
    return 'Tra $_temp0';
  }

  @override
  String get levelFlat => 'In piano';

  @override
  String get levelAlmost => 'Quasi in piano';

  @override
  String get levelTilted => 'Metti il telefono in piano';

  @override
  String tiltDegrees(int n) {
    return 'Inclinazione $n°';
  }

  @override
  String get mapsTitle => 'Mappe offline';

  @override
  String get onbMapTitle => 'Mappa offline';

  @override
  String get onbMapBody =>
      'Scegli quali mappe tenere sul telefono. Funzionano senza internet, con la tua posizione GPS.';

  @override
  String get mapWorld => 'Mondo';

  @override
  String get mapWorldBody =>
      'Tutti i paesi, le città principali e le grandi strade.';

  @override
  String get mapEurope => 'Europa';

  @override
  String get mapEuropeBody =>
      'Città, paesi e strade principali di tutta Europa.';

  @override
  String mapCountry(String name) {
    return '$name dettagliata';
  }

  @override
  String get mapCountryBody =>
      'Tutte le strade, le vie e i sentieri, fino al singolo edificio.';

  @override
  String get mapKeepOpen =>
      'Tieni l\'app aperta finché il download non finisce.';

  @override
  String get mapDownloadSelected => 'Scarica le mappe scelte';

  @override
  String get mapReady => 'Scaricata';

  @override
  String get mapFailed => 'Download non riuscito. Riprova.';

  @override
  String mapDownloading(String pct, String size) {
    return '$pct% di $size';
  }

  @override
  String get mapPreparing => 'Preparazione…';

  @override
  String get mapSizeCalc => 'Calcolo della dimensione…';

  @override
  String get mapSizeUnknown => 'Dimensione non disponibile (serve internet)';

  @override
  String get mapNone =>
      'Nessuna mappa offline. Scaricala per vedere dove sei anche senza internet.';

  @override
  String get mapDownloadButton => 'Scarica mappe';

  @override
  String get mapSkip => 'Salta, lo faccio dopo';

  @override
  String get zoomIn => 'Ingrandisci';

  @override
  String get zoomOut => 'Rimpicciolisci';

  @override
  String get wholeWorld => 'Tutto il mondo';

  @override
  String get myPosition => 'La mia posizione';

  @override
  String downloadsActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n download in corso',
      one: 'Download in corso',
    );
    return '$_temp0';
  }

  @override
  String get mapsOnPhone => 'Sul telefono';

  @override
  String get mapsInProgress => 'In corso';

  @override
  String get mapsAvailable => 'Disponibili';

  @override
  String get mapUpdate => 'Aggiorna all\'ultima versione';

  @override
  String mapUpdatedOn(String date) {
    return 'del $date';
  }

  @override
  String get mapsMoreBody =>
      'Scarica, aggiorna o elimina le mappe del mondo, dell\'Europa e dei paesi';

  @override
  String get emptySection => 'Niente ancora. Tocca «Aggiungi».';

  @override
  String get catElectricity => 'Elettricità';

  @override
  String chargesHave(int have, int need) {
    return '$have / $need ricariche';
  }

  @override
  String missingCharges(int n, int pb) {
    return 'Mancano $n ricariche del telefono ≈ $pb power bank da 10.000 mAh';
  }

  @override
  String get electricityBasis =>
      'Conto: 1 ricarica completa del telefono a persona al giorno. Power bank al 65% e power station all\'85% della capacità dichiarata.';

  @override
  String get pPowerBank => 'Power bank';

  @override
  String get pPowerStation => 'Power station';

  @override
  String get pSolarPanel => 'Pannello solare';

  @override
  String get pBatteriesAA => 'Batterie AA';

  @override
  String get pBatteriesAAA => 'Batterie AAA';

  @override
  String get radioTitle => 'Radio in emergenza';

  @override
  String get radioSubtitle => 'Cosa ascoltare e su quali frequenze';

  @override
  String get radioKeywords =>
      'radio frequenze fm am dab onde medie notizie autorità walkie talkie pmr';

  @override
  String get radioListen => 'Cosa ascoltare';

  @override
  String get radioListenBody =>
      'Sono le emittenti che trasmettono i messaggi ufficiali delle autorità durante un\'emergenza.';

  @override
  String get radioFm => 'FM nelle città principali';

  @override
  String get radioAm => 'Onde medie e lunghe (AM)';

  @override
  String get radioAmNote =>
      'Di notte le onde medie e lunghe arrivano molto più lontano.';

  @override
  String get radioDab => 'Radio digitale DAB+';

  @override
  String get radioNationwide => 'In tutto il paese';

  @override
  String get radioNoData =>
      'Per questo paese non ci sono ancora dati verificati.';

  @override
  String get radioNotFound => 'Se non trovi la stazione';

  @override
  String get radioTip1 =>
      'Fai la ricerca automatica su tutta la banda FM e poi su quella AM.';

  @override
  String get radioTip2 =>
      'Avvicinati a una finestra o sali di piano, ed estendi del tutto l\'antenna.';

  @override
  String get radioTip3 =>
      'Le frequenze FM cambiano da zona a zona: quelle qui sono delle città principali.';

  @override
  String get radioTip4 =>
      'Ascolta a orari fissi, all\'inizio di ogni ora, per risparmiare le batterie.';

  @override
  String get radioWhich => 'Che radio tenere in casa';

  @override
  String get radioWhich1 =>
      'Una radio a manovella o a pile con FM, onde medie (AM) e, se possibile, DAB+ e onde corte.';

  @override
  String get radioWhich2 =>
      'Batterie di ricambio dello stesso formato, conservate a parte.';

  @override
  String get radioWhich3 =>
      'Funziona anche se il telefono è scarico e la rete è giù.';

  @override
  String get pmrTitle => 'Walkie-talkie PMR446';

  @override
  String get pmrBody =>
      'Si usano senza licenza in tutta Europa (0,5 W, di solito 1-3 km). Accordati in famiglia su un canale.';

  @override
  String pmrChannel(int n) {
    return 'Can. $n';
  }

  @override
  String get radioOpsec =>
      'Ricevere è sicuro: chi ascolta non emette segnali. Trasmettere invece si può rilevare: in zona di guerra parla poco, brevemente e solo se serve.';

  @override
  String radioChecked(String date) {
    return 'Dati controllati su fonti ufficiali il $date.';
  }

  @override
  String radioFinder(String name) {
    return 'Cerca la frequenza della tua zona (online): $name';
  }

  @override
  String get docDownloadFailed =>
      'Download non riuscito. Controlla la connessione e riprova.';

  @override
  String docDownloading(String pct) {
    return 'Download… $pct%';
  }

  @override
  String docToDownload(String size) {
    return 'Da scaricare · $size';
  }

  @override
  String get docNotDownloaded =>
      'Scarica prima il documento da Manuali e guide.';

  @override
  String get planTitle => 'Piano di emergenza della famiglia';

  @override
  String get planSubtitle => 'Contatti, punti d\'incontro, chi aiuta chi';

  @override
  String get planIntro =>
      'Mettetevi d\'accordo prima, tutti insieme: in un\'emergenza il telefono e internet possono non funzionare.';

  @override
  String get planContacts => 'Contatti di emergenza';

  @override
  String get planContactsHint =>
      'Nome e telefono di 2–3 persone, anche una fuori città';

  @override
  String get planMeetNear => 'Punto d\'incontro vicino a casa';

  @override
  String get planMeetNearHint => 'Es. davanti alla farmacia all\'angolo';

  @override
  String get planMeetFar => 'Punto d\'incontro fuori dal quartiere';

  @override
  String get planMeetFarHint => 'Se non si può tornare a casa';

  @override
  String get planShelter => 'Rifugio o area di attesa più vicina';

  @override
  String get planShelterHint => 'Quella indicata dal comune';

  @override
  String get planChildren => 'Chi va a prendere i bambini';

  @override
  String get planChildrenHint =>
      'Scuola, asilo, e chi li prende se tu non puoi';

  @override
  String get planHelp => 'Chi ha bisogno di aiuto';

  @override
  String get planHelpHint =>
      'Anziani, persone con disabilità, animali: chi li aiuta e come';

  @override
  String get planHealth => 'Medicine e informazioni mediche';

  @override
  String get planHealthHint => 'Farmaci, allergie, dispositivi medici';

  @override
  String get planNotes => 'Altre note';

  @override
  String get planCopy => 'Copia il piano';

  @override
  String get planCopied =>
      'Piano copiato: incollalo in un messaggio o stampalo.';

  @override
  String get planPaper =>
      'Scrivi il piano anche su carta e tienilo con le scorte. Dallo alle persone dei contatti di emergenza.';

  @override
  String docDownloadAll(int n, String size) {
    return 'Scarica tutti ($n · $size)';
  }

  @override
  String docDownloadingAll(int n) {
    return 'Download… ne mancano $n';
  }

  @override
  String get civilProtectionGuides => 'Guide della Protezione Civile';

  @override
  String get civilProtectionGuidesBody =>
      'Cosa fare prima, durante e dopo: terremoto, alluvione, incendi boschivi, incidente industriale, maremoto, emergenza nucleare, dighe e vulcani. Testi integrali del Dipartimento della Protezione Civile.';

  @override
  String get libraryKeywords =>
      'biblioteca documenti manuali pdf enciclopedia wikipedia wikimed guide protezione civile leggere manuali guide consultare';

  @override
  String get manageMaps => 'Mappe';

  @override
  String get addPoint => 'Aggiungi punto';

  @override
  String get savedPoints => 'Punti salvati';

  @override
  String get recordTrack => 'Percorso';

  @override
  String get pointName => 'Nome';

  @override
  String get pointNameHint => 'Es. casa, punto d\'incontro';

  @override
  String get pointDefaultName => 'Punto';

  @override
  String get coordinates => 'Coordinate';

  @override
  String get coordinatesHelp =>
      'Decimali (45.4642, 9.1900) o gradi, primi e secondi (45°27\'51\"N 9°11\'24\"E). Puoi anche tenere premuto sulla mappa.';

  @override
  String get coordsInvalid => 'Coordinate non valide';

  @override
  String get useMyPosition => 'Usa la mia posizione';

  @override
  String get pointsEmpty =>
      'Nessun punto salvato. Aggiungine uno con le coordinate o tieni premuto sulla mappa.';

  @override
  String get clearTrack => 'Cancella';

  @override
  String trackLength(String dist) {
    return 'Percorso registrato: $dist';
  }

  @override
  String distanceTo(String dist, String dir, int deg) {
    return '$dist in linea d\'aria · verso $dir ($deg°)';
  }

  @override
  String get onbContentTitle => 'Manuali ed enciclopedie';

  @override
  String get onbContentBody =>
      'Scegli cosa tenere sul telefono per consultarlo senza internet. Le schede di emergenza e le guide della Protezione Civile sono già incluse.';

  @override
  String get onbPackDocs => 'Documenti ufficiali europei';

  @override
  String get onbPackDocsBody =>
      'Primo soccorso (ERC, OMS), guide alla preparazione dei governi europei. Nella tua lingua quando esistono.';

  @override
  String get onbPackMedicine => 'Wikipedia: medicina';

  @override
  String get onbPackMedicineBody =>
      'Le voci di medicina di Wikipedia: malattie, sintomi, farmaci, anatomia.';

  @override
  String onbDownloadSelected(String size) {
    return 'Scarica i selezionati ($size)';
  }

  @override
  String get trackTitle => 'Percorso';

  @override
  String get trackHelp =>
      'Tocca «Percorso» per registrare la strada che fai: compare come linea blu sulla mappa. Serve a ritrovare la via del ritorno (verso casa, l\'auto, un rifugio) o a mostrare ai soccorritori da dove sei passato. Si registra solo con questa schermata aperta; tocca di nuovo per fermare.';

  @override
  String get trackShow => 'Tocca per vederlo sulla mappa';

  @override
  String get pointsAndTrack => 'Punti e percorso';

  @override
  String get suppliesHome => 'Casa';

  @override
  String get suppliesBackpack => 'Zaino';

  @override
  String get filterAll => 'Tutto';

  @override
  String get filterMissing => 'Cosa manca';

  @override
  String get suppliesQuantities => 'Le quantità';

  @override
  String get suppliesQuantitiesHint =>
      'Quanto hai rispetto a quanto serve. Tocca una voce per vedere e aggiornare quello che hai.';

  @override
  String get quantitiesEnough => 'Le quantità bastano.';

  @override
  String get suppliesHaveTitle => 'Da avere';

  @override
  String get suppliesHaveHint =>
      'Cose che ci sono o non ci sono: spunta quelle che hai. Le voci seguono le linee guida UE e delle protezioni civili europee.';

  @override
  String get inBag => 'nello zaino';

  @override
  String get inBagChange => 'È nello zaino: cambialo nella scheda Zaino.';

  @override
  String get addOwnItem => 'Aggiungi una voce';

  @override
  String get bagLegend =>
      'Per ogni cosa scegli se è già nello zaino, se la prendi da casa quando esci, o se manca. Lo zaino serve se devi lasciare la casa in fretta.';

  @override
  String get beforeLeaving => 'Prima di uscire prendi';

  @override
  String get beforeLeavingAlways => 'Chiavi, telefono e portafoglio';

  @override
  String bagReady(int done, int total) {
    return '$done di $total pronte';
  }

  @override
  String get bagCheckTitle => 'Controlla lo zaino ogni 6 mesi';

  @override
  String bagCheckBody(String date) {
    return 'Cibo, farmaci e batterie scadono. Ultimo controllo: $date';
  }

  @override
  String get bagCheckNever => 'mai';

  @override
  String get bagCheckDone => 'Fatto oggi';

  @override
  String get bagNoPowerBank =>
      'In casa non c\'è: aggiungilo in Casa › Elettricità.';

  @override
  String get bagPacked => 'Nello zaino';

  @override
  String get bagFromHome => 'Da casa, al momento';

  @override
  String get bagMissing => 'Manca';

  @override
  String get attributionsTitle => 'Licenze e attribuzioni';

  @override
  String get attributionsSubtitle =>
      'Da dove vengono i contenuti e con quale licenza';

  @override
  String get attributionsBody =>
      'Le schede sono scritte con parole nostre a partire dalle fonti ufficiali qui sotto; i documenti e le guide originali restano dei loro autori. Ogni scheda indica le sue fonti, frase per frase, nel file docs/verifica-schede.md del progetto.';

  @override
  String get attributionsApp => 'Codice dell\'app e testi delle schede';

  @override
  String get softwareLicenses => 'Licenze delle librerie software';

  @override
  String get paperTitle => 'Copia su carta';

  @override
  String get paperSubtitle =>
      'Numeri, radio, piano della famiglia, zaino e schede, in un PDF da stampare';

  @override
  String get paperIntro =>
      'Stampala e tienila con le scorte e nello zaino: serve quando il telefono è scarico o rotto. Aggiornala quando cambi qualcosa.';

  @override
  String get paperNumbers => 'Numeri e allerte';

  @override
  String get paperBagKey => '[x] pronto · [   ] manca';

  @override
  String get paperSources =>
      'Fonti: ERC 2025, IFRC 2025, linee guida UE, protezioni civili nazionali, OMS. Elenco completo nell\'app: Altro › Licenze e attribuzioni. Non sostituisce un corso di primo soccorso né le indicazioni delle autorità.';

  @override
  String get paperFileName => 'copia-su-carta';

  @override
  String get bagCheckReminder =>
      'Controlla cibo, farmaci e batterie nello zaino: alcune cose potrebbero essere scadute.';

  @override
  String get hospitalsButton => 'Ospedali';

  @override
  String get hospitalsTitle => 'Ospedali vicini';

  @override
  String hospitalsNote(String number) {
    return 'Dalla mappa offline (OpenStreetMap), con la distanza in linea d\'aria. In emergenza chiama sempre il $number: ti dicono dove andare.';
  }

  @override
  String get hospitalsNeedMap =>
      'Per cercare gli ospedali serve la mappa dettagliata del tuo paese: scaricala da Mappe.';

  @override
  String get hospitalsNone => 'Nessun ospedale nella mappa entro circa 50 km.';

  @override
  String get hospitalUnnamed => 'Ospedale';

  @override
  String get hospitalsNeedGps =>
      'Serve la posizione GPS: aspetta che il telefono la trovi, poi riprova.';

  @override
  String get readyTitle => 'Quanto sei pronto';

  @override
  String get readyTodo => 'Da fare';

  @override
  String get readyPlanDone => 'Contatti, punti d\'incontro e rifugio scritti';

  @override
  String readyMissing(String list) {
    return 'Mancano: $list';
  }

  @override
  String get readyWaterFood => 'Acqua e cibo';

  @override
  String readyDays(String water, String food, int days) {
    return 'Giorni: acqua $water · cibo $food · obiettivo $days';
  }

  @override
  String readyWaterFoodEmpty(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '1 giorno',
    );
    return 'Quanto ne serve per $_temp0 e quanto ne hai';
  }

  @override
  String get readyHome => 'Cose da avere in casa';

  @override
  String readyOf(int done, int total) {
    return '$done di $total';
  }

  @override
  String readyToDownload(String name) {
    return 'Da scaricare: $name';
  }

  @override
  String paperMade(String date) {
    return 'Creata il $date';
  }
}
