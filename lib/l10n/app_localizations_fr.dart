// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Refuge';

  @override
  String get tabEmergency => 'Urgence';

  @override
  String get tabPrepare => 'Se préparer';

  @override
  String get tabTools => 'Outils';

  @override
  String get tabMore => 'Plus';

  @override
  String get onbLanguageTitle => 'Choisissez la langue';

  @override
  String get onbCountryTitle => 'Dans quel pays êtes-vous ?';

  @override
  String get onbCountryHint =>
      'Pour le numéro d\'urgence et les alertes locales. Vous pourrez le changer plus tard.';

  @override
  String get onbReadyTitle => 'Tout est prêt';

  @override
  String onbReadyBody(String number) {
    return 'L\'application fonctionne sans internet. En cas d\'urgence, appelez le $number.';
  }

  @override
  String get onbStart => 'Commencer';

  @override
  String get onbPackWikimed => 'WikiMed (anglais)';

  @override
  String get onbPackWikimedBody =>
      'Encyclopédie médicale : maladies, symptômes, médicaments, blessures, premiers secours.';

  @override
  String get onbPackWikipedia => 'Wikipédia dans votre langue';

  @override
  String get onbPackWikipediaBody =>
      'Toute la culture générale : histoire, lieux, sciences, techniques. Très volumineux.';

  @override
  String get onbPackWikivoyage => 'Wikivoyage';

  @override
  String get onbPackWikivoyageBody =>
      'Pays et villes : se déplacer, frontières, hôpitaux, informations pratiques.';

  @override
  String get onbDownloadNote =>
      'Les téléchargements continuent pendant que vous utilisez l\'app et s\'affichent en haut de l\'écran Urgence. Vous pouvez ajouter ou retirer des contenus à tout moment depuis Outils › Manuels et guides.';

  @override
  String callNumber(String number) {
    return 'Appeler le $number';
  }

  @override
  String get sosLight => 'SOS lumineux';

  @override
  String get searchHint => 'Rechercher : sang, iode, séisme…';

  @override
  String get searchTip =>
      'Écrivez ce qui se passe ou ce dont vous avez besoin. Cela fonctionne aussi avec des mots incomplets ou mal écrits.';

  @override
  String get searchEmpty => 'Aucun résultat.';

  @override
  String get whatsHappening => 'Que se passe-t-il ?';

  @override
  String get search => 'Rechercher';

  @override
  String get readAloud => 'Lire à voix haute';

  @override
  String get allSteps => 'Toutes les étapes';

  @override
  String get neverDo => 'À ne pas faire';

  @override
  String get sources => 'Sources';

  @override
  String stepOf(int n, int total) {
    return 'Étape $n sur $total';
  }

  @override
  String get previous => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Terminé';

  @override
  String get countryIT => 'Italie';

  @override
  String get countryFR => 'France';

  @override
  String get countryDE => 'Allemagne';

  @override
  String get countryES => 'Espagne';

  @override
  String get countryAT => 'Autriche';

  @override
  String get countryCH => 'Suisse';

  @override
  String get countryBE => 'Belgique';

  @override
  String get countryNL => 'Pays-Bas';

  @override
  String get countryLU => 'Luxembourg';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'Royaume-Uni';

  @override
  String get countryIE => 'Irlande';

  @override
  String get countryOther => 'Autre pays européen';

  @override
  String get officialAlerts => 'alertes officielles';

  @override
  String get sirenFR =>
      'Signal national d\'alerte : son montant et descendant de 1 minute 41 secondes, répété 3 fois. Fin d\'alerte : son continu de 30 secondes. Essai le premier mercredi du mois à midi.';

  @override
  String get sirenDE =>
      'Alerte : son montant et descendant pendant 1 minute. Fin d\'alerte : son continu pendant 1 minute.';

  @override
  String get sirenAT =>
      'Préalerte : son continu pendant 3 minutes. Alerte : son montant et descendant pendant 1 minute. Fin d\'alerte : son continu pendant 1 minute.';

  @override
  String get sirenCH =>
      'Alarme générale : son montant et descendant pendant 1 minute, répété après 2 minutes. Écoutez la radio et suivez les consignes.';

  @override
  String get noteIodineDE =>
      'En Allemagne, les comprimés d\'iode ne sont pas recommandés après 45 ans.';

  @override
  String yourCountry(String name) {
    return 'Votre pays : $name';
  }

  @override
  String get emergencyNumber => 'Numéro d\'urgence';

  @override
  String get serviceAmbulance => 'Ambulance';

  @override
  String get serviceFire => 'Pompiers';

  @override
  String get servicePolice => 'Police';

  @override
  String get servicePoison => 'Centre antipoison';

  @override
  String get serviceDeafSms => 'SMS pour personnes sourdes';

  @override
  String get phoneAlerts => 'Alertes sur le téléphone';

  @override
  String phoneAlertsBody(String name) {
    return '$name : elles arrivent toutes seules sur le téléphone, même sans application. Laissez-les activées dans les réglages du téléphone.';
  }

  @override
  String get sirens => 'Sirènes';

  @override
  String get checklists => 'Provisions et plan';

  @override
  String get offlineContent => 'À télécharger tant qu\'il y a internet';

  @override
  String get downloadEncyclopedias => 'Télécharger des encyclopédies';

  @override
  String get downloadEncyclopediasBody =>
      'Wikipédia et WikiMed dans votre langue, à lire sans réseau.';

  @override
  String get library => 'Manuels et guides';

  @override
  String get libraryBody =>
      'Documents officiels européens, guides de la Protection civile et encyclopédies hors ligne';

  @override
  String get originalTexts => 'Textes originaux';

  @override
  String get originalTextsBody =>
      'Textes intégraux de la Protection civile italienne (en italien)';

  @override
  String get originalTextsNote =>
      'Textes complets dans la langue d\'origine, pour aller plus loin.';

  @override
  String get language => 'Langue';

  @override
  String get country => 'Pays';

  @override
  String get about => 'À propos';

  @override
  String get aboutBody => 'Sources, licences et avertissements';

  @override
  String get aboutText =>
      'Application open source qui fonctionne sans internet.\n\nLes fiches d\'urgence suivent les recommandations européennes : premiers secours du Conseil européen de réanimation (ERC 2025) et de la Croix-Rouge (IFRC), préparation selon les lignes directrices de l\'Union européenne sur les 72 heures, et consignes des protections civiles nationales. Les documents originaux et les encyclopédies se trouvent dans Manuels et guides, avec leurs sources et licences.\n\nCette application ne remplace ni une formation aux premiers secours ni les consignes des autorités.';

  @override
  String get documents => 'Documents';

  @override
  String get documentsBody =>
      'Documents officiels européens et internationaux, dans votre langue quand ils existent, sinon en anglais. Certains sont déjà dans l\'app, les autres se téléchargent depuis le site officiel.';

  @override
  String get torchTitle => 'Lampe et SOS';

  @override
  String get torchSubtitle => 'Lumière, SOS clignotant, écran lumineux';

  @override
  String get torchKeywords =>
      'lampe torche lumière noir obscurité sos clignotant signal nuit';

  @override
  String get torchOn => 'Allumer la lampe';

  @override
  String get torchOff => 'Éteindre la lampe';

  @override
  String get torchMissing =>
      'Lampe indisponible sur cet appareil. Utilisez l\'écran lumineux.';

  @override
  String get sosBlinking => 'SOS clignotant';

  @override
  String get sosStop => 'Arrêter le SOS';

  @override
  String get screenLight => 'Écran lumineux';

  @override
  String get sosInfo =>
      'SOS = ··· ─── ··· répété. Signal international de détresse, visible de nuit même de loin.';

  @override
  String get tapToClose => 'Touchez pour fermer';

  @override
  String get morseTitle => 'Morse';

  @override
  String get morseSubtitle => 'Transmettre un message avec la lumière';

  @override
  String get morseKeywords => 'morse code signal lumière message';

  @override
  String get morseMessage => 'Message';

  @override
  String get useTorchToo => 'Utiliser aussi la lampe';

  @override
  String get repeat => 'Répéter';

  @override
  String morseSpeed(int ms) {
    return 'Vitesse : point = $ms ms';
  }

  @override
  String get transmit => 'Transmettre';

  @override
  String get stop => 'Arrêter';

  @override
  String get morseTable => 'Tableau';

  @override
  String get compassTitle => 'Boussole';

  @override
  String get compassSubtitle => 'Direction et points cardinaux';

  @override
  String get compassKeywords => 'boussole nord direction orientation';

  @override
  String get compassUnavailable => 'Boussole indisponible sur cet appareil.';

  @override
  String get compassWaiting => 'En attente du capteur…';

  @override
  String get compassHint =>
      'Tenez le téléphone à plat, loin des métaux et des aimants. Si la direction semble étrange, bougez le téléphone en dessinant un 8.';

  @override
  String get cardinals => 'N,NE,E,SE,S,SO,O,NO';

  @override
  String get locationTitle => 'Position et cartes';

  @override
  String get locationSubtitle =>
      'Coordonnées GPS pour les secours et cartes hors ligne';

  @override
  String get locationKeywords =>
      'position gps coordonnées où suis-je carte utm mgrs cartes hors ligne télécharger';

  @override
  String get locServiceOff =>
      'La localisation est désactivée. Activez-la dans les réglages du téléphone : le GPS fonctionne même en mode avion.';

  @override
  String get locDenied =>
      'Accès à la position refusé. Vous pouvez l\'autoriser dans les réglages du téléphone.';

  @override
  String get locUnavailable => 'Position indisponible sur cet appareil.';

  @override
  String gpsError(String error) {
    return 'Erreur GPS : $error';
  }

  @override
  String get searchingSats =>
      'Recherche des satellites… C\'est plus rapide en extérieur.';

  @override
  String get fmtDecimal => 'Décimal';

  @override
  String get fmtDms => 'Degrés, minutes, secondes';

  @override
  String get fmtMgrs => 'MGRS (militaires, secours)';

  @override
  String get altitude => 'Altitude';

  @override
  String get accuracy => 'Précision';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Copié';

  @override
  String locHint(String number) {
    return 'Au téléphone avec le $number, dictez les coordonnées décimales. Le parcours n\'est enregistré que lorsque cet écran est ouvert.';
  }

  @override
  String get westLetter => 'O';

  @override
  String get suppliesTitle => 'Réserves';

  @override
  String get suppliesSubtitle =>
      'Ce que vous avez, ce qui manque et combien : maison et sac';

  @override
  String get suppliesKeywords =>
      'réserves provisions eau nourriture rations combien calcul stock sac maison inventaire';

  @override
  String get people => 'Personnes';

  @override
  String get days => 'Jours';

  @override
  String get suppliesNote =>
      'L\'UE recommande au moins 72 heures d\'autonomie ; plus, c\'est mieux. Le calcul utilise 4 litres d\'eau par personne et par jour (3 pour boire, 1 pour cuisiner et se laver) et 2000 kcal. Ce sont des valeurs indicatives pour adultes : la chaleur, l\'effort, les enfants et les personnes âgées changent les besoins. Consommez d\'abord les réserves les plus anciennes.';

  @override
  String get falloutTitle => 'Retombées';

  @override
  String get falloutSubtitle =>
      'Minuteur après une explosion : que faire et quand';

  @override
  String get falloutKeywords =>
      'retombées fallout radiations radioactivité dosimètre nucléaire 7 10 décroissance';

  @override
  String get measuredRate => 'Intensité mesurée';

  @override
  String falloutDose(String dose) {
    return 'En restant dehors 24 heures : environ $dose. À l\'intérieur, au centre d\'un bâtiment solide ou dans une cave, c\'est beaucoup moins.';
  }

  @override
  String get resetChecklistQ => 'Réinitialiser la liste ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String doneOf(int done, int total) {
    return '$done sur $total';
  }

  @override
  String get encyclopedias => 'Encyclopédies hors ligne';

  @override
  String get noEncyclopedias =>
      'Aucune encyclopédie sur le téléphone. Téléchargez-en une tant que vous avez internet : elle fonctionnera ensuite sans réseau.';

  @override
  String get iosImportHint =>
      'Fichiers très volumineux : téléchargez-les sur l\'ordinateur depuis download.kiwix.org et copiez-les avec le Finder ou l\'app Fichiers dans le dossier Refuge › zim, puis touchez ↻.';

  @override
  String get deleteFromDevice => 'Supprimer du téléphone';

  @override
  String deleteQ(String title) {
    return 'Supprimer « $title » ?';
  }

  @override
  String deleteBody(String size) {
    return 'Vous libérerez $size. Pour la récupérer, il faudra la télécharger à nouveau.';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get dlWaiting => 'En attente (Wi-Fi requis si demandé)…';

  @override
  String get dlRetrying => 'Connexion perdue, nouvel essai…';

  @override
  String dlPaused(String pct) {
    return 'En pause · $pct %';
  }

  @override
  String get resume => 'Reprendre';

  @override
  String get pause => 'Pause';

  @override
  String get catalogSearchHint => 'Rechercher dans le catalogue Kiwix';

  @override
  String get catalogUnreachable =>
      'Catalogue inaccessible. Une connexion internet est nécessaire.';

  @override
  String get recWikimed => 'WikiMed : encyclopédie médicale (en anglais)';

  @override
  String get recWikipediaMedicine => 'Wikipédia : médecine uniquement';

  @override
  String get recWikipedia => 'Wikipédia complète';

  @override
  String get recWikivoyage => 'Wikivoyage : pays et villes';

  @override
  String get recMedicalTextbooks => 'Manuels de médecine (en anglais)';

  @override
  String resultsFor(String query) {
    return 'Résultats pour « $query »';
  }

  @override
  String get flavourMini => 'Mini, introductions seulement';

  @override
  String get flavourNopic => 'Sans images';

  @override
  String get flavourMaxi => 'Avec images';

  @override
  String get flavourFull => 'Complète';

  @override
  String get zimitUnsupported =>
      'Site web archivé : format pas encore pris en charge';

  @override
  String get download => 'Télécharger';

  @override
  String downloadQ(String size) {
    return 'Télécharger $size ?';
  }

  @override
  String get downloadBody =>
      'Vérifiez que vous avez assez d\'espace libre. Le téléchargement continue même quand l\'application est fermée et reprend là où il s\'était arrêté.';

  @override
  String get wifiOnly => 'Wi-Fi uniquement';

  @override
  String get externalLink => 'Lien externe : indisponible hors ligne.';

  @override
  String get mainPage => 'Page d\'accueil';

  @override
  String get searchByTitle => 'Rechercher par titre';

  @override
  String get searchByTitleTip => 'Écrivez le début du titre d\'un article.';

  @override
  String get searchDocument => 'Rechercher dans le document (en anglais)';

  @override
  String pagesN(int n) {
    return '$n pages';
  }

  @override
  String get license => 'Licence';

  @override
  String get reproducedInFull =>
      'Document reproduit intégralement, sans modification.';

  @override
  String get notAvailable => 'Indisponible dans cette version.';

  @override
  String entryMissing(String title) {
    return 'Article « $title » introuvable : téléchargez WikiMed depuis Manuels et guides pour le lire hors ligne.';
  }

  @override
  String get catWater => 'Eau';

  @override
  String get catFood => 'Nourriture';

  @override
  String get catGas => 'Gaz pour cuisiner';

  @override
  String coversDays(String days) {
    return 'Suffit pour $days jours';
  }

  @override
  String missingWater(String liters, int bottles) {
    return 'Il manque $liters L ≈ $bottles bouteilles de 1,5 L';
  }

  @override
  String missingFood(String kcal, String kg) {
    return 'Il manque $kcal kcal ≈ $kg kg de pâtes ou de riz';
  }

  @override
  String missingGas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartouches',
      one: '1 cartouche',
    );
    return 'Il manque $_temp0 de 220 g';
  }

  @override
  String mealsHave(int have, int need) {
    return '$have / $need repas chauds';
  }

  @override
  String get addItem => 'Ajouter';

  @override
  String get addOne => 'Ajouter un';

  @override
  String get consumeOne => 'Retirer un';

  @override
  String get itemName => 'Nom';

  @override
  String get unitSize => 'Contenu d\'un paquet';

  @override
  String get kcalPer100 => 'kcal pour 100 g';

  @override
  String get quantity => 'Quantité';

  @override
  String get save => 'Enregistrer';

  @override
  String get chooseProduct => 'Que voulez-vous ajouter ?';

  @override
  String get chooseSize => 'Format';

  @override
  String get otherSize => 'Autre format';

  @override
  String get addToInventory => 'Ajouter à l\'inventaire';

  @override
  String get pWaterBottle => 'Bouteille d\'eau';

  @override
  String get pWaterTank => 'Bidon d\'eau';

  @override
  String get pPasta => 'Pâtes';

  @override
  String get pRice => 'Riz';

  @override
  String get pDryLegumes => 'Légumineuses sèches';

  @override
  String get pCannedLegumes => 'Légumineuses en conserve';

  @override
  String get pTuna => 'Thon en conserve';

  @override
  String get pCannedMeat => 'Viande en conserve';

  @override
  String get pCannedVeg => 'Légumes en conserve';

  @override
  String get pNuts => 'Fruits secs';

  @override
  String get pBiscuits => 'Biscuits, crackers';

  @override
  String get pBars => 'Barres de céréales';

  @override
  String get pUhtMilk => 'Lait UHT';

  @override
  String get pPowderMilk => 'Lait en poudre';

  @override
  String get pOil => 'Huile';

  @override
  String get pSugar => 'Sucre';

  @override
  String get pHoney => 'Miel';

  @override
  String get pCustomFood => 'Autre aliment';

  @override
  String get pCartridge => 'Cartouche de gaz';

  @override
  String get pCustomOther => 'Autre objet';

  @override
  String get falloutStartIntro =>
      'En cas d\'explosion nucléaire, lancez le minuteur : il vous indique combien de temps rester à l\'abri, quoi faire et quoi porter à chaque moment.';

  @override
  String get falloutStartNow => 'Explosion maintenant : lancer';

  @override
  String get falloutStartAt => 'Régler l\'heure de l\'explosion';

  @override
  String get falloutResetQ => 'Réinitialiser le minuteur ?';

  @override
  String falloutSince(String time) {
    return 'Explosion : $time';
  }

  @override
  String durationHM(int h, int m) {
    return '$h h $m min';
  }

  @override
  String durationDHM(int d, int h, int m) {
    return '$d j $h h $m min';
  }

  @override
  String get falloutMax =>
      'Radiations au maximum : c\'est le moment le plus dangereux.';

  @override
  String falloutRemaining(String pct) {
    return 'Radiations à environ $pct de leur niveau 1 heure après l\'explosion.';
  }

  @override
  String falloutNextPhase(String left, String time) {
    return 'Phase suivante dans $left (à $time)';
  }

  @override
  String get whatToWear => 'Si vous devez sortir';

  @override
  String get whatToDoNow => 'Que faire maintenant';

  @override
  String get falloutTimeline => 'Phases';

  @override
  String get doNotGoOut => 'Ne sortez pas';

  @override
  String get falloutBannerOut =>
      'Ne sortez qu\'en cas de nécessité, couvert de la tête aux pieds';

  @override
  String get wearMask => 'Masque FFP2/FFP3';

  @override
  String get wearGloves => 'Gants';

  @override
  String get wearCovered => 'Chapeau, manches longues, imperméable';

  @override
  String get wearBoots => 'Chaussures fermées ou bottes';

  @override
  String get phase0Title => 'Danger maximal : à l\'abri tout de suite';

  @override
  String get phase0a =>
      'Entrez dans le bâtiment le plus solide près de vous et allez au centre ou à la cave.';

  @override
  String get phase0b =>
      'Fermez portes et fenêtres, coupez la ventilation et la climatisation.';

  @override
  String get phase0c =>
      'Si vous étiez dehors : enlevez vos vêtements, enfermez-les dans un sac et lavez-vous.';

  @override
  String get phase0d => 'Ne sortez sous aucun prétexte.';

  @override
  String get phase1Title => 'Restez à l\'abri';

  @override
  String get phase1a =>
      'Les radiations baissent vite : après 7 heures, il en reste environ un dixième.';

  @override
  String get phase1b =>
      'Restez à l\'intérieur, loin des murs extérieurs et du toit.';

  @override
  String get phase1c =>
      'Écoutez la radio, la télé et les alertes sur le téléphone.';

  @override
  String get phase1d =>
      'Buvez et mangez uniquement des produits en emballage fermé. Ne sortez que si l\'abri est en danger (incendie, effondrement).';

  @override
  String get phase2Title => 'Sorties seulement si indispensables';

  @override
  String get phase2a =>
      'Suivez les autorités : elles peuvent demander de vous déplacer ou d\'évacuer.';

  @override
  String get phase2b => 'Sorties très brèves, couvert de la tête aux pieds.';

  @override
  String get phase2c =>
      'Au retour, enlevez vos vêtements extérieurs avant d\'entrer et lavez-vous.';

  @override
  String get phase3Title => 'Danger en baisse';

  @override
  String get phase3a =>
      'Après 2 jours, les radiations sont environ un centième de leur niveau initial.';

  @override
  String get phase3b =>
      'Sorties brèves si nécessaire, avec protection. Évitez la poussière.';

  @override
  String get phase3c =>
      'Ne mangez pas d\'aliments restés à l\'air libre et utilisez l\'eau de récipients fermés.';

  @override
  String get phase4Title => 'Danger très réduit';

  @override
  String get phase4a =>
      'Après 2 semaines, les radiations sont environ un millième de leur niveau initial.';

  @override
  String get phase4b => 'Suivez les autorités pour le retour à la normale.';

  @override
  String get phase4c =>
      'Continuez les précautions pour la nourriture et l\'eau.';

  @override
  String get falloutDisclaimer =>
      'Indications générales basées sur la règle des 7-10. Le moment de sortir est décidé par les autorités, avec des mesures réelles au dosimètre.';

  @override
  String get haveDosimeter => 'Avez-vous un dosimètre ?';

  @override
  String inHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n heures',
      one: '1 heure',
    );
    return 'Dans $_temp0';
  }

  @override
  String get levelFlat => 'À plat';

  @override
  String get levelAlmost => 'Presque à plat';

  @override
  String get levelTilted => 'Mettez le téléphone à plat';

  @override
  String tiltDegrees(int n) {
    return 'Inclinaison $n°';
  }

  @override
  String get mapsTitle => 'Cartes hors ligne';

  @override
  String get onbMapTitle => 'Carte hors ligne';

  @override
  String get onbMapBody =>
      'Choisissez les cartes à garder sur votre téléphone. Elles fonctionnent sans internet, avec votre position GPS.';

  @override
  String get mapWorld => 'Monde';

  @override
  String get mapWorldBody =>
      'Tous les pays, les grandes villes et les grands axes routiers.';

  @override
  String get mapEurope => 'Europe';

  @override
  String get mapEuropeBody =>
      'Villes, villages et routes principales de toute l\'Europe.';

  @override
  String mapCountry(String name) {
    return '$name en détail';
  }

  @override
  String get mapCountryBody =>
      'Toutes les routes, rues et sentiers, jusqu\'aux bâtiments.';

  @override
  String get mapKeepOpen =>
      'Gardez l\'application ouverte jusqu\'à la fin du téléchargement.';

  @override
  String get mapDownloadSelected => 'Télécharger les cartes choisies';

  @override
  String get mapReady => 'Téléchargée';

  @override
  String get mapFailed => 'Échec du téléchargement. Réessayez.';

  @override
  String mapDownloading(String pct, String size) {
    return '$pct % sur $size';
  }

  @override
  String get mapPreparing => 'Préparation…';

  @override
  String get mapSizeCalc => 'Calcul de la taille…';

  @override
  String get mapSizeUnknown => 'Taille indisponible (internet nécessaire)';

  @override
  String get mapNone =>
      'Aucune carte hors ligne. Téléchargez-en une pour voir où vous êtes, même sans internet.';

  @override
  String get mapDownloadButton => 'Télécharger des cartes';

  @override
  String get mapSkip => 'Passer, je le ferai plus tard';

  @override
  String get zoomIn => 'Zoomer';

  @override
  String get zoomOut => 'Dézoomer';

  @override
  String get wholeWorld => 'Monde entier';

  @override
  String get myPosition => 'Ma position';

  @override
  String downloadsActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n téléchargements en cours',
      one: 'Téléchargement en cours',
    );
    return '$_temp0';
  }

  @override
  String get mapsOnPhone => 'Sur le téléphone';

  @override
  String get mapsInProgress => 'En cours';

  @override
  String get mapsAvailable => 'Disponibles';

  @override
  String get mapUpdate => 'Mettre à jour';

  @override
  String mapUpdatedOn(String date) {
    return 'du $date';
  }

  @override
  String get mapsMoreBody =>
      'Téléchargez, mettez à jour ou supprimez les cartes du monde, de l\'Europe et des pays';

  @override
  String get emptySection => 'Rien pour l\'instant. Touchez « Ajouter ».';

  @override
  String get catElectricity => 'Électricité';

  @override
  String chargesHave(int have, int need) {
    return '$have / $need recharges';
  }

  @override
  String missingCharges(int n, int pb) {
    return 'Il manque $n recharges de téléphone ≈ $pb batteries externes de 10 000 mAh';
  }

  @override
  String get electricityBasis =>
      'Calcul : 1 recharge complète du téléphone par personne et par jour. Batteries externes à 65 % et stations d\'énergie à 85 % de la capacité annoncée.';

  @override
  String get pPowerBank => 'Batterie externe';

  @override
  String get pPowerStation => 'Station d\'énergie';

  @override
  String get pSolarPanel => 'Panneau solaire';

  @override
  String get pBatteriesAA => 'Piles AA';

  @override
  String get pBatteriesAAA => 'Piles AAA';

  @override
  String get radioTitle => 'Radio en cas d\'urgence';

  @override
  String get radioSubtitle => 'Quoi écouter et sur quelles fréquences';

  @override
  String get radioKeywords =>
      'radio fréquence fm am dab ondes moyennes infos autorités talkie walkie pmr';

  @override
  String get radioListen => 'Quoi écouter';

  @override
  String get radioListenBody =>
      'Ces radios diffusent les messages officiels des autorités pendant une urgence.';

  @override
  String get radioFm => 'FM dans les grandes villes';

  @override
  String get radioAm => 'Ondes moyennes et longues (AM)';

  @override
  String get radioAmNote =>
      'La nuit, les ondes moyennes et longues portent beaucoup plus loin.';

  @override
  String get radioDab => 'Radio numérique DAB+';

  @override
  String get radioNationwide => 'Dans tout le pays';

  @override
  String get radioNoData => 'Pas encore de données vérifiées pour ce pays.';

  @override
  String get radioNotFound => 'Si vous ne trouvez pas la station';

  @override
  String get radioTip1 =>
      'Lancez une recherche automatique sur toute la bande FM, puis sur l\'AM.';

  @override
  String get radioTip2 =>
      'Approchez-vous d\'une fenêtre ou montez d\'un étage, et déployez entièrement l\'antenne.';

  @override
  String get radioTip3 =>
      'Les fréquences FM changent selon la zone : celles-ci sont celles des grandes villes.';

  @override
  String get radioTip4 =>
      'Écoutez à heures fixes, au début de chaque heure, pour économiser les piles.';

  @override
  String get radioWhich => 'Quelle radio garder chez soi';

  @override
  String get radioWhich1 =>
      'Une radio à manivelle ou à piles avec FM, ondes moyennes (AM) et, si possible, DAB+ et ondes courtes.';

  @override
  String get radioWhich2 =>
      'Des piles de rechange du même format, rangées à part.';

  @override
  String get radioWhich3 =>
      'Elle fonctionne même si le téléphone est déchargé et le réseau coupé.';

  @override
  String get pmrTitle => 'Talkies-walkies PMR446';

  @override
  String get pmrBody =>
      'Sans licence dans toute l\'Europe (0,5 W, en général 1 à 3 km). Convenez d\'un canal en famille.';

  @override
  String pmrChannel(int n) {
    return 'Can. $n';
  }

  @override
  String get radioOpsec =>
      'Recevoir est sans danger : qui écoute n\'émet aucun signal. Émettre peut être détecté : en zone de guerre, parlez peu, brièvement et seulement si nécessaire.';

  @override
  String radioChecked(String date) {
    return 'Données vérifiées sur des sources officielles le $date.';
  }

  @override
  String radioFinder(String name) {
    return 'Trouvez la fréquence de votre zone (en ligne) : $name';
  }

  @override
  String get docDownloadFailed =>
      'Échec du téléchargement. Vérifiez la connexion et réessayez.';

  @override
  String docDownloading(String pct) {
    return 'Téléchargement… $pct %';
  }

  @override
  String docToDownload(String size) {
    return 'À télécharger · $size';
  }

  @override
  String get docNotDownloaded =>
      'Téléchargez d\'abord le document depuis Manuels et guides.';

  @override
  String get planTitle => 'Plan d\'urgence familial';

  @override
  String get planSubtitle => 'Contacts, points de rendez-vous, qui aide qui';

  @override
  String get planIntro =>
      'Mettez-vous d\'accord à l\'avance, tous ensemble : en cas d\'urgence, le téléphone et internet peuvent ne pas fonctionner.';

  @override
  String get planContacts => 'Contacts d\'urgence';

  @override
  String get planContactsHint =>
      'Nom et téléphone de 2 ou 3 personnes, dont une hors de la ville';

  @override
  String get planMeetNear => 'Point de rendez-vous près de chez vous';

  @override
  String get planMeetNearHint => 'Par ex. devant la pharmacie du coin';

  @override
  String get planMeetFar => 'Point de rendez-vous hors du quartier';

  @override
  String get planMeetFarHint => 'Si vous ne pouvez pas rentrer';

  @override
  String get planShelter => 'Abri ou point de rassemblement le plus proche';

  @override
  String get planShelterHint => 'Celui indiqué par la commune';

  @override
  String get planChildren => 'Qui va chercher les enfants';

  @override
  String get planChildrenHint =>
      'École, crèche, et qui y va si vous ne pouvez pas';

  @override
  String get planHelp => 'Qui a besoin d\'aide';

  @override
  String get planHelpHint =>
      'Personnes âgées, en situation de handicap, animaux : qui les aide et comment';

  @override
  String get planHealth => 'Médicaments et informations médicales';

  @override
  String get planHealthHint => 'Médicaments, allergies, dispositifs médicaux';

  @override
  String get planNotes => 'Autres notes';

  @override
  String get planCopy => 'Copier le plan';

  @override
  String get planCopied =>
      'Plan copié : collez-le dans un message ou imprimez-le.';

  @override
  String get planPaper =>
      'Écrivez aussi le plan sur papier et gardez-le avec vos réserves. Donnez-le à vos contacts d\'urgence.';

  @override
  String docDownloadAll(int n, String size) {
    return 'Tout télécharger ($n · $size)';
  }

  @override
  String docDownloadingAll(int n) {
    return 'Téléchargement… encore $n';
  }

  @override
  String get civilProtectionGuides => 'Guides de la Protection civile';

  @override
  String get civilProtectionGuidesBody =>
      'Que faire avant, pendant et après : séisme, inondation, feux de forêt, accident industriel, tsunami, urgence nucléaire et barrages. Textes de la Protection civile italienne, traduits et valables dans toute l\'Europe.';

  @override
  String get libraryKeywords =>
      'bibliothèque documents manuels pdf encyclopédie wikipedia wikimed guides protection civile lire manuels guides consulter';

  @override
  String get manageMaps => 'Cartes';

  @override
  String get addPoint => 'Ajouter un point';

  @override
  String get savedPoints => 'Points enregistrés';

  @override
  String get recordTrack => 'Parcours';

  @override
  String get pointName => 'Nom';

  @override
  String get pointNameHint => 'Par ex. maison, point de rendez-vous';

  @override
  String get pointDefaultName => 'Point';

  @override
  String get coordinates => 'Coordonnées';

  @override
  String get coordinatesHelp =>
      'Décimales (45.4642, 9.1900) ou degrés, minutes et secondes (45°27\'51\"N 9°11\'24\"E). Vous pouvez aussi appuyer longuement sur la carte.';

  @override
  String get coordsInvalid => 'Coordonnées non valides';

  @override
  String get useMyPosition => 'Utiliser ma position';

  @override
  String get pointsEmpty =>
      'Aucun point enregistré. Ajoutez-en un avec les coordonnées ou appuyez longuement sur la carte.';

  @override
  String get clearTrack => 'Effacer';

  @override
  String trackLength(String dist) {
    return 'Parcours enregistré : $dist';
  }

  @override
  String distanceTo(String dist, String dir, int deg) {
    return '$dist à vol d\'oiseau · vers $dir ($deg°)';
  }

  @override
  String get onbContentTitle => 'Manuels et encyclopédies';

  @override
  String get onbContentBody =>
      'Choisissez ce que vous gardez sur le téléphone pour le consulter sans internet. Les fiches d\'urgence et les guides de la Protection civile sont déjà inclus.';

  @override
  String get onbPackDocs => 'Documents officiels européens';

  @override
  String get onbPackDocsBody =>
      'Premiers secours (ERC, OMS) et guides de préparation des gouvernements européens. Dans votre langue quand ils existent.';

  @override
  String get onbPackMedicine => 'Wikipédia : médecine';

  @override
  String get onbPackMedicineBody =>
      'Les articles de médecine de Wikipédia : maladies, symptômes, médicaments, anatomie.';

  @override
  String onbDownloadSelected(String size) {
    return 'Télécharger la sélection ($size)';
  }

  @override
  String get trackTitle => 'Parcours';

  @override
  String get trackHelp =>
      'Touchez « Parcours » pour enregistrer le chemin que vous faites : il apparaît en bleu sur la carte. Il sert à retrouver le chemin du retour (maison, voiture, abri) ou à montrer aux secours par où vous êtes passé. L\'enregistrement ne fonctionne que lorsque cet écran est ouvert ; touchez à nouveau pour arrêter.';

  @override
  String get trackShow => 'Touchez pour le voir sur la carte';

  @override
  String get pointsAndTrack => 'Points et parcours';

  @override
  String get suppliesHome => 'Maison';

  @override
  String get suppliesBackpack => 'Sac';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterMissing => 'Ce qui manque';

  @override
  String get suppliesQuantities => 'Les quantités';

  @override
  String get suppliesQuantitiesHint =>
      'Ce que vous avez par rapport à ce qu\'il faut. Touchez une ligne pour voir et mettre à jour ce que vous avez.';

  @override
  String get quantitiesEnough => 'Les quantités suffisent.';

  @override
  String get suppliesHaveTitle => 'À avoir';

  @override
  String get suppliesHaveHint =>
      'Ce que vous avez ou non : cochez ce que vous avez. Les éléments suivent les recommandations de l\'UE et des protections civiles européennes.';

  @override
  String get inBag => 'dans le sac';

  @override
  String get inBagChange =>
      'C\'est dans le sac : modifiez-le dans l\'onglet Sac.';

  @override
  String get addOwnItem => 'Ajouter un élément';

  @override
  String get bagLegend =>
      'Pour chaque élément, indiquez s\'il est déjà dans le sac, si vous le prenez à la maison en partant, ou s\'il manque. Le sac sert si vous devez quitter la maison rapidement.';

  @override
  String get beforeLeaving => 'Avant de partir, prenez';

  @override
  String get beforeLeavingAlways => 'Clés, téléphone et portefeuille';

  @override
  String bagReady(int done, int total) {
    return '$done sur $total prêts';
  }

  @override
  String get bagCheckTitle => 'Vérifiez le sac tous les 6 mois';

  @override
  String bagCheckBody(String date) {
    return 'La nourriture, les médicaments et les piles se périment. Dernier contrôle : $date';
  }

  @override
  String get bagCheckNever => 'jamais';

  @override
  String get bagCheckDone => 'Fait aujourd\'hui';

  @override
  String get bagNoPowerBank =>
      'Il n\'y en a pas à la maison : ajoutez-la dans Maison › Électricité.';

  @override
  String get bagPacked => 'Dans le sac';

  @override
  String get bagFromHome => 'À prendre en partant';

  @override
  String get bagMissing => 'Manque';

  @override
  String get attributionsTitle => 'Licences et attributions';

  @override
  String get attributionsSubtitle =>
      'D\'où viennent les contenus et sous quelle licence';

  @override
  String get attributionsBody =>
      'Les fiches sont rédigées avec nos mots à partir des sources officielles ci-dessous ; les documents et guides originaux restent à leurs auteurs. Chaque fiche indique ses sources, phrase par phrase, dans le fichier docs/verifica-schede.md du projet.';

  @override
  String get attributionsApp => 'Code de l\'app et textes des fiches';

  @override
  String get softwareLicenses => 'Licences des bibliothèques logicielles';

  @override
  String get paperTitle => 'Copie papier';

  @override
  String get paperSubtitle =>
      'Numéros, radio, plan familial, sac et fiches, dans un PDF à imprimer';

  @override
  String get paperIntro =>
      'Imprimez-la et gardez-la avec vos réserves et dans le sac : elle sert quand le téléphone est déchargé ou cassé. Mettez-la à jour quand quelque chose change.';

  @override
  String get paperNumbers => 'Numéros et alertes';

  @override
  String get paperBagKey => '[x] prêt · [   ] manque';

  @override
  String get paperSources =>
      'Sources : ERC 2025, IFRC 2025, lignes directrices de l\'UE, protections civiles nationales, OMS. Liste complète dans l\'app : Plus › Licences et attributions. Ne remplace ni une formation aux premiers secours ni les consignes des autorités.';

  @override
  String get paperFileName => 'copie-papier';

  @override
  String get bagCheckReminder =>
      'Vérifiez la nourriture, les médicaments et les piles du sac : certains ont peut-être expiré.';

  @override
  String get hospitalsButton => 'Hôpitaux';

  @override
  String get hospitalsTitle => 'Hôpitaux proches';

  @override
  String hospitalsNote(String number) {
    return 'D\'après la carte hors ligne (OpenStreetMap), avec la distance à vol d\'oiseau. En cas d\'urgence, appelez toujours le $number : on vous dira où aller.';
  }

  @override
  String get hospitalsNeedMap =>
      'Pour chercher les hôpitaux, il faut la carte détaillée de votre pays : téléchargez-la depuis Cartes.';

  @override
  String get hospitalsNone =>
      'Aucun hôpital sur la carte à moins de 50 km environ.';

  @override
  String get hospitalUnnamed => 'Hôpital';

  @override
  String get hospitalsNeedGps =>
      'Il faut la position GPS : attendez que le téléphone la trouve, puis réessayez.';
}
