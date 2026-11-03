import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Refuge'**
  String get appTitle;

  /// No description provided for @tabEmergency.
  ///
  /// In it, this message translates to:
  /// **'Emergenza'**
  String get tabEmergency;

  /// No description provided for @tabPrepare.
  ///
  /// In it, this message translates to:
  /// **'Prepararsi'**
  String get tabPrepare;

  /// No description provided for @tabTools.
  ///
  /// In it, this message translates to:
  /// **'Strumenti'**
  String get tabTools;

  /// No description provided for @tabMore.
  ///
  /// In it, this message translates to:
  /// **'Altro'**
  String get tabMore;

  /// No description provided for @onbLanguageTitle.
  ///
  /// In it, this message translates to:
  /// **'Scegli la lingua'**
  String get onbLanguageTitle;

  /// No description provided for @onbCountryTitle.
  ///
  /// In it, this message translates to:
  /// **'In che paese sei?'**
  String get onbCountryTitle;

  /// No description provided for @onbCountryHint.
  ///
  /// In it, this message translates to:
  /// **'Serve per il numero di emergenza e le allerte locali. Puoi cambiarlo dopo.'**
  String get onbCountryHint;

  /// No description provided for @onbReadyTitle.
  ///
  /// In it, this message translates to:
  /// **'Tutto pronto'**
  String get onbReadyTitle;

  /// No description provided for @onbReadyBody.
  ///
  /// In it, this message translates to:
  /// **'L\'app funziona senza internet. In emergenza chiama il {number}.'**
  String onbReadyBody(String number);

  /// No description provided for @onbStart.
  ///
  /// In it, this message translates to:
  /// **'Inizia'**
  String get onbStart;

  /// No description provided for @onbPackWikimed.
  ///
  /// In it, this message translates to:
  /// **'WikiMed (inglese)'**
  String get onbPackWikimed;

  /// No description provided for @onbPackWikimedBody.
  ///
  /// In it, this message translates to:
  /// **'Enciclopedia medica: malattie, sintomi, farmaci, ferite, primo soccorso.'**
  String get onbPackWikimedBody;

  /// No description provided for @onbPackWikipedia.
  ///
  /// In it, this message translates to:
  /// **'Wikipedia nella tua lingua'**
  String get onbPackWikipedia;

  /// No description provided for @onbPackWikipediaBody.
  ///
  /// In it, this message translates to:
  /// **'Tutta la conoscenza generale: storia, luoghi, scienza, tecnica. Molto grande.'**
  String get onbPackWikipediaBody;

  /// No description provided for @onbPackWikivoyage.
  ///
  /// In it, this message translates to:
  /// **'Wikivoyage'**
  String get onbPackWikivoyage;

  /// No description provided for @onbPackWikivoyageBody.
  ///
  /// In it, this message translates to:
  /// **'Paesi e città: come spostarsi, confini, ospedali, informazioni pratiche.'**
  String get onbPackWikivoyageBody;

  /// No description provided for @onbDownloadNote.
  ///
  /// In it, this message translates to:
  /// **'I download continuano mentre usi l\'app e li vedi in cima alla schermata Emergenza. Puoi aggiungere o togliere contenuti quando vuoi da Strumenti › Manuali e guide.'**
  String get onbDownloadNote;

  /// No description provided for @callNumber.
  ///
  /// In it, this message translates to:
  /// **'Chiama {number}'**
  String callNumber(String number);

  /// No description provided for @sosLight.
  ///
  /// In it, this message translates to:
  /// **'SOS luce'**
  String get sosLight;

  /// No description provided for @searchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca: sangue, iodio, terremoto…'**
  String get searchHint;

  /// No description provided for @searchTip.
  ///
  /// In it, this message translates to:
  /// **'Scrivi cosa succede o cosa ti serve. Funziona anche con parole incomplete o con errori.'**
  String get searchTip;

  /// No description provided for @searchEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun risultato.'**
  String get searchEmpty;

  /// No description provided for @whatsHappening.
  ///
  /// In it, this message translates to:
  /// **'Cosa succede?'**
  String get whatsHappening;

  /// No description provided for @search.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get search;

  /// No description provided for @readAloud.
  ///
  /// In it, this message translates to:
  /// **'Leggi ad alta voce'**
  String get readAloud;

  /// No description provided for @allSteps.
  ///
  /// In it, this message translates to:
  /// **'Tutti i passi'**
  String get allSteps;

  /// No description provided for @neverDo.
  ///
  /// In it, this message translates to:
  /// **'Non fare'**
  String get neverDo;

  /// No description provided for @sources.
  ///
  /// In it, this message translates to:
  /// **'Fonti'**
  String get sources;

  /// No description provided for @stepOf.
  ///
  /// In it, this message translates to:
  /// **'Passo {n} di {total}'**
  String stepOf(int n, int total);

  /// No description provided for @previous.
  ///
  /// In it, this message translates to:
  /// **'Indietro'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get next;

  /// No description provided for @done.
  ///
  /// In it, this message translates to:
  /// **'Fatto'**
  String get done;

  /// No description provided for @countryIT.
  ///
  /// In it, this message translates to:
  /// **'Italia'**
  String get countryIT;

  /// No description provided for @countryFR.
  ///
  /// In it, this message translates to:
  /// **'Francia'**
  String get countryFR;

  /// No description provided for @countryDE.
  ///
  /// In it, this message translates to:
  /// **'Germania'**
  String get countryDE;

  /// No description provided for @countryES.
  ///
  /// In it, this message translates to:
  /// **'Spagna'**
  String get countryES;

  /// No description provided for @countryAT.
  ///
  /// In it, this message translates to:
  /// **'Austria'**
  String get countryAT;

  /// No description provided for @countryCH.
  ///
  /// In it, this message translates to:
  /// **'Svizzera'**
  String get countryCH;

  /// No description provided for @countryBE.
  ///
  /// In it, this message translates to:
  /// **'Belgio'**
  String get countryBE;

  /// No description provided for @countryNL.
  ///
  /// In it, this message translates to:
  /// **'Paesi Bassi'**
  String get countryNL;

  /// No description provided for @countryLU.
  ///
  /// In it, this message translates to:
  /// **'Lussemburgo'**
  String get countryLU;

  /// No description provided for @countryPT.
  ///
  /// In it, this message translates to:
  /// **'Portogallo'**
  String get countryPT;

  /// No description provided for @countryGB.
  ///
  /// In it, this message translates to:
  /// **'Regno Unito'**
  String get countryGB;

  /// No description provided for @countryIE.
  ///
  /// In it, this message translates to:
  /// **'Irlanda'**
  String get countryIE;

  /// No description provided for @countryOther.
  ///
  /// In it, this message translates to:
  /// **'Altro paese europeo'**
  String get countryOther;

  /// No description provided for @officialAlerts.
  ///
  /// In it, this message translates to:
  /// **'allerte ufficiali'**
  String get officialAlerts;

  /// No description provided for @sirenFR.
  ///
  /// In it, this message translates to:
  /// **'Allarme: suono che sale e scende per 1 minuto e 41 secondi, ripetuto 3 volte. Fine allarme: suono continuo di 30 secondi. Prova il primo mercoledì del mese a mezzogiorno.'**
  String get sirenFR;

  /// No description provided for @sirenDE.
  ///
  /// In it, this message translates to:
  /// **'Allarme: suono che sale e scende per 1 minuto. Fine allarme: suono continuo di 1 minuto.'**
  String get sirenDE;

  /// No description provided for @sirenAT.
  ///
  /// In it, this message translates to:
  /// **'Preallarme: suono continuo di 3 minuti. Allarme: suono che sale e scende per 1 minuto. Fine allarme: suono continuo di 1 minuto.'**
  String get sirenAT;

  /// No description provided for @sirenCH.
  ///
  /// In it, this message translates to:
  /// **'Allarme generale: suono che sale e scende per 1 minuto, ripetuto dopo 2 minuti. Ascolta la radio e segui le istruzioni.'**
  String get sirenCH;

  /// No description provided for @noteIodineDE.
  ///
  /// In it, this message translates to:
  /// **'In Germania le compresse di iodio non sono indicate per chi ha più di 45 anni.'**
  String get noteIodineDE;

  /// No description provided for @yourCountry.
  ///
  /// In it, this message translates to:
  /// **'Il tuo paese: {name}'**
  String yourCountry(String name);

  /// No description provided for @emergencyNumber.
  ///
  /// In it, this message translates to:
  /// **'Numero di emergenza'**
  String get emergencyNumber;

  /// No description provided for @serviceAmbulance.
  ///
  /// In it, this message translates to:
  /// **'Ambulanza'**
  String get serviceAmbulance;

  /// No description provided for @serviceFire.
  ///
  /// In it, this message translates to:
  /// **'Vigili del fuoco'**
  String get serviceFire;

  /// No description provided for @servicePolice.
  ///
  /// In it, this message translates to:
  /// **'Polizia'**
  String get servicePolice;

  /// No description provided for @servicePoison.
  ///
  /// In it, this message translates to:
  /// **'Centro antiveleni'**
  String get servicePoison;

  /// No description provided for @serviceDeafSms.
  ///
  /// In it, this message translates to:
  /// **'SMS per persone sorde'**
  String get serviceDeafSms;

  /// No description provided for @phoneAlerts.
  ///
  /// In it, this message translates to:
  /// **'Allerte sul telefono'**
  String get phoneAlerts;

  /// No description provided for @phoneAlertsBody.
  ///
  /// In it, this message translates to:
  /// **'{name}: arrivano da sole sul telefono, anche senza app. Tienile attive nelle impostazioni del telefono.'**
  String phoneAlertsBody(String name);

  /// No description provided for @sirens.
  ///
  /// In it, this message translates to:
  /// **'Sirene'**
  String get sirens;

  /// No description provided for @checklists.
  ///
  /// In it, this message translates to:
  /// **'Provviste e piano'**
  String get checklists;

  /// No description provided for @offlineContent.
  ///
  /// In it, this message translates to:
  /// **'Da scaricare finché c\'è internet'**
  String get offlineContent;

  /// No description provided for @downloadEncyclopedias.
  ///
  /// In it, this message translates to:
  /// **'Scarica enciclopedie'**
  String get downloadEncyclopedias;

  /// No description provided for @downloadEncyclopediasBody.
  ///
  /// In it, this message translates to:
  /// **'Wikipedia e WikiMed nella tua lingua, da leggere senza rete.'**
  String get downloadEncyclopediasBody;

  /// No description provided for @library.
  ///
  /// In it, this message translates to:
  /// **'Manuali e guide'**
  String get library;

  /// No description provided for @libraryBody.
  ///
  /// In it, this message translates to:
  /// **'Documenti ufficiali europei, guide della Protezione Civile ed enciclopedie offline'**
  String get libraryBody;

  /// No description provided for @originalTexts.
  ///
  /// In it, this message translates to:
  /// **'Testi originali'**
  String get originalTexts;

  /// No description provided for @originalTextsBody.
  ///
  /// In it, this message translates to:
  /// **'Testi integrali della Protezione Civile italiana (in italiano)'**
  String get originalTextsBody;

  /// No description provided for @originalTextsNote.
  ///
  /// In it, this message translates to:
  /// **'Testi completi nella lingua originale, per approfondire.'**
  String get originalTextsNote;

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @country.
  ///
  /// In it, this message translates to:
  /// **'Paese'**
  String get country;

  /// No description provided for @about.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In it, this message translates to:
  /// **'Fonti, licenze e avvertenze'**
  String get aboutBody;

  /// No description provided for @aboutText.
  ///
  /// In it, this message translates to:
  /// **'App open source che funziona senza internet.\n\nLe schede di emergenza seguono le linee guida europee: primo soccorso del Consiglio Europeo di Rianimazione (ERC 2025) e della Croce Rossa (IFRC), preparazione secondo le linee guida dell\'Unione Europea sulle 72 ore, e le indicazioni delle protezioni civili nazionali. I documenti originali e le enciclopedie sono in Manuali e guide, con fonti e licenze.\n\nQuesta app non sostituisce un corso di primo soccorso né le indicazioni delle autorità.'**
  String get aboutText;

  /// No description provided for @documents.
  ///
  /// In it, this message translates to:
  /// **'Documenti'**
  String get documents;

  /// No description provided for @documentsBody.
  ///
  /// In it, this message translates to:
  /// **'Documenti ufficiali europei e internazionali, nella tua lingua quando esistono, altrimenti in inglese. Alcuni sono già nell\'app, gli altri si scaricano dal sito ufficiale.'**
  String get documentsBody;

  /// No description provided for @torchTitle.
  ///
  /// In it, this message translates to:
  /// **'Torcia e SOS'**
  String get torchTitle;

  /// No description provided for @torchSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Luce, SOS lampeggiante, luce dello schermo'**
  String get torchSubtitle;

  /// No description provided for @torchKeywords.
  ///
  /// In it, this message translates to:
  /// **'torcia luce buio sos lampeggiante segnale notte'**
  String get torchKeywords;

  /// No description provided for @torchOn.
  ///
  /// In it, this message translates to:
  /// **'Accendi torcia'**
  String get torchOn;

  /// No description provided for @torchOff.
  ///
  /// In it, this message translates to:
  /// **'Spegni torcia'**
  String get torchOff;

  /// No description provided for @torchMissing.
  ///
  /// In it, this message translates to:
  /// **'Torcia non disponibile su questo dispositivo. Usa la luce dello schermo.'**
  String get torchMissing;

  /// No description provided for @sosBlinking.
  ///
  /// In it, this message translates to:
  /// **'SOS lampeggiante'**
  String get sosBlinking;

  /// No description provided for @sosStop.
  ///
  /// In it, this message translates to:
  /// **'Ferma SOS'**
  String get sosStop;

  /// No description provided for @screenLight.
  ///
  /// In it, this message translates to:
  /// **'Luce dello schermo'**
  String get screenLight;

  /// No description provided for @sosInfo.
  ///
  /// In it, this message translates to:
  /// **'SOS = ··· ─── ··· ripetuto. Segnale internazionale di soccorso, visibile di notte anche da lontano.'**
  String get sosInfo;

  /// No description provided for @tapToClose.
  ///
  /// In it, this message translates to:
  /// **'Tocca per chiudere'**
  String get tapToClose;

  /// No description provided for @morseTitle.
  ///
  /// In it, this message translates to:
  /// **'Morse'**
  String get morseTitle;

  /// No description provided for @morseSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Trasmetti un messaggio con la luce'**
  String get morseSubtitle;

  /// No description provided for @morseKeywords.
  ///
  /// In it, this message translates to:
  /// **'morse codice segnale luce messaggio'**
  String get morseKeywords;

  /// No description provided for @morseMessage.
  ///
  /// In it, this message translates to:
  /// **'Messaggio'**
  String get morseMessage;

  /// No description provided for @useTorchToo.
  ///
  /// In it, this message translates to:
  /// **'Usa anche la torcia'**
  String get useTorchToo;

  /// No description provided for @repeat.
  ///
  /// In it, this message translates to:
  /// **'Ripeti'**
  String get repeat;

  /// No description provided for @morseSpeed.
  ///
  /// In it, this message translates to:
  /// **'Velocità: punto = {ms} ms'**
  String morseSpeed(int ms);

  /// No description provided for @transmit.
  ///
  /// In it, this message translates to:
  /// **'Trasmetti'**
  String get transmit;

  /// No description provided for @stop.
  ///
  /// In it, this message translates to:
  /// **'Ferma'**
  String get stop;

  /// No description provided for @morseTable.
  ///
  /// In it, this message translates to:
  /// **'Tabella'**
  String get morseTable;

  /// No description provided for @compassTitle.
  ///
  /// In it, this message translates to:
  /// **'Bussola'**
  String get compassTitle;

  /// No description provided for @compassSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Direzione e punti cardinali'**
  String get compassSubtitle;

  /// No description provided for @compassKeywords.
  ///
  /// In it, this message translates to:
  /// **'bussola nord direzione orientamento'**
  String get compassKeywords;

  /// No description provided for @compassUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Bussola non disponibile su questo dispositivo.'**
  String get compassUnavailable;

  /// No description provided for @compassWaiting.
  ///
  /// In it, this message translates to:
  /// **'In attesa del sensore…'**
  String get compassWaiting;

  /// No description provided for @compassHint.
  ///
  /// In it, this message translates to:
  /// **'Tieni il telefono in piano, lontano da metalli e magneti. Se la direzione è strana, muovi il telefono disegnando un 8.'**
  String get compassHint;

  /// No description provided for @cardinals.
  ///
  /// In it, this message translates to:
  /// **'N,NE,E,SE,S,SO,O,NO'**
  String get cardinals;

  /// No description provided for @locationTitle.
  ///
  /// In it, this message translates to:
  /// **'Posizione e mappe'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Coordinate GPS per i soccorsi e mappe offline'**
  String get locationSubtitle;

  /// No description provided for @locationKeywords.
  ///
  /// In it, this message translates to:
  /// **'posizione gps coordinate dove sono mappa utm mgrs mappe offline scarica'**
  String get locationKeywords;

  /// No description provided for @locServiceOff.
  ///
  /// In it, this message translates to:
  /// **'La localizzazione è disattivata. Attivala nelle impostazioni del telefono: il GPS funziona anche in modalità aereo.'**
  String get locServiceOff;

  /// No description provided for @locDenied.
  ///
  /// In it, this message translates to:
  /// **'Permesso di posizione negato. Puoi concederlo nelle impostazioni del telefono.'**
  String get locDenied;

  /// No description provided for @locUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Posizione non disponibile su questo dispositivo.'**
  String get locUnavailable;

  /// No description provided for @gpsError.
  ///
  /// In it, this message translates to:
  /// **'Errore GPS: {error}'**
  String gpsError(String error);

  /// No description provided for @searchingSats.
  ///
  /// In it, this message translates to:
  /// **'Ricerca satelliti… All\'aperto è più veloce.'**
  String get searchingSats;

  /// No description provided for @fmtDecimal.
  ///
  /// In it, this message translates to:
  /// **'Decimale'**
  String get fmtDecimal;

  /// No description provided for @fmtDms.
  ///
  /// In it, this message translates to:
  /// **'Gradi, minuti, secondi'**
  String get fmtDms;

  /// No description provided for @fmtMgrs.
  ///
  /// In it, this message translates to:
  /// **'MGRS (militari, soccorsi)'**
  String get fmtMgrs;

  /// No description provided for @altitude.
  ///
  /// In it, this message translates to:
  /// **'Altitudine'**
  String get altitude;

  /// No description provided for @accuracy.
  ///
  /// In it, this message translates to:
  /// **'Precisione'**
  String get accuracy;

  /// No description provided for @copy.
  ///
  /// In it, this message translates to:
  /// **'Copia'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In it, this message translates to:
  /// **'Copiato'**
  String get copied;

  /// No description provided for @locHint.
  ///
  /// In it, this message translates to:
  /// **'Al telefono con il {number} detta le coordinate decimali. Il percorso si registra solo con questa schermata aperta.'**
  String locHint(String number);

  /// No description provided for @westLetter.
  ///
  /// In it, this message translates to:
  /// **'O'**
  String get westLetter;

  /// No description provided for @suppliesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scorte'**
  String get suppliesTitle;

  /// No description provided for @suppliesSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Cosa hai, cosa manca e quanto: casa e zaino'**
  String get suppliesSubtitle;

  /// No description provided for @suppliesKeywords.
  ///
  /// In it, this message translates to:
  /// **'scorte acqua cibo razioni quanto calcolo provviste zaino casa inventario'**
  String get suppliesKeywords;

  /// No description provided for @people.
  ///
  /// In it, this message translates to:
  /// **'Persone'**
  String get people;

  /// No description provided for @days.
  ///
  /// In it, this message translates to:
  /// **'Giorni'**
  String get days;

  /// No description provided for @suppliesNote.
  ///
  /// In it, this message translates to:
  /// **'L\'UE raccomanda almeno 72 ore di autonomia; meglio di più. Il calcolo usa 4 litri d\'acqua a persona al giorno (3 da bere, 1 per cucinare e lavarsi) e 2000 kcal. Sono valori indicativi per adulti: caldo, fatica, bambini e anziani cambiano il fabbisogno. Consuma prima le scorte più vecchie.'**
  String get suppliesNote;

  /// No description provided for @falloutTitle.
  ///
  /// In it, this message translates to:
  /// **'Fallout'**
  String get falloutTitle;

  /// No description provided for @falloutSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Timer dopo un\'esplosione: cosa fare e quando'**
  String get falloutSubtitle;

  /// No description provided for @falloutKeywords.
  ///
  /// In it, this message translates to:
  /// **'fallout radiazioni dosimetro nucleare 7 10 decadimento'**
  String get falloutKeywords;

  /// No description provided for @measuredRate.
  ///
  /// In it, this message translates to:
  /// **'Intensità misurata'**
  String get measuredRate;

  /// No description provided for @falloutDose.
  ///
  /// In it, this message translates to:
  /// **'Restando all\'aperto 24 ore: circa {dose}. Al chiuso, al centro di un edificio solido o in cantina, è molto meno.'**
  String falloutDose(String dose);

  /// No description provided for @resetChecklistQ.
  ///
  /// In it, this message translates to:
  /// **'Azzerare la lista?'**
  String get resetChecklistQ;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In it, this message translates to:
  /// **'Azzera'**
  String get reset;

  /// No description provided for @doneOf.
  ///
  /// In it, this message translates to:
  /// **'{done} di {total}'**
  String doneOf(int done, int total);

  /// No description provided for @encyclopedias.
  ///
  /// In it, this message translates to:
  /// **'Enciclopedie offline'**
  String get encyclopedias;

  /// No description provided for @noEncyclopedias.
  ///
  /// In it, this message translates to:
  /// **'Nessuna enciclopedia sul telefono. Scaricala finché hai internet: poi funziona anche senza rete.'**
  String get noEncyclopedias;

  /// No description provided for @iosImportHint.
  ///
  /// In it, this message translates to:
  /// **'File molto grandi: scaricali sul computer da download.kiwix.org e copiali con il Finder o l\'app File nella cartella Refuge › zim, poi tocca ↻.'**
  String get iosImportHint;

  /// No description provided for @deleteFromDevice.
  ///
  /// In it, this message translates to:
  /// **'Elimina dal telefono'**
  String get deleteFromDevice;

  /// No description provided for @deleteQ.
  ///
  /// In it, this message translates to:
  /// **'Eliminare «{title}»?'**
  String deleteQ(String title);

  /// No description provided for @deleteBody.
  ///
  /// In it, this message translates to:
  /// **'Libererai {size}. Per riaverla dovrai scaricarla di nuovo.'**
  String deleteBody(String size);

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get delete;

  /// No description provided for @dlWaiting.
  ///
  /// In it, this message translates to:
  /// **'In attesa (serve il Wi-Fi se richiesto)…'**
  String get dlWaiting;

  /// No description provided for @dlRetrying.
  ///
  /// In it, this message translates to:
  /// **'Connessione persa, riprovo…'**
  String get dlRetrying;

  /// No description provided for @dlPaused.
  ///
  /// In it, this message translates to:
  /// **'In pausa · {pct}%'**
  String dlPaused(String pct);

  /// No description provided for @resume.
  ///
  /// In it, this message translates to:
  /// **'Riprendi'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In it, this message translates to:
  /// **'Pausa'**
  String get pause;

  /// No description provided for @catalogSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca nel catalogo Kiwix'**
  String get catalogSearchHint;

  /// No description provided for @catalogUnreachable.
  ///
  /// In it, this message translates to:
  /// **'Catalogo non raggiungibile. Serve una connessione a internet.'**
  String get catalogUnreachable;

  /// No description provided for @recWikimed.
  ///
  /// In it, this message translates to:
  /// **'WikiMed: enciclopedia medica (inglese)'**
  String get recWikimed;

  /// No description provided for @recWikipediaMedicine.
  ///
  /// In it, this message translates to:
  /// **'Wikipedia: solo medicina'**
  String get recWikipediaMedicine;

  /// No description provided for @recWikipedia.
  ///
  /// In it, this message translates to:
  /// **'Wikipedia completa'**
  String get recWikipedia;

  /// No description provided for @recWikivoyage.
  ///
  /// In it, this message translates to:
  /// **'Wikivoyage: paesi e città'**
  String get recWikivoyage;

  /// No description provided for @recMedicalTextbooks.
  ///
  /// In it, this message translates to:
  /// **'Libri di testo di medicina (inglese)'**
  String get recMedicalTextbooks;

  /// No description provided for @resultsFor.
  ///
  /// In it, this message translates to:
  /// **'Risultati per «{query}»'**
  String resultsFor(String query);

  /// No description provided for @flavourMini.
  ///
  /// In it, this message translates to:
  /// **'Mini, solo introduzioni'**
  String get flavourMini;

  /// No description provided for @flavourNopic.
  ///
  /// In it, this message translates to:
  /// **'Senza immagini'**
  String get flavourNopic;

  /// No description provided for @flavourMaxi.
  ///
  /// In it, this message translates to:
  /// **'Con immagini'**
  String get flavourMaxi;

  /// No description provided for @flavourFull.
  ///
  /// In it, this message translates to:
  /// **'Completa'**
  String get flavourFull;

  /// No description provided for @zimitUnsupported.
  ///
  /// In it, this message translates to:
  /// **'Sito web archiviato: formato non ancora supportato'**
  String get zimitUnsupported;

  /// No description provided for @download.
  ///
  /// In it, this message translates to:
  /// **'Scarica'**
  String get download;

  /// No description provided for @downloadQ.
  ///
  /// In it, this message translates to:
  /// **'Scaricare {size}?'**
  String downloadQ(String size);

  /// No description provided for @downloadBody.
  ///
  /// In it, this message translates to:
  /// **'Controlla di avere abbastanza spazio libero. Il download continua anche ad app chiusa e riprende da dove si era fermato.'**
  String get downloadBody;

  /// No description provided for @wifiOnly.
  ///
  /// In it, this message translates to:
  /// **'Solo con Wi-Fi'**
  String get wifiOnly;

  /// No description provided for @externalLink.
  ///
  /// In it, this message translates to:
  /// **'Link esterno: non disponibile offline.'**
  String get externalLink;

  /// No description provided for @mainPage.
  ///
  /// In it, this message translates to:
  /// **'Pagina principale'**
  String get mainPage;

  /// No description provided for @searchByTitle.
  ///
  /// In it, this message translates to:
  /// **'Cerca per titolo'**
  String get searchByTitle;

  /// No description provided for @searchByTitleTip.
  ///
  /// In it, this message translates to:
  /// **'Scrivi l\'inizio del titolo di una voce.'**
  String get searchByTitleTip;

  /// No description provided for @searchDocument.
  ///
  /// In it, this message translates to:
  /// **'Cerca nel documento (in inglese)'**
  String get searchDocument;

  /// No description provided for @pagesN.
  ///
  /// In it, this message translates to:
  /// **'{n} pagine'**
  String pagesN(int n);

  /// No description provided for @license.
  ///
  /// In it, this message translates to:
  /// **'Licenza'**
  String get license;

  /// No description provided for @reproducedInFull.
  ///
  /// In it, this message translates to:
  /// **'Documento riprodotto integralmente, senza modifiche.'**
  String get reproducedInFull;

  /// No description provided for @notAvailable.
  ///
  /// In it, this message translates to:
  /// **'Non disponibile in questa versione.'**
  String get notAvailable;

  /// No description provided for @entryMissing.
  ///
  /// In it, this message translates to:
  /// **'Voce «{title}» non trovata: scarica WikiMed da Manuali e guide per leggerla offline.'**
  String entryMissing(String title);

  /// No description provided for @catWater.
  ///
  /// In it, this message translates to:
  /// **'Acqua'**
  String get catWater;

  /// No description provided for @catFood.
  ///
  /// In it, this message translates to:
  /// **'Cibo'**
  String get catFood;

  /// No description provided for @catGas.
  ///
  /// In it, this message translates to:
  /// **'Gas per cucinare'**
  String get catGas;

  /// No description provided for @coversDays.
  ///
  /// In it, this message translates to:
  /// **'Basta per {days} giorni'**
  String coversDays(String days);

  /// No description provided for @missingWater.
  ///
  /// In it, this message translates to:
  /// **'Mancano {liters} L ≈ {bottles} bottiglie da 1,5 L'**
  String missingWater(String liters, int bottles);

  /// No description provided for @missingFood.
  ///
  /// In it, this message translates to:
  /// **'Mancano {kcal} kcal ≈ {kg} kg di pasta o riso'**
  String missingFood(String kcal, String kg);

  /// No description provided for @missingGas.
  ///
  /// In it, this message translates to:
  /// **'Mancano {n, plural, =1{1 cartuccia} other{{n} cartucce}} da 220 g'**
  String missingGas(int n);

  /// No description provided for @mealsHave.
  ///
  /// In it, this message translates to:
  /// **'{have} / {need} pasti caldi'**
  String mealsHave(int have, int need);

  /// No description provided for @addItem.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi'**
  String get addItem;

  /// No description provided for @addOne.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi uno'**
  String get addOne;

  /// No description provided for @consumeOne.
  ///
  /// In it, this message translates to:
  /// **'Togli uno'**
  String get consumeOne;

  /// No description provided for @itemName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get itemName;

  /// No description provided for @unitSize.
  ///
  /// In it, this message translates to:
  /// **'Contenuto di una confezione'**
  String get unitSize;

  /// No description provided for @kcalPer100.
  ///
  /// In it, this message translates to:
  /// **'kcal ogni 100 g'**
  String get kcalPer100;

  /// No description provided for @quantity.
  ///
  /// In it, this message translates to:
  /// **'Quantità'**
  String get quantity;

  /// No description provided for @save.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get save;

  /// No description provided for @chooseProduct.
  ///
  /// In it, this message translates to:
  /// **'Cosa vuoi aggiungere?'**
  String get chooseProduct;

  /// No description provided for @chooseSize.
  ///
  /// In it, this message translates to:
  /// **'Formato'**
  String get chooseSize;

  /// No description provided for @otherSize.
  ///
  /// In it, this message translates to:
  /// **'Altro formato'**
  String get otherSize;

  /// No description provided for @addToInventory.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi all\'inventario'**
  String get addToInventory;

  /// No description provided for @pWaterBottle.
  ///
  /// In it, this message translates to:
  /// **'Bottiglia d\'acqua'**
  String get pWaterBottle;

  /// No description provided for @pWaterTank.
  ///
  /// In it, this message translates to:
  /// **'Tanica d\'acqua'**
  String get pWaterTank;

  /// No description provided for @pPasta.
  ///
  /// In it, this message translates to:
  /// **'Pasta'**
  String get pPasta;

  /// No description provided for @pRice.
  ///
  /// In it, this message translates to:
  /// **'Riso'**
  String get pRice;

  /// No description provided for @pDryLegumes.
  ///
  /// In it, this message translates to:
  /// **'Legumi secchi'**
  String get pDryLegumes;

  /// No description provided for @pCannedLegumes.
  ///
  /// In it, this message translates to:
  /// **'Legumi in scatola'**
  String get pCannedLegumes;

  /// No description provided for @pTuna.
  ///
  /// In it, this message translates to:
  /// **'Tonno in scatola'**
  String get pTuna;

  /// No description provided for @pCannedMeat.
  ///
  /// In it, this message translates to:
  /// **'Carne in scatola'**
  String get pCannedMeat;

  /// No description provided for @pCannedVeg.
  ///
  /// In it, this message translates to:
  /// **'Verdure in scatola'**
  String get pCannedVeg;

  /// No description provided for @pNuts.
  ///
  /// In it, this message translates to:
  /// **'Frutta secca'**
  String get pNuts;

  /// No description provided for @pBiscuits.
  ///
  /// In it, this message translates to:
  /// **'Biscotti, cracker'**
  String get pBiscuits;

  /// No description provided for @pBars.
  ///
  /// In it, this message translates to:
  /// **'Barrette'**
  String get pBars;

  /// No description provided for @pUhtMilk.
  ///
  /// In it, this message translates to:
  /// **'Latte a lunga conservazione'**
  String get pUhtMilk;

  /// No description provided for @pPowderMilk.
  ///
  /// In it, this message translates to:
  /// **'Latte in polvere'**
  String get pPowderMilk;

  /// No description provided for @pOil.
  ///
  /// In it, this message translates to:
  /// **'Olio'**
  String get pOil;

  /// No description provided for @pSugar.
  ///
  /// In it, this message translates to:
  /// **'Zucchero'**
  String get pSugar;

  /// No description provided for @pHoney.
  ///
  /// In it, this message translates to:
  /// **'Miele'**
  String get pHoney;

  /// No description provided for @pCustomFood.
  ///
  /// In it, this message translates to:
  /// **'Altro cibo'**
  String get pCustomFood;

  /// No description provided for @pCartridge.
  ///
  /// In it, this message translates to:
  /// **'Cartuccia di gas'**
  String get pCartridge;

  /// No description provided for @pCustomOther.
  ///
  /// In it, this message translates to:
  /// **'Altro oggetto'**
  String get pCustomOther;

  /// No description provided for @falloutStartIntro.
  ///
  /// In it, this message translates to:
  /// **'Se c\'è stata un\'esplosione nucleare, avvia il timer: ti dice per quanto restare al riparo, cosa fare e cosa indossare in ogni momento.'**
  String get falloutStartIntro;

  /// No description provided for @falloutStartNow.
  ///
  /// In it, this message translates to:
  /// **'Esplosione adesso: avvia'**
  String get falloutStartNow;

  /// No description provided for @falloutStartAt.
  ///
  /// In it, this message translates to:
  /// **'Imposta l\'ora dell\'esplosione'**
  String get falloutStartAt;

  /// No description provided for @falloutResetQ.
  ///
  /// In it, this message translates to:
  /// **'Azzerare il timer?'**
  String get falloutResetQ;

  /// No description provided for @falloutSince.
  ///
  /// In it, this message translates to:
  /// **'Esplosione: {time}'**
  String falloutSince(String time);

  /// No description provided for @durationHM.
  ///
  /// In it, this message translates to:
  /// **'{h} h {m} min'**
  String durationHM(int h, int m);

  /// No description provided for @durationDHM.
  ///
  /// In it, this message translates to:
  /// **'{d} g {h} h {m} min'**
  String durationDHM(int d, int h, int m);

  /// No description provided for @falloutMax.
  ///
  /// In it, this message translates to:
  /// **'Radiazioni al massimo: è il momento più pericoloso.'**
  String get falloutMax;

  /// No description provided for @falloutRemaining.
  ///
  /// In it, this message translates to:
  /// **'Radiazioni circa al {pct} rispetto a 1 ora dopo l\'esplosione.'**
  String falloutRemaining(String pct);

  /// No description provided for @falloutNextPhase.
  ///
  /// In it, this message translates to:
  /// **'Prossima fase tra {left} (alle {time})'**
  String falloutNextPhase(String left, String time);

  /// No description provided for @whatToWear.
  ///
  /// In it, this message translates to:
  /// **'Se devi uscire'**
  String get whatToWear;

  /// No description provided for @whatToDoNow.
  ///
  /// In it, this message translates to:
  /// **'Cosa fare adesso'**
  String get whatToDoNow;

  /// No description provided for @falloutTimeline.
  ///
  /// In it, this message translates to:
  /// **'Fasi'**
  String get falloutTimeline;

  /// No description provided for @doNotGoOut.
  ///
  /// In it, this message translates to:
  /// **'Non uscire'**
  String get doNotGoOut;

  /// No description provided for @falloutBannerOut.
  ///
  /// In it, this message translates to:
  /// **'Esci solo se necessario, coperto dalla testa ai piedi'**
  String get falloutBannerOut;

  /// No description provided for @wearMask.
  ///
  /// In it, this message translates to:
  /// **'Mascherina FFP2/FFP3'**
  String get wearMask;

  /// No description provided for @wearGloves.
  ///
  /// In it, this message translates to:
  /// **'Guanti'**
  String get wearGloves;

  /// No description provided for @wearCovered.
  ///
  /// In it, this message translates to:
  /// **'Cappello, maniche lunghe, impermeabile'**
  String get wearCovered;

  /// No description provided for @wearBoots.
  ///
  /// In it, this message translates to:
  /// **'Scarpe chiuse o stivali'**
  String get wearBoots;

  /// No description provided for @phase0Title.
  ///
  /// In it, this message translates to:
  /// **'Pericolo massimo: al riparo subito'**
  String get phase0Title;

  /// No description provided for @phase0a.
  ///
  /// In it, this message translates to:
  /// **'Entra nell\'edificio più solido vicino a te e vai al centro o in cantina.'**
  String get phase0a;

  /// No description provided for @phase0b.
  ///
  /// In it, this message translates to:
  /// **'Chiudi porte e finestre, spegni ventilazione e condizionatori.'**
  String get phase0b;

  /// No description provided for @phase0c.
  ///
  /// In it, this message translates to:
  /// **'Se eri fuori: togli i vestiti, chiudili in un sacchetto e lavati.'**
  String get phase0c;

  /// No description provided for @phase0d.
  ///
  /// In it, this message translates to:
  /// **'Non uscire per nessun motivo.'**
  String get phase0d;

  /// No description provided for @phase1Title.
  ///
  /// In it, this message translates to:
  /// **'Resta al riparo'**
  String get phase1Title;

  /// No description provided for @phase1a.
  ///
  /// In it, this message translates to:
  /// **'Le radiazioni scendono in fretta: dopo 7 ore sono circa un decimo.'**
  String get phase1a;

  /// No description provided for @phase1b.
  ///
  /// In it, this message translates to:
  /// **'Resta dentro, lontano da muri esterni e tetto.'**
  String get phase1b;

  /// No description provided for @phase1c.
  ///
  /// In it, this message translates to:
  /// **'Ascolta radio, TV e allerte sul telefono.'**
  String get phase1c;

  /// No description provided for @phase1d.
  ///
  /// In it, this message translates to:
  /// **'Bevi e mangia solo da confezioni chiuse. Esci solo se il riparo è in pericolo (incendio, crollo).'**
  String get phase1d;

  /// No description provided for @phase2Title.
  ///
  /// In it, this message translates to:
  /// **'Esci solo se indispensabile'**
  String get phase2Title;

  /// No description provided for @phase2a.
  ///
  /// In it, this message translates to:
  /// **'Segui le autorità: possono indicare di spostarsi o evacuare.'**
  String get phase2a;

  /// No description provided for @phase2b.
  ///
  /// In it, this message translates to:
  /// **'Fai solo uscite brevissime, coperto dalla testa ai piedi.'**
  String get phase2b;

  /// No description provided for @phase2c.
  ///
  /// In it, this message translates to:
  /// **'Al rientro togli i vestiti esterni prima di entrare e lavati.'**
  String get phase2c;

  /// No description provided for @phase3Title.
  ///
  /// In it, this message translates to:
  /// **'Pericolo in calo'**
  String get phase3Title;

  /// No description provided for @phase3a.
  ///
  /// In it, this message translates to:
  /// **'Dopo 2 giorni le radiazioni sono circa un centesimo di quelle iniziali.'**
  String get phase3a;

  /// No description provided for @phase3b.
  ///
  /// In it, this message translates to:
  /// **'Fai uscite brevi, solo per necessità e con protezione. Evita la polvere.'**
  String get phase3b;

  /// No description provided for @phase3c.
  ///
  /// In it, this message translates to:
  /// **'Non mangiare cibi rimasti all\'aperto e usa acqua da contenitori chiusi.'**
  String get phase3c;

  /// No description provided for @phase4Title.
  ///
  /// In it, this message translates to:
  /// **'Pericolo molto ridotto'**
  String get phase4Title;

  /// No description provided for @phase4a.
  ///
  /// In it, this message translates to:
  /// **'Dopo 2 settimane le radiazioni sono circa un millesimo di quelle iniziali.'**
  String get phase4a;

  /// No description provided for @phase4b.
  ///
  /// In it, this message translates to:
  /// **'Segui le autorità per il ritorno alla normalità.'**
  String get phase4b;

  /// No description provided for @phase4c.
  ///
  /// In it, this message translates to:
  /// **'Continua le precauzioni su cibo e acqua.'**
  String get phase4c;

  /// No description provided for @falloutDisclaimer.
  ///
  /// In it, this message translates to:
  /// **'Indicazioni generali basate sulla regola del 7-10. Quando uscire lo decidono le autorità e le misure reali con un dosimetro.'**
  String get falloutDisclaimer;

  /// No description provided for @haveDosimeter.
  ///
  /// In it, this message translates to:
  /// **'Hai un dosimetro?'**
  String get haveDosimeter;

  /// No description provided for @inHours.
  ///
  /// In it, this message translates to:
  /// **'Tra {n, plural, =1{1 ora} other{{n} ore}}'**
  String inHours(int n);

  /// No description provided for @levelFlat.
  ///
  /// In it, this message translates to:
  /// **'In piano'**
  String get levelFlat;

  /// No description provided for @levelAlmost.
  ///
  /// In it, this message translates to:
  /// **'Quasi in piano'**
  String get levelAlmost;

  /// No description provided for @levelTilted.
  ///
  /// In it, this message translates to:
  /// **'Metti il telefono in piano'**
  String get levelTilted;

  /// No description provided for @tiltDegrees.
  ///
  /// In it, this message translates to:
  /// **'Inclinazione {n}°'**
  String tiltDegrees(int n);

  /// No description provided for @mapsTitle.
  ///
  /// In it, this message translates to:
  /// **'Mappe offline'**
  String get mapsTitle;

  /// No description provided for @onbMapTitle.
  ///
  /// In it, this message translates to:
  /// **'Mappa offline'**
  String get onbMapTitle;

  /// No description provided for @onbMapBody.
  ///
  /// In it, this message translates to:
  /// **'Scegli quali mappe tenere sul telefono. Funzionano senza internet, con la tua posizione GPS.'**
  String get onbMapBody;

  /// No description provided for @mapWorld.
  ///
  /// In it, this message translates to:
  /// **'Mondo'**
  String get mapWorld;

  /// No description provided for @mapWorldBody.
  ///
  /// In it, this message translates to:
  /// **'Tutti i paesi, le città principali e le grandi strade.'**
  String get mapWorldBody;

  /// No description provided for @mapEurope.
  ///
  /// In it, this message translates to:
  /// **'Europa'**
  String get mapEurope;

  /// No description provided for @mapEuropeBody.
  ///
  /// In it, this message translates to:
  /// **'Città, paesi e strade principali di tutta Europa.'**
  String get mapEuropeBody;

  /// No description provided for @mapCountry.
  ///
  /// In it, this message translates to:
  /// **'{name} dettagliata'**
  String mapCountry(String name);

  /// No description provided for @mapCountryBody.
  ///
  /// In it, this message translates to:
  /// **'Tutte le strade, le vie e i sentieri, fino al singolo edificio.'**
  String get mapCountryBody;

  /// No description provided for @mapKeepOpen.
  ///
  /// In it, this message translates to:
  /// **'Tieni l\'app aperta finché il download non finisce.'**
  String get mapKeepOpen;

  /// No description provided for @mapDownloadSelected.
  ///
  /// In it, this message translates to:
  /// **'Scarica le mappe scelte'**
  String get mapDownloadSelected;

  /// No description provided for @mapReady.
  ///
  /// In it, this message translates to:
  /// **'Scaricata'**
  String get mapReady;

  /// No description provided for @mapFailed.
  ///
  /// In it, this message translates to:
  /// **'Download non riuscito. Riprova.'**
  String get mapFailed;

  /// No description provided for @mapDownloading.
  ///
  /// In it, this message translates to:
  /// **'{pct}% di {size}'**
  String mapDownloading(String pct, String size);

  /// No description provided for @mapPreparing.
  ///
  /// In it, this message translates to:
  /// **'Preparazione…'**
  String get mapPreparing;

  /// No description provided for @mapSizeCalc.
  ///
  /// In it, this message translates to:
  /// **'Calcolo della dimensione…'**
  String get mapSizeCalc;

  /// No description provided for @mapSizeUnknown.
  ///
  /// In it, this message translates to:
  /// **'Dimensione non disponibile (serve internet)'**
  String get mapSizeUnknown;

  /// No description provided for @mapNone.
  ///
  /// In it, this message translates to:
  /// **'Nessuna mappa offline. Scaricala per vedere dove sei anche senza internet.'**
  String get mapNone;

  /// No description provided for @mapDownloadButton.
  ///
  /// In it, this message translates to:
  /// **'Scarica mappe'**
  String get mapDownloadButton;

  /// No description provided for @mapSkip.
  ///
  /// In it, this message translates to:
  /// **'Salta, lo faccio dopo'**
  String get mapSkip;

  /// No description provided for @zoomIn.
  ///
  /// In it, this message translates to:
  /// **'Ingrandisci'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In it, this message translates to:
  /// **'Rimpicciolisci'**
  String get zoomOut;

  /// No description provided for @wholeWorld.
  ///
  /// In it, this message translates to:
  /// **'Tutto il mondo'**
  String get wholeWorld;

  /// No description provided for @myPosition.
  ///
  /// In it, this message translates to:
  /// **'La mia posizione'**
  String get myPosition;

  /// No description provided for @downloadsActive.
  ///
  /// In it, this message translates to:
  /// **'{n, plural, =1{Download in corso} other{{n} download in corso}}'**
  String downloadsActive(int n);

  /// No description provided for @mapsOnPhone.
  ///
  /// In it, this message translates to:
  /// **'Sul telefono'**
  String get mapsOnPhone;

  /// No description provided for @mapsInProgress.
  ///
  /// In it, this message translates to:
  /// **'In corso'**
  String get mapsInProgress;

  /// No description provided for @mapsAvailable.
  ///
  /// In it, this message translates to:
  /// **'Disponibili'**
  String get mapsAvailable;

  /// No description provided for @mapUpdate.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna all\'ultima versione'**
  String get mapUpdate;

  /// No description provided for @mapUpdatedOn.
  ///
  /// In it, this message translates to:
  /// **'del {date}'**
  String mapUpdatedOn(String date);

  /// No description provided for @mapsMoreBody.
  ///
  /// In it, this message translates to:
  /// **'Scarica, aggiorna o elimina le mappe del mondo, dell\'Europa e dei paesi'**
  String get mapsMoreBody;

  /// No description provided for @emptySection.
  ///
  /// In it, this message translates to:
  /// **'Niente ancora. Tocca «Aggiungi».'**
  String get emptySection;

  /// No description provided for @catElectricity.
  ///
  /// In it, this message translates to:
  /// **'Elettricità'**
  String get catElectricity;

  /// No description provided for @chargesHave.
  ///
  /// In it, this message translates to:
  /// **'{have} / {need} ricariche'**
  String chargesHave(int have, int need);

  /// No description provided for @missingCharges.
  ///
  /// In it, this message translates to:
  /// **'Mancano {n} ricariche del telefono ≈ {pb} power bank da 10.000 mAh'**
  String missingCharges(int n, int pb);

  /// No description provided for @electricityBasis.
  ///
  /// In it, this message translates to:
  /// **'Conto: 1 ricarica completa del telefono a persona al giorno. Power bank al 65% e power station all\'85% della capacità dichiarata.'**
  String get electricityBasis;

  /// No description provided for @pPowerBank.
  ///
  /// In it, this message translates to:
  /// **'Power bank'**
  String get pPowerBank;

  /// No description provided for @pPowerStation.
  ///
  /// In it, this message translates to:
  /// **'Power station'**
  String get pPowerStation;

  /// No description provided for @pSolarPanel.
  ///
  /// In it, this message translates to:
  /// **'Pannello solare'**
  String get pSolarPanel;

  /// No description provided for @pBatteriesAA.
  ///
  /// In it, this message translates to:
  /// **'Batterie AA'**
  String get pBatteriesAA;

  /// No description provided for @pBatteriesAAA.
  ///
  /// In it, this message translates to:
  /// **'Batterie AAA'**
  String get pBatteriesAAA;

  /// No description provided for @radioTitle.
  ///
  /// In it, this message translates to:
  /// **'Radio in emergenza'**
  String get radioTitle;

  /// No description provided for @radioSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Cosa ascoltare e su quali frequenze'**
  String get radioSubtitle;

  /// No description provided for @radioKeywords.
  ///
  /// In it, this message translates to:
  /// **'radio frequenze fm am dab onde medie notizie autorità walkie talkie pmr'**
  String get radioKeywords;

  /// No description provided for @radioListen.
  ///
  /// In it, this message translates to:
  /// **'Cosa ascoltare'**
  String get radioListen;

  /// No description provided for @radioListenBody.
  ///
  /// In it, this message translates to:
  /// **'Sono le emittenti che trasmettono i messaggi ufficiali delle autorità durante un\'emergenza.'**
  String get radioListenBody;

  /// No description provided for @radioFm.
  ///
  /// In it, this message translates to:
  /// **'FM nelle città principali'**
  String get radioFm;

  /// No description provided for @radioAm.
  ///
  /// In it, this message translates to:
  /// **'Onde medie e lunghe (AM)'**
  String get radioAm;

  /// No description provided for @radioAmNote.
  ///
  /// In it, this message translates to:
  /// **'Di notte le onde medie e lunghe arrivano molto più lontano.'**
  String get radioAmNote;

  /// No description provided for @radioDab.
  ///
  /// In it, this message translates to:
  /// **'Radio digitale DAB+'**
  String get radioDab;

  /// No description provided for @radioNationwide.
  ///
  /// In it, this message translates to:
  /// **'In tutto il paese'**
  String get radioNationwide;

  /// No description provided for @radioNoData.
  ///
  /// In it, this message translates to:
  /// **'Per questo paese non ci sono ancora dati verificati.'**
  String get radioNoData;

  /// No description provided for @radioNotFound.
  ///
  /// In it, this message translates to:
  /// **'Se non trovi la stazione'**
  String get radioNotFound;

  /// No description provided for @radioTip1.
  ///
  /// In it, this message translates to:
  /// **'Fai la ricerca automatica su tutta la banda FM e poi su quella AM.'**
  String get radioTip1;

  /// No description provided for @radioTip2.
  ///
  /// In it, this message translates to:
  /// **'Avvicinati a una finestra o sali di piano, ed estendi del tutto l\'antenna.'**
  String get radioTip2;

  /// No description provided for @radioTip3.
  ///
  /// In it, this message translates to:
  /// **'Le frequenze FM cambiano da zona a zona: quelle qui sono delle città principali.'**
  String get radioTip3;

  /// No description provided for @radioTip4.
  ///
  /// In it, this message translates to:
  /// **'Ascolta a orari fissi, all\'inizio di ogni ora, per risparmiare le batterie.'**
  String get radioTip4;

  /// No description provided for @radioWhich.
  ///
  /// In it, this message translates to:
  /// **'Che radio tenere in casa'**
  String get radioWhich;

  /// No description provided for @radioWhich1.
  ///
  /// In it, this message translates to:
  /// **'Una radio a manovella o a pile con FM, onde medie (AM) e, se possibile, DAB+ e onde corte.'**
  String get radioWhich1;

  /// No description provided for @radioWhich2.
  ///
  /// In it, this message translates to:
  /// **'Batterie di ricambio dello stesso formato, conservate a parte.'**
  String get radioWhich2;

  /// No description provided for @radioWhich3.
  ///
  /// In it, this message translates to:
  /// **'Funziona anche se il telefono è scarico e la rete è giù.'**
  String get radioWhich3;

  /// No description provided for @pmrTitle.
  ///
  /// In it, this message translates to:
  /// **'Walkie-talkie PMR446'**
  String get pmrTitle;

  /// No description provided for @pmrBody.
  ///
  /// In it, this message translates to:
  /// **'Si usano senza licenza in tutta Europa (0,5 W, di solito 1-3 km). Accordati in famiglia su un canale.'**
  String get pmrBody;

  /// No description provided for @pmrChannel.
  ///
  /// In it, this message translates to:
  /// **'Can. {n}'**
  String pmrChannel(int n);

  /// No description provided for @radioOpsec.
  ///
  /// In it, this message translates to:
  /// **'Ricevere è sicuro: chi ascolta non emette segnali. Trasmettere invece si può rilevare: in zona di guerra parla poco, brevemente e solo se serve.'**
  String get radioOpsec;

  /// No description provided for @radioChecked.
  ///
  /// In it, this message translates to:
  /// **'Dati controllati su fonti ufficiali il {date}.'**
  String radioChecked(String date);

  /// No description provided for @radioFinder.
  ///
  /// In it, this message translates to:
  /// **'Cerca la frequenza della tua zona (online): {name}'**
  String radioFinder(String name);

  /// No description provided for @docDownloadFailed.
  ///
  /// In it, this message translates to:
  /// **'Download non riuscito. Controlla la connessione e riprova.'**
  String get docDownloadFailed;

  /// No description provided for @docDownloading.
  ///
  /// In it, this message translates to:
  /// **'Download… {pct}%'**
  String docDownloading(String pct);

  /// No description provided for @docToDownload.
  ///
  /// In it, this message translates to:
  /// **'Da scaricare · {size}'**
  String docToDownload(String size);

  /// No description provided for @docNotDownloaded.
  ///
  /// In it, this message translates to:
  /// **'Scarica prima il documento da Manuali e guide.'**
  String get docNotDownloaded;

  /// No description provided for @planTitle.
  ///
  /// In it, this message translates to:
  /// **'Piano di emergenza della famiglia'**
  String get planTitle;

  /// No description provided for @planSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Contatti, punti d\'incontro, chi aiuta chi'**
  String get planSubtitle;

  /// No description provided for @planIntro.
  ///
  /// In it, this message translates to:
  /// **'Mettetevi d\'accordo prima, tutti insieme: in un\'emergenza il telefono e internet possono non funzionare.'**
  String get planIntro;

  /// No description provided for @planContacts.
  ///
  /// In it, this message translates to:
  /// **'Contatti di emergenza'**
  String get planContacts;

  /// No description provided for @planContactsHint.
  ///
  /// In it, this message translates to:
  /// **'Nome e telefono di 2–3 persone, anche una fuori città'**
  String get planContactsHint;

  /// No description provided for @planMeetNear.
  ///
  /// In it, this message translates to:
  /// **'Punto d\'incontro vicino a casa'**
  String get planMeetNear;

  /// No description provided for @planMeetNearHint.
  ///
  /// In it, this message translates to:
  /// **'Es. davanti alla farmacia all\'angolo'**
  String get planMeetNearHint;

  /// No description provided for @planMeetFar.
  ///
  /// In it, this message translates to:
  /// **'Punto d\'incontro fuori dal quartiere'**
  String get planMeetFar;

  /// No description provided for @planMeetFarHint.
  ///
  /// In it, this message translates to:
  /// **'Se non si può tornare a casa'**
  String get planMeetFarHint;

  /// No description provided for @planShelter.
  ///
  /// In it, this message translates to:
  /// **'Rifugio o area di attesa più vicina'**
  String get planShelter;

  /// No description provided for @planShelterHint.
  ///
  /// In it, this message translates to:
  /// **'Quella indicata dal comune'**
  String get planShelterHint;

  /// No description provided for @planChildren.
  ///
  /// In it, this message translates to:
  /// **'Chi va a prendere i bambini'**
  String get planChildren;

  /// No description provided for @planChildrenHint.
  ///
  /// In it, this message translates to:
  /// **'Scuola, asilo, e chi li prende se tu non puoi'**
  String get planChildrenHint;

  /// No description provided for @planHelp.
  ///
  /// In it, this message translates to:
  /// **'Chi ha bisogno di aiuto'**
  String get planHelp;

  /// No description provided for @planHelpHint.
  ///
  /// In it, this message translates to:
  /// **'Anziani, persone con disabilità, animali: chi li aiuta e come'**
  String get planHelpHint;

  /// No description provided for @planHealth.
  ///
  /// In it, this message translates to:
  /// **'Medicine e informazioni mediche'**
  String get planHealth;

  /// No description provided for @planHealthHint.
  ///
  /// In it, this message translates to:
  /// **'Farmaci, allergie, dispositivi medici'**
  String get planHealthHint;

  /// No description provided for @planNotes.
  ///
  /// In it, this message translates to:
  /// **'Altre note'**
  String get planNotes;

  /// No description provided for @planCopy.
  ///
  /// In it, this message translates to:
  /// **'Copia il piano'**
  String get planCopy;

  /// No description provided for @planCopied.
  ///
  /// In it, this message translates to:
  /// **'Piano copiato: incollalo in un messaggio o stampalo.'**
  String get planCopied;

  /// No description provided for @planPaper.
  ///
  /// In it, this message translates to:
  /// **'Scrivi il piano anche su carta e tienilo con le scorte. Dallo alle persone dei contatti di emergenza.'**
  String get planPaper;

  /// No description provided for @docDownloadAll.
  ///
  /// In it, this message translates to:
  /// **'Scarica tutti ({n} · {size})'**
  String docDownloadAll(int n, String size);

  /// No description provided for @docDownloadingAll.
  ///
  /// In it, this message translates to:
  /// **'Download… ne mancano {n}'**
  String docDownloadingAll(int n);

  /// No description provided for @civilProtectionGuides.
  ///
  /// In it, this message translates to:
  /// **'Guide della Protezione Civile'**
  String get civilProtectionGuides;

  /// No description provided for @civilProtectionGuidesBody.
  ///
  /// In it, this message translates to:
  /// **'Cosa fare prima, durante e dopo: terremoto, alluvione, incendi boschivi, incidente industriale, maremoto, emergenza nucleare, dighe e vulcani. Testi integrali del Dipartimento della Protezione Civile.'**
  String get civilProtectionGuidesBody;

  /// No description provided for @libraryKeywords.
  ///
  /// In it, this message translates to:
  /// **'biblioteca documenti manuali pdf enciclopedia wikipedia wikimed guide protezione civile leggere manuali guide consultare'**
  String get libraryKeywords;

  /// No description provided for @manageMaps.
  ///
  /// In it, this message translates to:
  /// **'Mappe'**
  String get manageMaps;

  /// No description provided for @addPoint.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi punto'**
  String get addPoint;

  /// No description provided for @savedPoints.
  ///
  /// In it, this message translates to:
  /// **'Punti salvati'**
  String get savedPoints;

  /// No description provided for @recordTrack.
  ///
  /// In it, this message translates to:
  /// **'Percorso'**
  String get recordTrack;

  /// No description provided for @pointName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get pointName;

  /// No description provided for @pointNameHint.
  ///
  /// In it, this message translates to:
  /// **'Es. casa, punto d\'incontro'**
  String get pointNameHint;

  /// No description provided for @pointDefaultName.
  ///
  /// In it, this message translates to:
  /// **'Punto'**
  String get pointDefaultName;

  /// No description provided for @coordinates.
  ///
  /// In it, this message translates to:
  /// **'Coordinate'**
  String get coordinates;

  /// No description provided for @coordinatesHelp.
  ///
  /// In it, this message translates to:
  /// **'Decimali (45.4642, 9.1900) o gradi, primi e secondi (45°27\'51\"N 9°11\'24\"E). Puoi anche tenere premuto sulla mappa.'**
  String get coordinatesHelp;

  /// No description provided for @coordsInvalid.
  ///
  /// In it, this message translates to:
  /// **'Coordinate non valide'**
  String get coordsInvalid;

  /// No description provided for @useMyPosition.
  ///
  /// In it, this message translates to:
  /// **'Usa la mia posizione'**
  String get useMyPosition;

  /// No description provided for @pointsEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun punto salvato. Aggiungine uno con le coordinate o tieni premuto sulla mappa.'**
  String get pointsEmpty;

  /// No description provided for @clearTrack.
  ///
  /// In it, this message translates to:
  /// **'Cancella'**
  String get clearTrack;

  /// No description provided for @trackLength.
  ///
  /// In it, this message translates to:
  /// **'Percorso registrato: {dist}'**
  String trackLength(String dist);

  /// No description provided for @distanceTo.
  ///
  /// In it, this message translates to:
  /// **'{dist} in linea d\'aria · verso {dir} ({deg}°)'**
  String distanceTo(String dist, String dir, int deg);

  /// No description provided for @onbContentTitle.
  ///
  /// In it, this message translates to:
  /// **'Manuali ed enciclopedie'**
  String get onbContentTitle;

  /// No description provided for @onbContentBody.
  ///
  /// In it, this message translates to:
  /// **'Scegli cosa tenere sul telefono per consultarlo senza internet. Le schede di emergenza e le guide della Protezione Civile sono già incluse.'**
  String get onbContentBody;

  /// No description provided for @onbPackDocs.
  ///
  /// In it, this message translates to:
  /// **'Documenti ufficiali europei'**
  String get onbPackDocs;

  /// No description provided for @onbPackDocsBody.
  ///
  /// In it, this message translates to:
  /// **'Primo soccorso (ERC, OMS), guide alla preparazione dei governi europei. Nella tua lingua quando esistono.'**
  String get onbPackDocsBody;

  /// No description provided for @onbPackMedicine.
  ///
  /// In it, this message translates to:
  /// **'Wikipedia: medicina'**
  String get onbPackMedicine;

  /// No description provided for @onbPackMedicineBody.
  ///
  /// In it, this message translates to:
  /// **'Le voci di medicina di Wikipedia: malattie, sintomi, farmaci, anatomia.'**
  String get onbPackMedicineBody;

  /// No description provided for @onbDownloadSelected.
  ///
  /// In it, this message translates to:
  /// **'Scarica i selezionati ({size})'**
  String onbDownloadSelected(String size);

  /// No description provided for @trackTitle.
  ///
  /// In it, this message translates to:
  /// **'Percorso'**
  String get trackTitle;

  /// No description provided for @trackHelp.
  ///
  /// In it, this message translates to:
  /// **'Tocca «Percorso» per registrare la strada che fai: compare come linea blu sulla mappa. Serve a ritrovare la via del ritorno (verso casa, l\'auto, un rifugio) o a mostrare ai soccorritori da dove sei passato. Si registra solo con questa schermata aperta; tocca di nuovo per fermare.'**
  String get trackHelp;

  /// No description provided for @trackShow.
  ///
  /// In it, this message translates to:
  /// **'Tocca per vederlo sulla mappa'**
  String get trackShow;

  /// No description provided for @pointsAndTrack.
  ///
  /// In it, this message translates to:
  /// **'Punti e percorso'**
  String get pointsAndTrack;

  /// No description provided for @suppliesHome.
  ///
  /// In it, this message translates to:
  /// **'Casa'**
  String get suppliesHome;

  /// No description provided for @suppliesBackpack.
  ///
  /// In it, this message translates to:
  /// **'Zaino'**
  String get suppliesBackpack;

  /// No description provided for @shopFor.
  ///
  /// In it, this message translates to:
  /// **'Per {people} persone e {days} giorni'**
  String shopFor(int people, int days);

  /// No description provided for @shopAllDone.
  ///
  /// In it, this message translates to:
  /// **'Non manca niente.'**
  String get shopAllDone;

  /// No description provided for @shopCopied.
  ///
  /// In it, this message translates to:
  /// **'Lista copiata: incollala in un messaggio o nelle note.'**
  String get shopCopied;

  /// No description provided for @copyShopping.
  ///
  /// In it, this message translates to:
  /// **'Copia la lista della spesa'**
  String get copyShopping;

  /// No description provided for @shoppingList.
  ///
  /// In it, this message translates to:
  /// **'Lista della spesa'**
  String get shoppingList;

  /// No description provided for @filterAll.
  ///
  /// In it, this message translates to:
  /// **'Tutto'**
  String get filterAll;

  /// No description provided for @filterMissing.
  ///
  /// In it, this message translates to:
  /// **'Cosa manca'**
  String get filterMissing;

  /// No description provided for @suppliesQuantities.
  ///
  /// In it, this message translates to:
  /// **'Le quantità'**
  String get suppliesQuantities;

  /// No description provided for @suppliesQuantitiesHint.
  ///
  /// In it, this message translates to:
  /// **'Quanto hai rispetto a quanto serve. Tocca una voce per vedere e aggiornare quello che hai.'**
  String get suppliesQuantitiesHint;

  /// No description provided for @quantitiesEnough.
  ///
  /// In it, this message translates to:
  /// **'Le quantità bastano.'**
  String get quantitiesEnough;

  /// No description provided for @suppliesHaveTitle.
  ///
  /// In it, this message translates to:
  /// **'Da avere'**
  String get suppliesHaveTitle;

  /// No description provided for @suppliesHaveHint.
  ///
  /// In it, this message translates to:
  /// **'Cose che ci sono o non ci sono: spunta quelle che hai. Le voci seguono le linee guida UE e delle protezioni civili europee.'**
  String get suppliesHaveHint;

  /// No description provided for @inBag.
  ///
  /// In it, this message translates to:
  /// **'nello zaino'**
  String get inBag;

  /// No description provided for @inBagChange.
  ///
  /// In it, this message translates to:
  /// **'È nello zaino: cambialo nella scheda Zaino.'**
  String get inBagChange;

  /// No description provided for @addOwnItem.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi una voce'**
  String get addOwnItem;

  /// No description provided for @bagLegend.
  ///
  /// In it, this message translates to:
  /// **'Per ogni cosa scegli se è già nello zaino, se la prendi da casa quando esci, o se manca. Lo zaino serve se devi lasciare la casa in fretta.'**
  String get bagLegend;

  /// No description provided for @beforeLeaving.
  ///
  /// In it, this message translates to:
  /// **'Prima di uscire prendi'**
  String get beforeLeaving;

  /// No description provided for @beforeLeavingAlways.
  ///
  /// In it, this message translates to:
  /// **'Chiavi, telefono e portafoglio'**
  String get beforeLeavingAlways;

  /// No description provided for @bagReady.
  ///
  /// In it, this message translates to:
  /// **'{done} di {total} pronte'**
  String bagReady(int done, int total);

  /// No description provided for @bagCheckTitle.
  ///
  /// In it, this message translates to:
  /// **'Controlla lo zaino ogni 6 mesi'**
  String get bagCheckTitle;

  /// No description provided for @bagCheckBody.
  ///
  /// In it, this message translates to:
  /// **'Cibo, farmaci e batterie scadono. Ultimo controllo: {date}'**
  String bagCheckBody(String date);

  /// No description provided for @bagCheckNever.
  ///
  /// In it, this message translates to:
  /// **'mai'**
  String get bagCheckNever;

  /// No description provided for @bagCheckDone.
  ///
  /// In it, this message translates to:
  /// **'Fatto oggi'**
  String get bagCheckDone;

  /// No description provided for @bagNoPowerBank.
  ///
  /// In it, this message translates to:
  /// **'In casa non c\'è: aggiungilo in Casa › Elettricità.'**
  String get bagNoPowerBank;

  /// No description provided for @bagPacked.
  ///
  /// In it, this message translates to:
  /// **'Nello zaino'**
  String get bagPacked;

  /// No description provided for @bagFromHome.
  ///
  /// In it, this message translates to:
  /// **'Da casa, al momento'**
  String get bagFromHome;

  /// No description provided for @bagMissing.
  ///
  /// In it, this message translates to:
  /// **'Manca'**
  String get bagMissing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
