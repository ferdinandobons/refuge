// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rifugio';

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
  String get onbDownload => 'Download encyclopedias (optional)';

  @override
  String get onbOptionalTitle => 'Optional: offline encyclopedias';

  @override
  String get onbOptionalBody =>
      'The emergency cards are already included. While you have internet, you can also add:';

  @override
  String get onbPackWikimed => 'WikiMed (English)';

  @override
  String get onbPackWikimedBody =>
      'Medical encyclopedia: diseases, symptoms, medicines, injuries, first aid. About 2 GB.';

  @override
  String get onbPackWikipedia => 'Wikipedia in your language';

  @override
  String get onbPackWikipediaBody =>
      'General knowledge of every kind: history, places, science, technology, how things work. From a few GB (reduced version) to tens of GB (complete).';

  @override
  String get onbPackWikivoyage => 'Wikivoyage';

  @override
  String get onbPackWikivoyageBody =>
      'Countries and cities: getting around, borders, hospitals, practical information. A few hundred MB.';

  @override
  String get onbDownloadNote =>
      'You need Wi-Fi and free space. You can also do this later from Prepare.';

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
  String get checklists => 'Checklists';

  @override
  String get offlineContent => 'Download while you have internet';

  @override
  String get downloadEncyclopedias => 'Download encyclopedias';

  @override
  String get downloadEncyclopediasBody =>
      'Wikipedia and WikiMed in your language, to read offline.';

  @override
  String get library => 'Library';

  @override
  String get libraryBody => 'Offline encyclopedias and original manuals';

  @override
  String get originalTexts => 'Original texts';

  @override
  String get originalTextsBody =>
      'Full texts from Italian Civil Protection and other sources (Italian)';

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
      'Open source app that works without internet.\n\nThe emergency cards follow European first aid guidelines (European Resuscitation Council) and civil protection advice. Original texts, manuals and encyclopedias are in the Library, with sources and licenses.\n\nThis app does not replace a first aid course or instructions from the authorities.';

  @override
  String get documents => 'Documents';

  @override
  String get documentsBody => 'Original official manuals, in English.';

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
  String get locationTitle => 'Location';

  @override
  String get locationSubtitle => 'GPS coordinates to read out to rescuers';

  @override
  String get locationKeywords =>
      'location position gps coordinates where am i map utm mgrs';

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
    return 'When on the phone with $number, read out the decimal coordinates.';
  }

  @override
  String get westLetter => 'W';

  @override
  String get suppliesTitle => 'Supplies';

  @override
  String get suppliesSubtitle => 'Water and food by number of people and days';

  @override
  String get suppliesKeywords =>
      'supplies water food rations how much calculate provisions stockpile';

  @override
  String get people => 'People';

  @override
  String get days => 'Days';

  @override
  String get suppliesNote =>
      'Rough values for adults. Heat, exertion, children and the elderly change needs. Use the oldest supplies first.';

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
    return 'Staying outdoors for 24 hours: about $dose. A basement cuts it by 10-40 times.';
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
      'Very large files: download them on a computer from download.kiwix.org and copy them with Finder or the Files app into the Rifugio › zim folder, then tap ↻.';

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
    return 'Article “$title” not found: download WikiMed from the Library to read it offline.';
  }

  @override
  String get needsTitle => 'Needs';

  @override
  String get summaryTitle => 'Summary';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get inventoryHint =>
      'Tap + when you buy, − when you use. Items at zero are what you are missing. Tap an item to change it.';

  @override
  String get catWater => 'Water';

  @override
  String get catFood => 'Food';

  @override
  String get catGas => 'Cooking gas';

  @override
  String get catOther => 'Other';

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
  String get otherItemHint => 'Type an item, e.g. flashlight';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get otherSuggestions =>
      'AA batteries,AAA batteries,Power bank,Headlamp,Candles,Matches,Lighter,Battery radio,Regular medicines,Painkillers,First aid kit,Oral rehydration salts,Water purification tablets,Unscented bleach,FFP2 masks,Disposable gloves,Foil blanket,Blankets,Trash bags,Duct tape,Plastic sheeting,Rope,Multi-tool,Toilet paper,Soap,Wet wipes,Sanitary pads,Diapers,Pet food,Cash';

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
}
