// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Refuge';

  @override
  String get tabEmergency => 'Emergency';

  @override
  String get tabPrepare => 'Prepare';

  @override
  String get tabTools => 'Tools';

  @override
  String get tabMore => 'More';

  @override
  String get onbLanguageTitle => 'Choose your language';

  @override
  String get onbCountryTitle => 'Which country are you in?';

  @override
  String get onbCountryHint =>
      'Used for the emergency number and local alerts. You can change it later.';

  @override
  String get onbReadyTitle => 'All set';

  @override
  String onbReadyBody(String number) {
    return 'The app works without internet. In an emergency, call $number.';
  }

  @override
  String get onbStart => 'Start';

  @override
  String get onbPackWikimed => 'WikiMed (English)';

  @override
  String get onbPackWikimedBody =>
      'Medical encyclopedia: diseases, symptoms, medicines, wounds, first aid.';

  @override
  String get onbPackWikipedia => 'Wikipedia in your language';

  @override
  String get onbPackWikipediaBody =>
      'All general knowledge: history, places, science, technology. Very large.';

  @override
  String get onbPackWikivoyage => 'Wikivoyage';

  @override
  String get onbPackWikivoyageBody =>
      'Countries and cities: getting around, borders, hospitals, practical information.';

  @override
  String get onbDownloadNote =>
      'Downloads continue while you use the app and appear at the top of the Emergency screen. You can add or remove content at any time from Tools › Manuals & guides.';

  @override
  String callNumber(String number) {
    return 'Call $number';
  }

  @override
  String get sosLight => 'SOS light';

  @override
  String get searchHint => 'Search: bleeding, iodine, earthquake…';

  @override
  String get searchTip =>
      'Type what is happening or what you need. Partial words and typos work too.';

  @override
  String get searchEmpty => 'No results.';

  @override
  String get whatsHappening => 'What\'s happening?';

  @override
  String get search => 'Search';

  @override
  String get readAloud => 'Read aloud';

  @override
  String get allSteps => 'All steps';

  @override
  String get neverDo => 'Don\'t';

  @override
  String get sources => 'Sources';

  @override
  String stepOf(int n, int total) {
    return 'Step $n of $total';
  }

  @override
  String get previous => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get countryIT => 'Italy';

  @override
  String get countryFR => 'France';

  @override
  String get countryDE => 'Germany';

  @override
  String get countryES => 'Spain';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryCH => 'Switzerland';

  @override
  String get countryBE => 'Belgium';

  @override
  String get countryNL => 'Netherlands';

  @override
  String get countryLU => 'Luxembourg';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'United Kingdom';

  @override
  String get countryIE => 'Ireland';

  @override
  String get countryOther => 'Other European country';

  @override
  String get officialAlerts => 'official alerts';

  @override
  String get sirenFR =>
      'Alert: rising and falling tone for 1 minute 41 seconds, repeated 3 times. All clear: steady tone for 30 seconds. Tested on the first Wednesday of each month at noon.';

  @override
  String get sirenDE =>
      'Alert: rising and falling tone for 1 minute. All clear: steady tone for 1 minute.';

  @override
  String get sirenAT =>
      'Warning: steady tone for 3 minutes. Alert: rising and falling tone for 1 minute. All clear: steady tone for 1 minute.';

  @override
  String get sirenCH =>
      'General alert: rising and falling tone for 1 minute, repeated after 2 minutes. Listen to the radio and follow instructions.';

  @override
  String get noteIodineDE =>
      'In Germany, iodine tablets are not recommended for people over 45.';

  @override
  String yourCountry(String name) {
    return 'Your country: $name';
  }

  @override
  String get emergencyNumber => 'Emergency number';

  @override
  String get serviceAmbulance => 'Ambulance';

  @override
  String get serviceFire => 'Fire service';

  @override
  String get servicePolice => 'Police';

  @override
  String get servicePoison => 'Poison control';

  @override
  String get serviceDeafSms => 'SMS for deaf people';

  @override
  String get phoneAlerts => 'Phone alerts';

  @override
  String phoneAlertsBody(String name) {
    return '$name: they arrive on your phone automatically, even without an app. Keep them on in your phone settings.';
  }

  @override
  String get sirens => 'Sirens';

  @override
  String get checklists => 'Supplies and plan';

  @override
  String get offlineContent => 'Download while you have internet';

  @override
  String get downloadEncyclopedias => 'Download encyclopedias';

  @override
  String get downloadEncyclopediasBody =>
      'Wikipedia and WikiMed in your language, to read offline.';

  @override
  String get library => 'Manuals & guides';

  @override
  String get libraryBody =>
      'Official European documents, Civil Protection guides and offline encyclopedias';

  @override
  String get originalTexts => 'Original texts';

  @override
  String get originalTextsBody =>
      'Full texts from Italian Civil Protection (in Italian)';

  @override
  String get originalTextsNote =>
      'Complete texts in the original language, for further reading.';

  @override
  String get language => 'Language';

  @override
  String get country => 'Country';

  @override
  String get about => 'About';

  @override
  String get aboutBody => 'Sources, licenses and disclaimers';

  @override
  String get aboutText =>
      'Open source app that works without internet.\n\nThe emergency cards follow European guidelines: first aid from the European Resuscitation Council (ERC 2025) and the Red Cross (IFRC), preparedness from the European Union 72-hour guidelines, and advice from national civil protection agencies. Original documents and encyclopedias are in Manuals & guides, with sources and licences.\n\nThis app does not replace a first aid course or instructions from the authorities.';

  @override
  String get documents => 'Documents';

  @override
  String get documentsBody =>
      'Official European and international documents, in your language when available, otherwise in English. Some are already in the app, the others are downloaded from the official website.';

  @override
  String get torchTitle => 'Flashlight and SOS';

  @override
  String get torchSubtitle => 'Light, flashing SOS, screen light';

  @override
  String get torchKeywords =>
      'flashlight torch light dark sos flashing signal night';

  @override
  String get torchOn => 'Turn on flashlight';

  @override
  String get torchOff => 'Turn off flashlight';

  @override
  String get torchMissing =>
      'Flashlight not available on this device. Use the screen light.';

  @override
  String get sosBlinking => 'Flashing SOS';

  @override
  String get sosStop => 'Stop SOS';

  @override
  String get screenLight => 'Screen light';

  @override
  String get sosInfo =>
      'SOS = ··· ─── ··· repeated. International distress signal, visible at night even from far away.';

  @override
  String get tapToClose => 'Tap to close';

  @override
  String get morseTitle => 'Morse';

  @override
  String get morseSubtitle => 'Send a message with light';

  @override
  String get morseKeywords => 'morse code signal light message';

  @override
  String get morseMessage => 'Message';

  @override
  String get useTorchToo => 'Also use the flashlight';

  @override
  String get repeat => 'Repeat';

  @override
  String morseSpeed(int ms) {
    return 'Speed: dot = $ms ms';
  }

  @override
  String get transmit => 'Send';

  @override
  String get stop => 'Stop';

  @override
  String get morseTable => 'Chart';

  @override
  String get compassTitle => 'Compass';

  @override
  String get compassSubtitle => 'Direction and cardinal points';

  @override
  String get compassKeywords => 'compass north direction orientation bearing';

  @override
  String get compassUnavailable => 'Compass not available on this device.';

  @override
  String get compassWaiting => 'Waiting for sensor…';

  @override
  String get compassHint =>
      'Hold the phone flat, away from metal and magnets. If the direction looks wrong, move the phone in a figure 8.';

  @override
  String get cardinals => 'N,NE,E,SE,S,SW,W,NW';

  @override
  String get locationTitle => 'Location and maps';

  @override
  String get locationSubtitle =>
      'GPS coordinates for rescuers and offline maps';

  @override
  String get locationKeywords =>
      'location position gps coordinates where am i map utm mgrs offline maps download';

  @override
  String get locServiceOff =>
      'Location is turned off. Turn it on in your phone settings: GPS works even in airplane mode.';

  @override
  String get locDenied =>
      'Location permission denied. You can grant it in your phone settings.';

  @override
  String get locUnavailable => 'Location not available on this device.';

  @override
  String gpsError(String error) {
    return 'GPS error: $error';
  }

  @override
  String get searchingSats => 'Searching for satellites… Faster outdoors.';

  @override
  String get fmtDecimal => 'Decimal';

  @override
  String get fmtDms => 'Degrees, minutes, seconds';

  @override
  String get fmtMgrs => 'MGRS (military, rescue)';

  @override
  String get altitude => 'Altitude';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String locHint(String number) {
    return 'On the phone with $number, read out the decimal coordinates. The track is recorded only while this screen is open.';
  }

  @override
  String get westLetter => 'W';

  @override
  String get suppliesTitle => 'Supplies';

  @override
  String get suppliesSubtitle =>
      'What you have, what is missing and how much: home and backpack';

  @override
  String get suppliesKeywords =>
      'supplies water food rations how much calculate provisions stockpile backpack home inventory';

  @override
  String get people => 'People';

  @override
  String get days => 'Days';

  @override
  String get suppliesNote =>
      'The EU recommends at least 72 hours of self-sufficiency; longer is better. The calculation uses 4 litres of water per person per day (3 for drinking, 1 for cooking and washing) and 2000 kcal. These are rough values for adults: heat, exertion, children and older people change needs. Use the oldest supplies first.';

  @override
  String get falloutTitle => 'Fallout';

  @override
  String get falloutSubtitle => 'Timer after an explosion: what to do and when';

  @override
  String get falloutKeywords =>
      'fallout radiation dosimeter nuclear 7 10 decay';

  @override
  String get measuredRate => 'Measured dose rate';

  @override
  String falloutDose(String dose) {
    return 'Staying outdoors for 24 hours: about $dose. Indoors, in the middle of a solid building or in a basement, it is much less.';
  }

  @override
  String get resetChecklistQ => 'Reset the checklist?';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String doneOf(int done, int total) {
    return '$done of $total';
  }

  @override
  String get encyclopedias => 'Offline encyclopedias';

  @override
  String get noEncyclopedias =>
      'No encyclopedias on this phone. Download one while you have internet: then it works offline too.';

  @override
  String get iosImportHint =>
      'Very large files: download them on a computer from download.kiwix.org and copy them with Finder or the Files app into the Refuge › zim folder, then tap ↻.';

  @override
  String get deleteFromDevice => 'Delete from phone';

  @override
  String deleteQ(String title) {
    return 'Delete “$title”?';
  }

  @override
  String deleteBody(String size) {
    return 'This will free $size. To get it back you will need to download it again.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get dlWaiting => 'Waiting (needs Wi-Fi if set to Wi-Fi only)…';

  @override
  String get dlRetrying => 'Connection lost, retrying…';

  @override
  String dlPaused(String pct) {
    return 'Paused · $pct%';
  }

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get catalogSearchHint => 'Search the Kiwix catalog';

  @override
  String get catalogUnreachable =>
      'Catalog unreachable. An internet connection is needed.';

  @override
  String get recWikimed => 'WikiMed: medical encyclopedia (English)';

  @override
  String get recWikipediaMedicine => 'Wikipedia: medicine only';

  @override
  String get recWikipedia => 'Full Wikipedia';

  @override
  String get recWikivoyage => 'Wikivoyage: countries and cities';

  @override
  String get recMedicalTextbooks => 'Medical textbooks (English)';

  @override
  String resultsFor(String query) {
    return 'Results for “$query”';
  }

  @override
  String get flavourMini => 'Mini, introductions only';

  @override
  String get flavourNopic => 'No images';

  @override
  String get flavourMaxi => 'With images';

  @override
  String get flavourFull => 'Full';

  @override
  String get zimitUnsupported => 'Archived website: format not supported yet';

  @override
  String get download => 'Download';

  @override
  String downloadQ(String size) {
    return 'Download $size?';
  }

  @override
  String get downloadBody =>
      'Make sure you have enough free space. The download continues even when the app is closed and resumes where it stopped.';

  @override
  String get wifiOnly => 'Wi-Fi only';

  @override
  String get externalLink => 'External link: not available offline.';

  @override
  String get mainPage => 'Main page';

  @override
  String get searchByTitle => 'Search by title';

  @override
  String get searchByTitleTip => 'Type the beginning of an article title.';

  @override
  String get searchDocument => 'Search the document (in English)';

  @override
  String pagesN(int n) {
    return '$n pages';
  }

  @override
  String get license => 'License';

  @override
  String get reproducedInFull => 'Document reproduced in full, unchanged.';

  @override
  String get notAvailable => 'Not available in this version.';

  @override
  String entryMissing(String title) {
    return 'Article “$title” not found: download WikiMed from Manuals & guides to read it offline.';
  }

  @override
  String get catWater => 'Water';

  @override
  String get catFood => 'Food';

  @override
  String get catGas => 'Cooking gas';

  @override
  String coversDays(String days) {
    return 'Enough for $days days';
  }

  @override
  String missingWater(String liters, int bottles) {
    return 'Still need $liters L ≈ $bottles bottles of 1.5 L';
  }

  @override
  String missingFood(String kcal, String kg) {
    return 'Still need $kcal kcal ≈ $kg kg of pasta or rice';
  }

  @override
  String missingGas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartridges',
      one: '1 cartridge',
    );
    return 'Still need $_temp0 of 220 g';
  }

  @override
  String mealsHave(int have, int need) {
    return '$have / $need hot meals';
  }

  @override
  String get addItem => 'Add';

  @override
  String get addOne => 'Add one';

  @override
  String get consumeOne => 'Remove one';

  @override
  String get itemName => 'Name';

  @override
  String get unitSize => 'Contents of one pack';

  @override
  String get kcalPer100 => 'kcal per 100 g';

  @override
  String get quantity => 'Quantity';

  @override
  String get save => 'Save';

  @override
  String get chooseProduct => 'What do you want to add?';

  @override
  String get chooseSize => 'Size';

  @override
  String get otherSize => 'Other size';

  @override
  String get addToInventory => 'Add to inventory';

  @override
  String get pWaterBottle => 'Water bottle';

  @override
  String get pWaterTank => 'Water jerrycan';

  @override
  String get pPasta => 'Pasta';

  @override
  String get pRice => 'Rice';

  @override
  String get pDryLegumes => 'Dried legumes';

  @override
  String get pCannedLegumes => 'Canned legumes';

  @override
  String get pTuna => 'Canned tuna';

  @override
  String get pCannedMeat => 'Canned meat';

  @override
  String get pCannedVeg => 'Canned vegetables';

  @override
  String get pNuts => 'Nuts and dried fruit';

  @override
  String get pBiscuits => 'Biscuits, crackers';

  @override
  String get pBars => 'Snack bars';

  @override
  String get pUhtMilk => 'Long-life milk';

  @override
  String get pPowderMilk => 'Powdered milk';

  @override
  String get pOil => 'Oil';

  @override
  String get pSugar => 'Sugar';

  @override
  String get pHoney => 'Honey';

  @override
  String get pCustomFood => 'Other food';

  @override
  String get pCartridge => 'Gas cartridge';

  @override
  String get pCustomOther => 'Other item';

  @override
  String get falloutStartIntro =>
      'If there has been a nuclear explosion, start the timer: it tells you how long to stay sheltered, what to do and what to wear at each moment.';

  @override
  String get falloutStartNow => 'Explosion now: start';

  @override
  String get falloutStartAt => 'Set the time of the explosion';

  @override
  String get falloutResetQ => 'Reset the timer?';

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
    return '$d d $h h $m min';
  }

  @override
  String get falloutMax =>
      'Radiation at its peak: this is the most dangerous time.';

  @override
  String falloutRemaining(String pct) {
    return 'Radiation at about $pct of its level 1 hour after the explosion.';
  }

  @override
  String falloutNextPhase(String left, String time) {
    return 'Next phase in $left (at $time)';
  }

  @override
  String get whatToWear => 'If you must go out';

  @override
  String get whatToDoNow => 'What to do now';

  @override
  String get falloutTimeline => 'Phases';

  @override
  String get doNotGoOut => 'Do not go out';

  @override
  String get falloutBannerOut =>
      'Go out only if necessary, covered from head to toe';

  @override
  String get wearMask => 'FFP2/FFP3 mask';

  @override
  String get wearGloves => 'Gloves';

  @override
  String get wearCovered => 'Hat, long sleeves, raincoat';

  @override
  String get wearBoots => 'Closed shoes or boots';

  @override
  String get phase0Title => 'Maximum danger: take shelter now';

  @override
  String get phase0a =>
      'Get into the sturdiest building near you and go to the center or the basement.';

  @override
  String get phase0b =>
      'Close doors and windows, turn off ventilation and air conditioning.';

  @override
  String get phase0c =>
      'If you were outside: take off your clothes, seal them in a bag and wash.';

  @override
  String get phase0d => 'Do not go out for any reason.';

  @override
  String get phase1Title => 'Stay sheltered';

  @override
  String get phase1a =>
      'Radiation drops fast: after 7 hours it is about a tenth.';

  @override
  String get phase1b => 'Stay inside, away from outer walls and the roof.';

  @override
  String get phase1c => 'Listen to radio, TV and phone alerts.';

  @override
  String get phase1d =>
      'Eat and drink only from sealed packages. Go out only if the shelter is in danger (fire, collapse).';

  @override
  String get phase2Title => 'Go out only if essential';

  @override
  String get phase2a =>
      'Follow the authorities: they may tell you to move or evacuate.';

  @override
  String get phase2b => 'Very short trips, covered from head to toe.';

  @override
  String get phase2c =>
      'When you come back, take off your outer clothes before going in, and wash.';

  @override
  String get phase3Title => 'Danger decreasing';

  @override
  String get phase3a =>
      'After 2 days radiation is about a hundredth of the initial level.';

  @override
  String get phase3b =>
      'Short trips only when needed, with protection. Avoid dust.';

  @override
  String get phase3c =>
      'Do not eat food left outdoors and use water from sealed containers.';

  @override
  String get phase4Title => 'Danger much lower';

  @override
  String get phase4a =>
      'After 2 weeks radiation is about a thousandth of the initial level.';

  @override
  String get phase4b => 'Follow the authorities for returning to normal.';

  @override
  String get phase4c => 'Keep taking precautions with food and water.';

  @override
  String get falloutDisclaimer =>
      'General guidance based on the 7-10 rule. When to go out is decided by the authorities and by real measurements with a dosimeter.';

  @override
  String get haveDosimeter => 'Do you have a dosimeter?';

  @override
  String inHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hours',
      one: '1 hour',
    );
    return 'In $_temp0';
  }

  @override
  String get levelFlat => 'Flat';

  @override
  String get levelAlmost => 'Almost flat';

  @override
  String get levelTilted => 'Lay the phone flat';

  @override
  String tiltDegrees(int n) {
    return 'Tilt $n°';
  }

  @override
  String get mapsTitle => 'Offline maps';

  @override
  String get onbMapTitle => 'Offline map';

  @override
  String get onbMapBody =>
      'Choose which maps to keep on your phone. They work without internet, with your GPS position.';

  @override
  String get mapWorld => 'World';

  @override
  String get mapWorldBody => 'All countries, main cities and major roads.';

  @override
  String get mapEurope => 'Europe';

  @override
  String get mapEuropeBody => 'Cities, towns and main roads across Europe.';

  @override
  String mapCountry(String name) {
    return '$name in detail';
  }

  @override
  String get mapCountryBody =>
      'Every road, street and path, down to single buildings.';

  @override
  String get mapKeepOpen => 'Keep the app open until the download finishes.';

  @override
  String get mapDownloadSelected => 'Download selected maps';

  @override
  String get mapReady => 'Downloaded';

  @override
  String get mapFailed => 'Download failed. Try again.';

  @override
  String mapDownloading(String pct, String size) {
    return '$pct% of $size';
  }

  @override
  String get mapPreparing => 'Preparing…';

  @override
  String get mapSizeCalc => 'Calculating size…';

  @override
  String get mapSizeUnknown => 'Size not available (internet needed)';

  @override
  String get mapNone =>
      'No offline maps. Download one to see where you are even without internet.';

  @override
  String get mapDownloadButton => 'Download maps';

  @override
  String get mapSkip => 'Skip, I\'ll do it later';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get wholeWorld => 'Whole world';

  @override
  String get myPosition => 'My position';

  @override
  String downloadsActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n downloads in progress',
      one: 'Download in progress',
    );
    return '$_temp0';
  }

  @override
  String get mapsOnPhone => 'On this phone';

  @override
  String get mapsInProgress => 'In progress';

  @override
  String get mapsAvailable => 'Available';

  @override
  String get mapUpdate => 'Update to the latest version';

  @override
  String mapUpdatedOn(String date) {
    return 'from $date';
  }

  @override
  String get mapsMoreBody =>
      'Download, update or delete maps of the world, Europe and countries';

  @override
  String get emptySection => 'Nothing yet. Tap “Add”.';

  @override
  String get catElectricity => 'Electricity';

  @override
  String chargesHave(int have, int need) {
    return '$have / $need charges';
  }

  @override
  String missingCharges(int n, int pb) {
    return 'Still need $n phone charges ≈ $pb power banks of 10,000 mAh';
  }

  @override
  String get electricityBasis =>
      'Basis: 1 full phone charge per person per day. Power banks at 65% and power stations at 85% of their rated capacity.';

  @override
  String get pPowerBank => 'Power bank';

  @override
  String get pPowerStation => 'Power station';

  @override
  String get pSolarPanel => 'Solar panel';

  @override
  String get pBatteriesAA => 'AA batteries';

  @override
  String get pBatteriesAAA => 'AAA batteries';

  @override
  String get radioTitle => 'Emergency radio';

  @override
  String get radioSubtitle => 'What to listen to and on which frequencies';

  @override
  String get radioKeywords =>
      'radio frequency fm am dab medium wave news authorities walkie talkie pmr';

  @override
  String get radioListen => 'What to listen to';

  @override
  String get radioListenBody =>
      'These broadcasters carry the authorities\' official messages during an emergency.';

  @override
  String get radioFm => 'FM in the main cities';

  @override
  String get radioAm => 'Medium and long wave (AM)';

  @override
  String get radioAmNote =>
      'At night, medium and long wave reach much farther.';

  @override
  String get radioDab => 'Digital radio DAB+';

  @override
  String get radioNationwide => 'Nationwide';

  @override
  String get radioNoData => 'No verified data for this country yet.';

  @override
  String get radioNotFound => 'If you can\'t find the station';

  @override
  String get radioTip1 =>
      'Run an automatic scan over the whole FM band, then over AM.';

  @override
  String get radioTip2 =>
      'Move close to a window or to a higher floor, and fully extend the antenna.';

  @override
  String get radioTip3 =>
      'FM frequencies change from area to area: the ones here are for the main cities.';

  @override
  String get radioTip4 =>
      'Listen at fixed times, at the start of each hour, to save batteries.';

  @override
  String get radioWhich => 'Which radio to keep at home';

  @override
  String get radioWhich1 =>
      'A hand-crank or battery radio with FM, medium wave (AM) and, if possible, DAB+ and shortwave.';

  @override
  String get radioWhich2 =>
      'Spare batteries of the same size, stored separately.';

  @override
  String get radioWhich3 =>
      'It works even if your phone is dead and the network is down.';

  @override
  String get pmrTitle => 'PMR446 walkie-talkies';

  @override
  String get pmrBody =>
      'Licence-free across Europe (0.5 W, usually 1-3 km). Agree on a channel with your family.';

  @override
  String pmrChannel(int n) {
    return 'Ch. $n';
  }

  @override
  String get radioOpsec =>
      'Receiving is safe: listeners send no signal. Transmitting can be detected: in a war zone, talk little, briefly and only when needed.';

  @override
  String radioChecked(String date) {
    return 'Data checked against official sources on $date.';
  }

  @override
  String radioFinder(String name) {
    return 'Find the frequency for your area (online): $name';
  }

  @override
  String get docDownloadFailed =>
      'Download failed. Check your connection and try again.';

  @override
  String docDownloading(String pct) {
    return 'Downloading… $pct%';
  }

  @override
  String docToDownload(String size) {
    return 'To download · $size';
  }

  @override
  String get docNotDownloaded =>
      'Download the document from Manuals & guides first.';

  @override
  String get planTitle => 'Family emergency plan';

  @override
  String get planSubtitle => 'Contacts, meeting points, who helps whom';

  @override
  String get planIntro =>
      'Agree on it beforehand, together: in an emergency phones and the internet may not work.';

  @override
  String get planContacts => 'Emergency contacts';

  @override
  String get planContactsHint =>
      'Name and phone of 2–3 people, including one outside town';

  @override
  String get planMeetNear => 'Meeting point near home';

  @override
  String get planMeetNearHint => 'E.g. in front of the pharmacy on the corner';

  @override
  String get planMeetFar => 'Meeting point outside the neighbourhood';

  @override
  String get planMeetFarHint => 'In case you cannot go home';

  @override
  String get planShelter => 'Nearest shelter or assembly area';

  @override
  String get planShelterHint => 'The one named by your local authority';

  @override
  String get planChildren => 'Who collects the children';

  @override
  String get planChildrenHint =>
      'School, nursery, and who collects them if you cannot';

  @override
  String get planHelp => 'Who needs help';

  @override
  String get planHelpHint =>
      'Older people, people with disabilities, pets: who helps them and how';

  @override
  String get planHealth => 'Medicines and medical information';

  @override
  String get planHealthHint => 'Medicines, allergies, medical devices';

  @override
  String get planNotes => 'Other notes';

  @override
  String get planCopy => 'Copy the plan';

  @override
  String get planCopied => 'Plan copied: paste it into a message or print it.';

  @override
  String get planPaper =>
      'Also write the plan on paper and keep it with your supplies. Give it to your emergency contacts.';

  @override
  String docDownloadAll(int n, String size) {
    return 'Download all ($n · $size)';
  }

  @override
  String docDownloadingAll(int n) {
    return 'Downloading… $n left';
  }

  @override
  String get civilProtectionGuides => 'Civil Protection guides';

  @override
  String get civilProtectionGuidesBody =>
      'What to do before, during and after: earthquake, flood, wildfires, industrial accident, tsunami, nuclear emergency and dams. Texts of the Italian Civil Protection Department, translated and valid across Europe.';

  @override
  String get libraryKeywords =>
      'library documents manuals pdf encyclopedia wikipedia wikimed guides civil protection read manuals guides reference';

  @override
  String get manageMaps => 'Maps';

  @override
  String get addPoint => 'Add point';

  @override
  String get savedPoints => 'Saved points';

  @override
  String get recordTrack => 'Track';

  @override
  String get pointName => 'Name';

  @override
  String get pointNameHint => 'E.g. home, meeting point';

  @override
  String get pointDefaultName => 'Point';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get coordinatesHelp =>
      'Decimal (45.4642, 9.1900) or degrees, minutes and seconds (45°27\'51\"N 9°11\'24\"E). You can also long-press on the map.';

  @override
  String get coordsInvalid => 'Invalid coordinates';

  @override
  String get useMyPosition => 'Use my location';

  @override
  String get pointsEmpty =>
      'No saved points. Add one with coordinates or long-press on the map.';

  @override
  String get clearTrack => 'Delete';

  @override
  String trackLength(String dist) {
    return 'Recorded track: $dist';
  }

  @override
  String distanceTo(String dist, String dir, int deg) {
    return '$dist as the crow flies · towards $dir ($deg°)';
  }

  @override
  String get onbContentTitle => 'Manuals and encyclopedias';

  @override
  String get onbContentBody =>
      'Choose what to keep on your phone to look up without internet. The emergency cards and the Civil Protection guides are already included.';

  @override
  String get onbPackDocs => 'Official European documents';

  @override
  String get onbPackDocsBody =>
      'First aid (ERC, WHO) and preparedness guides from European governments. In your language when available.';

  @override
  String get onbPackMedicine => 'Wikipedia: medicine';

  @override
  String get onbPackMedicineBody =>
      'Wikipedia\'s medical articles: diseases, symptoms, medicines, anatomy.';

  @override
  String onbDownloadSelected(String size) {
    return 'Download selected ($size)';
  }

  @override
  String get trackTitle => 'Track';

  @override
  String get trackHelp =>
      'Tap “Track” to record the way you walk: it appears as a blue line on the map. Use it to find your way back (home, to the car, to a shelter) or to show rescuers where you have been. It records only while this screen is open; tap again to stop.';

  @override
  String get trackShow => 'Tap to see it on the map';

  @override
  String get pointsAndTrack => 'Points and track';

  @override
  String get suppliesHome => 'Home';

  @override
  String get suppliesBackpack => 'Backpack';

  @override
  String get filterAll => 'Everything';

  @override
  String get filterMissing => 'What\'s missing';

  @override
  String get suppliesQuantities => 'Quantities';

  @override
  String get suppliesQuantitiesHint =>
      'How much you have compared with what you need. Tap one to see and update what you have.';

  @override
  String get quantitiesEnough => 'The quantities are enough.';

  @override
  String get suppliesHaveTitle => 'To have';

  @override
  String get suppliesHaveHint =>
      'Things you either have or not: tick the ones you have. The items follow EU and European civil protection guidelines.';

  @override
  String get inBag => 'in the backpack';

  @override
  String get inBagChange =>
      'It is in the backpack: change it in the Backpack tab.';

  @override
  String get addOwnItem => 'Add an item';

  @override
  String get bagLegend =>
      'For each item choose whether it is already in the backpack, whether you take it from home when you leave, or whether it is missing. The backpack is for when you have to leave home quickly.';

  @override
  String get beforeLeaving => 'Before leaving, take';

  @override
  String get beforeLeavingAlways => 'Keys, phone and wallet';

  @override
  String bagReady(int done, int total) {
    return '$done of $total ready';
  }

  @override
  String get bagCheckTitle => 'Check the backpack every 6 months';

  @override
  String bagCheckBody(String date) {
    return 'Food, medicines and batteries expire. Last check: $date';
  }

  @override
  String get bagCheckNever => 'never';

  @override
  String get bagCheckDone => 'Done today';

  @override
  String get bagNoPowerBank =>
      'There is none at home: add it in Home › Electricity.';

  @override
  String get bagPacked => 'In the backpack';

  @override
  String get bagFromHome => 'From home, when leaving';

  @override
  String get bagMissing => 'Missing';
}
