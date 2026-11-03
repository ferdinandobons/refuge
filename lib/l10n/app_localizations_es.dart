// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Refuge';

  @override
  String get tabEmergency => 'Emergencia';

  @override
  String get tabPrepare => 'Prepararse';

  @override
  String get tabTools => 'Herramientas';

  @override
  String get tabMore => 'Más';

  @override
  String get onbLanguageTitle => 'Elige el idioma';

  @override
  String get onbCountryTitle => '¿En qué país estás?';

  @override
  String get onbCountryHint =>
      'Sirve para el número de emergencias y las alertas locales. Puedes cambiarlo después.';

  @override
  String get onbReadyTitle => 'Todo listo';

  @override
  String onbReadyBody(String number) {
    return 'La app funciona sin internet. En caso de emergencia, llama al $number.';
  }

  @override
  String get onbStart => 'Empezar';

  @override
  String get onbPackWikimed => 'WikiMed (inglés)';

  @override
  String get onbPackWikimedBody =>
      'Enciclopedia médica: enfermedades, síntomas, medicamentos, heridas, primeros auxilios.';

  @override
  String get onbPackWikipedia => 'Wikipedia en tu idioma';

  @override
  String get onbPackWikipediaBody =>
      'Todo el conocimiento general: historia, lugares, ciencia, técnica. Muy grande.';

  @override
  String get onbPackWikivoyage => 'Wikivoyage';

  @override
  String get onbPackWikivoyageBody =>
      'Países y ciudades: cómo desplazarse, fronteras, hospitales, información práctica.';

  @override
  String get onbDownloadNote =>
      'Las descargas continúan mientras usas la app y aparecen arriba en la pantalla Emergencia. Puedes añadir o quitar contenidos cuando quieras desde Herramientas › Manuales y guías.';

  @override
  String callNumber(String number) {
    return 'Llamar al $number';
  }

  @override
  String get sosLight => 'Luz SOS';

  @override
  String get searchHint => 'Busca: sangre, yodo, terremoto…';

  @override
  String get searchTip =>
      'Escribe qué pasa o qué necesitas. Funciona también con palabras incompletas o con errores.';

  @override
  String get searchEmpty => 'Sin resultados.';

  @override
  String get whatsHappening => '¿Qué pasa?';

  @override
  String get search => 'Buscar';

  @override
  String get readAloud => 'Leer en voz alta';

  @override
  String get allSteps => 'Todos los pasos';

  @override
  String get neverDo => 'No hagas';

  @override
  String get sources => 'Fuentes';

  @override
  String stepOf(int n, int total) {
    return 'Paso $n de $total';
  }

  @override
  String get previous => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Hecho';

  @override
  String get countryIT => 'Italia';

  @override
  String get countryFR => 'Francia';

  @override
  String get countryDE => 'Alemania';

  @override
  String get countryES => 'España';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryCH => 'Suiza';

  @override
  String get countryBE => 'Bélgica';

  @override
  String get countryNL => 'Países Bajos';

  @override
  String get countryLU => 'Luxemburgo';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryGB => 'Reino Unido';

  @override
  String get countryIE => 'Irlanda';

  @override
  String get countryOther => 'Otro país europeo';

  @override
  String get officialAlerts => 'alertas oficiales';

  @override
  String get sirenFR =>
      'Alarma: sonido que sube y baja durante 1 minuto y 41 segundos, repetido 3 veces. Fin de la alarma: sonido continuo de 30 segundos. Prueba el primer miércoles de cada mes a mediodía.';

  @override
  String get sirenDE =>
      'Alarma: sonido que sube y baja durante 1 minuto. Fin de la alarma: sonido continuo de 1 minuto.';

  @override
  String get sirenAT =>
      'Prealarma: sonido continuo de 3 minutos. Alarma: sonido que sube y baja durante 1 minuto. Fin de la alarma: sonido continuo de 1 minuto.';

  @override
  String get sirenCH =>
      'Alarma general: sonido que sube y baja durante 1 minuto, repetido a los 2 minutos. Escucha la radio y sigue las instrucciones.';

  @override
  String get noteIodineDE =>
      'En Alemania, las pastillas de yodo no están indicadas para mayores de 45 años.';

  @override
  String yourCountry(String name) {
    return 'Tu país: $name';
  }

  @override
  String get emergencyNumber => 'Número de emergencias';

  @override
  String get serviceAmbulance => 'Ambulancia';

  @override
  String get serviceFire => 'Bomberos';

  @override
  String get servicePolice => 'Policía';

  @override
  String get servicePoison => 'Información toxicológica';

  @override
  String get serviceDeafSms => 'SMS para personas sordas';

  @override
  String get phoneAlerts => 'Alertas en el móvil';

  @override
  String phoneAlertsBody(String name) {
    return '$name: llegan solas al móvil, incluso sin app. Mantenlas activadas en los ajustes del móvil.';
  }

  @override
  String get sirens => 'Sirenas';

  @override
  String get checklists => 'Provisiones y plan';

  @override
  String get offlineContent => 'Descárgalo mientras haya internet';

  @override
  String get downloadEncyclopedias => 'Descargar enciclopedias';

  @override
  String get downloadEncyclopediasBody =>
      'Wikipedia y WikiMed en tu idioma, para leer sin conexión.';

  @override
  String get library => 'Manuales y guías';

  @override
  String get libraryBody =>
      'Documentos oficiales europeos, guías de Protección Civil y enciclopedias sin conexión';

  @override
  String get originalTexts => 'Textos originales';

  @override
  String get originalTextsBody =>
      'Textos íntegros de la Protección Civil italiana (en italiano)';

  @override
  String get originalTextsNote =>
      'Textos completos en el idioma original, para saber más.';

  @override
  String get language => 'Idioma';

  @override
  String get country => 'País';

  @override
  String get about => 'Información';

  @override
  String get aboutBody => 'Fuentes, licencias y advertencias';

  @override
  String get aboutText =>
      'App de código abierto que funciona sin internet.\n\nLas fichas de emergencia siguen las guías europeas: primeros auxilios del Consejo Europeo de Resucitación (ERC 2025) y de la Cruz Roja (IFRC), preparación según las directrices de la Unión Europea sobre las 72 horas, e indicaciones de las protecciones civiles nacionales. Los documentos originales y las enciclopedias están en Manuales y guías, con fuentes y licencias.\n\nEsta app no sustituye a un curso de primeros auxilios ni a las indicaciones de las autoridades.';

  @override
  String get documents => 'Documentos';

  @override
  String get documentsBody =>
      'Documentos oficiales europeos e internacionales, en tu idioma cuando existen, si no en inglés. Algunos ya están en la app, los demás se descargan del sitio oficial.';

  @override
  String get torchTitle => 'Linterna y SOS';

  @override
  String get torchSubtitle => 'Luz, SOS intermitente, luz de la pantalla';

  @override
  String get torchKeywords =>
      'linterna luz oscuridad sos intermitente señal noche';

  @override
  String get torchOn => 'Encender linterna';

  @override
  String get torchOff => 'Apagar linterna';

  @override
  String get torchMissing =>
      'Linterna no disponible en este dispositivo. Usa la luz de la pantalla.';

  @override
  String get sosBlinking => 'SOS intermitente';

  @override
  String get sosStop => 'Detener SOS';

  @override
  String get screenLight => 'Luz de la pantalla';

  @override
  String get sosInfo =>
      'SOS = ··· ─── ··· repetido. Señal internacional de socorro, visible de noche incluso desde lejos.';

  @override
  String get tapToClose => 'Toca para cerrar';

  @override
  String get morseTitle => 'Morse';

  @override
  String get morseSubtitle => 'Transmite un mensaje con la luz';

  @override
  String get morseKeywords => 'morse código señal luz mensaje';

  @override
  String get morseMessage => 'Mensaje';

  @override
  String get useTorchToo => 'Usar también la linterna';

  @override
  String get repeat => 'Repetir';

  @override
  String morseSpeed(int ms) {
    return 'Velocidad: punto = $ms ms';
  }

  @override
  String get transmit => 'Transmitir';

  @override
  String get stop => 'Detener';

  @override
  String get morseTable => 'Tabla';

  @override
  String get compassTitle => 'Brújula';

  @override
  String get compassSubtitle => 'Dirección y puntos cardinales';

  @override
  String get compassKeywords => 'brújula norte dirección orientación';

  @override
  String get compassUnavailable => 'Brújula no disponible en este dispositivo.';

  @override
  String get compassWaiting => 'Esperando al sensor…';

  @override
  String get compassHint =>
      'Mantén el móvil en horizontal, lejos de metales e imanes. Si la dirección es rara, mueve el móvil dibujando un 8.';

  @override
  String get cardinals => 'N,NE,E,SE,S,SO,O,NO';

  @override
  String get locationTitle => 'Ubicación y mapas';

  @override
  String get locationSubtitle =>
      'Coordenadas GPS para los servicios de emergencia y mapas sin conexión';

  @override
  String get locationKeywords =>
      'ubicación posición gps coordenadas dónde estoy mapa utm mgrs mapas sin conexión descargar';

  @override
  String get locServiceOff =>
      'La ubicación está desactivada. Actívala en los ajustes del móvil: el GPS funciona también en modo avión.';

  @override
  String get locDenied =>
      'Permiso de ubicación denegado. Puedes concederlo en los ajustes del móvil.';

  @override
  String get locUnavailable => 'Ubicación no disponible en este dispositivo.';

  @override
  String gpsError(String error) {
    return 'Error de GPS: $error';
  }

  @override
  String get searchingSats =>
      'Buscando satélites… Al aire libre es más rápido.';

  @override
  String get fmtDecimal => 'Decimal';

  @override
  String get fmtDms => 'Grados, minutos, segundos';

  @override
  String get fmtMgrs => 'MGRS (militares, rescate)';

  @override
  String get altitude => 'Altitud';

  @override
  String get accuracy => 'Precisión';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Copiado';

  @override
  String locHint(String number) {
    return 'Al teléfono con el $number, dicta las coordenadas decimales. El recorrido solo se graba con esta pantalla abierta.';
  }

  @override
  String get westLetter => 'O';

  @override
  String get suppliesTitle => 'Provisiones';

  @override
  String get suppliesSubtitle =>
      'Lo que tienes, lo que falta y cuánto: casa y mochila';

  @override
  String get suppliesKeywords =>
      'reservas agua comida raciones cuánto cálculo provisiones mochila casa inventario';

  @override
  String get people => 'Personas';

  @override
  String get days => 'Días';

  @override
  String get suppliesNote =>
      'La UE recomienda al menos 72 horas de autonomía; mejor si es más. El cálculo usa 4 litros de agua por persona y día (3 para beber, 1 para cocinar y lavarse) y 2000 kcal. Son valores orientativos para adultos: el calor, el esfuerzo, los niños y las personas mayores cambian las necesidades. Consume primero las provisiones más antiguas.';

  @override
  String get falloutTitle => 'Lluvia radiactiva';

  @override
  String get falloutSubtitle =>
      'Temporizador tras una explosión: qué hacer y cuándo';

  @override
  String get falloutKeywords =>
      'fallout lluvia radiactiva radiación dosímetro nuclear 7 10 decaimiento';

  @override
  String get measuredRate => 'Intensidad medida';

  @override
  String falloutDose(String dose) {
    return 'Si te quedas al aire libre 24 horas: unos $dose. Dentro, en el centro de un edificio sólido o en un sótano, es mucho menos.';
  }

  @override
  String get resetChecklistQ => '¿Reiniciar la lista?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Reiniciar';

  @override
  String doneOf(int done, int total) {
    return '$done de $total';
  }

  @override
  String get encyclopedias => 'Enciclopedias sin conexión';

  @override
  String get noEncyclopedias =>
      'No hay ninguna enciclopedia en el móvil. Descárgala mientras tengas internet: luego funciona también sin conexión.';

  @override
  String get iosImportHint =>
      'Archivos muy grandes: descárgalos en el ordenador desde download.kiwix.org y cópialos con el Finder o la app Archivos en la carpeta Refuge › zim. Luego toca ↻.';

  @override
  String get deleteFromDevice => 'Eliminar del móvil';

  @override
  String deleteQ(String title) {
    return '¿Eliminar «$title»?';
  }

  @override
  String deleteBody(String size) {
    return 'Liberarás $size. Para recuperarla tendrás que descargarla de nuevo.';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get dlWaiting => 'En espera (requiere Wi-Fi si lo has elegido)…';

  @override
  String get dlRetrying => 'Conexión perdida, reintentando…';

  @override
  String dlPaused(String pct) {
    return 'En pausa · $pct%';
  }

  @override
  String get resume => 'Reanudar';

  @override
  String get pause => 'Pausa';

  @override
  String get catalogSearchHint => 'Buscar en el catálogo de Kiwix';

  @override
  String get catalogUnreachable =>
      'No se puede acceder al catálogo. Necesitas conexión a internet.';

  @override
  String get recWikimed => 'WikiMed: enciclopedia médica (en inglés)';

  @override
  String get recWikipediaMedicine => 'Wikipedia: solo medicina';

  @override
  String get recWikipedia => 'Wikipedia completa';

  @override
  String get recWikivoyage => 'Wikivoyage: países y ciudades';

  @override
  String get recMedicalTextbooks => 'Libros de texto de medicina (en inglés)';

  @override
  String resultsFor(String query) {
    return 'Resultados de «$query»';
  }

  @override
  String get flavourMini => 'Mini, solo introducciones';

  @override
  String get flavourNopic => 'Sin imágenes';

  @override
  String get flavourMaxi => 'Con imágenes';

  @override
  String get flavourFull => 'Completa';

  @override
  String get zimitUnsupported =>
      'Sitio web archivado: formato aún no compatible';

  @override
  String get download => 'Descargar';

  @override
  String downloadQ(String size) {
    return '¿Descargar $size?';
  }

  @override
  String get downloadBody =>
      'Comprueba que tienes suficiente espacio libre. La descarga sigue aunque cierres la app y se reanuda donde se quedó.';

  @override
  String get wifiOnly => 'Solo con Wi-Fi';

  @override
  String get externalLink => 'Enlace externo: no disponible sin conexión.';

  @override
  String get mainPage => 'Página principal';

  @override
  String get searchByTitle => 'Buscar por título';

  @override
  String get searchByTitleTip =>
      'Escribe el principio del título de un artículo.';

  @override
  String get searchDocument => 'Buscar en el documento (en inglés)';

  @override
  String pagesN(int n) {
    return '$n páginas';
  }

  @override
  String get license => 'Licencia';

  @override
  String get reproducedInFull =>
      'Documento reproducido íntegramente, sin cambios.';

  @override
  String get notAvailable => 'No disponible en esta versión.';

  @override
  String entryMissing(String title) {
    return 'Artículo «$title» no encontrado: descarga WikiMed desde Manuales y guías para leerlo sin conexión.';
  }

  @override
  String get catWater => 'Agua';

  @override
  String get catFood => 'Comida';

  @override
  String get catGas => 'Gas para cocinar';

  @override
  String coversDays(String days) {
    return 'Alcanza para $days días';
  }

  @override
  String missingWater(String liters, int bottles) {
    return 'Faltan $liters L ≈ $bottles botellas de 1,5 L';
  }

  @override
  String missingFood(String kcal, String kg) {
    return 'Faltan $kcal kcal ≈ $kg kg de pasta o arroz';
  }

  @override
  String missingGas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartuchos',
      one: '1 cartucho',
    );
    return 'Faltan $_temp0 de 220 g';
  }

  @override
  String mealsHave(int have, int need) {
    return '$have / $need comidas calientes';
  }

  @override
  String get addItem => 'Añadir';

  @override
  String get addOne => 'Añadir uno';

  @override
  String get consumeOne => 'Quitar uno';

  @override
  String get itemName => 'Nombre';

  @override
  String get unitSize => 'Contenido de un envase';

  @override
  String get kcalPer100 => 'kcal por cada 100 g';

  @override
  String get quantity => 'Cantidad';

  @override
  String get save => 'Guardar';

  @override
  String get chooseProduct => '¿Qué quieres añadir?';

  @override
  String get chooseSize => 'Formato';

  @override
  String get otherSize => 'Otro formato';

  @override
  String get addToInventory => 'Añadir al inventario';

  @override
  String get pWaterBottle => 'Botella de agua';

  @override
  String get pWaterTank => 'Garrafa de agua';

  @override
  String get pPasta => 'Pasta';

  @override
  String get pRice => 'Arroz';

  @override
  String get pDryLegumes => 'Legumbres secas';

  @override
  String get pCannedLegumes => 'Legumbres en lata';

  @override
  String get pTuna => 'Atún en lata';

  @override
  String get pCannedMeat => 'Carne en lata';

  @override
  String get pCannedVeg => 'Verduras en lata';

  @override
  String get pNuts => 'Frutos secos';

  @override
  String get pBiscuits => 'Galletas, crackers';

  @override
  String get pBars => 'Barritas';

  @override
  String get pUhtMilk => 'Leche UHT';

  @override
  String get pPowderMilk => 'Leche en polvo';

  @override
  String get pOil => 'Aceite';

  @override
  String get pSugar => 'Azúcar';

  @override
  String get pHoney => 'Miel';

  @override
  String get pCustomFood => 'Otra comida';

  @override
  String get pCartridge => 'Cartucho de gas';

  @override
  String get pCustomOther => 'Otro objeto';

  @override
  String get falloutStartIntro =>
      'Si ha habido una explosión nuclear, inicia el temporizador: te dice cuánto tiempo quedarte a cubierto, qué hacer y qué ponerte en cada momento.';

  @override
  String get falloutStartNow => 'Explosión ahora: iniciar';

  @override
  String get falloutStartAt => 'Fijar la hora de la explosión';

  @override
  String get falloutResetQ => '¿Reiniciar el temporizador?';

  @override
  String falloutSince(String time) {
    return 'Explosión: $time';
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
  String get falloutMax => 'Radiación al máximo: es el momento más peligroso.';

  @override
  String falloutRemaining(String pct) {
    return 'Radiación: en torno al $pct de la que había 1 hora después de la explosión.';
  }

  @override
  String falloutNextPhase(String left, String time) {
    return 'Siguiente fase en $left (a las $time)';
  }

  @override
  String get whatToWear => 'Si tienes que salir';

  @override
  String get whatToDoNow => 'Qué hacer ahora';

  @override
  String get falloutTimeline => 'Fases';

  @override
  String get doNotGoOut => 'No salgas';

  @override
  String get falloutBannerOut =>
      'Sal solo si es necesario, cubierto de pies a cabeza';

  @override
  String get wearMask => 'Mascarilla FFP2/FFP3';

  @override
  String get wearGloves => 'Guantes';

  @override
  String get wearCovered => 'Gorro, manga larga, impermeable';

  @override
  String get wearBoots => 'Zapatos cerrados o botas';

  @override
  String get phase0Title => 'Peligro máximo: ponte a cubierto ya';

  @override
  String get phase0a =>
      'Entra en el edificio más sólido que tengas cerca y ve al centro o al sótano.';

  @override
  String get phase0b =>
      'Cierra puertas y ventanas, apaga la ventilación y el aire acondicionado.';

  @override
  String get phase0c =>
      'Si estabas fuera: quítate la ropa, ciérrala en una bolsa y lávate.';

  @override
  String get phase0d => 'No salgas por ningún motivo.';

  @override
  String get phase1Title => 'Quédate a cubierto';

  @override
  String get phase1a =>
      'La radiación baja rápido: a las 7 horas es más o menos una décima parte.';

  @override
  String get phase1b =>
      'Quédate dentro, lejos de las paredes exteriores y del tejado.';

  @override
  String get phase1c => 'Escucha la radio, la TV y las alertas en el móvil.';

  @override
  String get phase1d =>
      'Bebe y come solo de envases cerrados. Sal solo si el refugio corre peligro (incendio, derrumbe).';

  @override
  String get phase2Title => 'Sal solo si es imprescindible';

  @override
  String get phase2a =>
      'Sigue a las autoridades: pueden indicar que te desplaces o evacúes.';

  @override
  String get phase2b => 'Salidas muy breves, cubierto de la cabeza a los pies.';

  @override
  String get phase2c =>
      'Al volver, quítate la ropa exterior antes de entrar y lávate.';

  @override
  String get phase3Title => 'Peligro en descenso';

  @override
  String get phase3a =>
      'A los 2 días la radiación es más o menos una centésima parte de la inicial.';

  @override
  String get phase3b =>
      'Salidas breves si es necesario, con protección. Evita el polvo.';

  @override
  String get phase3c =>
      'No comas alimentos que hayan estado al aire libre y usa agua de recipientes cerrados.';

  @override
  String get phase4Title => 'Peligro muy reducido';

  @override
  String get phase4a =>
      'A las 2 semanas la radiación es más o menos una milésima parte de la inicial.';

  @override
  String get phase4b => 'Sigue a las autoridades para volver a la normalidad.';

  @override
  String get phase4c => 'Mantén las precauciones con la comida y el agua.';

  @override
  String get falloutDisclaimer =>
      'Indicaciones generales basadas en la regla del 7-10. Cuándo salir lo deciden las autoridades y las mediciones reales con un dosímetro.';

  @override
  String get haveDosimeter => '¿Tienes un dosímetro?';

  @override
  String inHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n horas',
      one: '1 hora',
    );
    return 'Dentro de $_temp0';
  }

  @override
  String get levelFlat => 'En horizontal';

  @override
  String get levelAlmost => 'Casi en horizontal';

  @override
  String get levelTilted => 'Pon el móvil en horizontal';

  @override
  String tiltDegrees(int n) {
    return 'Inclinación $n°';
  }

  @override
  String get mapsTitle => 'Mapas sin conexión';

  @override
  String get onbMapTitle => 'Mapa sin conexión';

  @override
  String get onbMapBody =>
      'Elige qué mapas guardar en el móvil. Funcionan sin internet, con tu posición GPS.';

  @override
  String get mapWorld => 'Mundo';

  @override
  String get mapWorldBody =>
      'Todos los países, las ciudades principales y las grandes carreteras.';

  @override
  String get mapEurope => 'Europa';

  @override
  String get mapEuropeBody =>
      'Ciudades, pueblos y carreteras principales de toda Europa.';

  @override
  String mapCountry(String name) {
    return '$name en detalle';
  }

  @override
  String get mapCountryBody =>
      'Todas las carreteras, calles y senderos, hasta cada edificio.';

  @override
  String get mapKeepOpen =>
      'Mantén la app abierta hasta que termine la descarga.';

  @override
  String get mapDownloadSelected => 'Descargar los mapas elegidos';

  @override
  String get mapReady => 'Descargado';

  @override
  String get mapFailed => 'La descarga ha fallado. Inténtalo de nuevo.';

  @override
  String mapDownloading(String pct, String size) {
    return '$pct % de $size';
  }

  @override
  String get mapPreparing => 'Preparando…';

  @override
  String get mapSizeCalc => 'Calculando el tamaño…';

  @override
  String get mapSizeUnknown => 'Tamaño no disponible (hace falta internet)';

  @override
  String get mapNone =>
      'No hay mapas sin conexión. Descarga uno para ver dónde estás incluso sin internet.';

  @override
  String get mapDownloadButton => 'Descargar mapas';

  @override
  String get mapSkip => 'Saltar, lo haré más tarde';

  @override
  String get zoomIn => 'Acercar';

  @override
  String get zoomOut => 'Alejar';

  @override
  String get wholeWorld => 'Todo el mundo';

  @override
  String get myPosition => 'Mi posición';

  @override
  String downloadsActive(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n descargas en curso',
      one: 'Descarga en curso',
    );
    return '$_temp0';
  }

  @override
  String get mapsOnPhone => 'En el móvil';

  @override
  String get mapsInProgress => 'En curso';

  @override
  String get mapsAvailable => 'Disponibles';

  @override
  String get mapUpdate => 'Actualizar a la última versión';

  @override
  String mapUpdatedOn(String date) {
    return 'del $date';
  }

  @override
  String get mapsMoreBody =>
      'Descarga, actualiza o elimina mapas del mundo, de Europa y de los países';

  @override
  String get emptySection => 'Nada todavía. Toca «Añadir».';

  @override
  String get catElectricity => 'Electricidad';

  @override
  String chargesHave(int have, int need) {
    return '$have / $need cargas';
  }

  @override
  String missingCharges(int n, int pb) {
    return 'Faltan $n cargas del móvil ≈ $pb baterías externas de 10.000 mAh';
  }

  @override
  String get electricityBasis =>
      'Cálculo: 1 carga completa del móvil por persona y día. Baterías externas al 65 % y estaciones de energía al 85 % de la capacidad indicada.';

  @override
  String get pPowerBank => 'Batería externa';

  @override
  String get pPowerStation => 'Estación de energía';

  @override
  String get pSolarPanel => 'Panel solar';

  @override
  String get pBatteriesAA => 'Pilas AA';

  @override
  String get pBatteriesAAA => 'Pilas AAA';

  @override
  String get radioTitle => 'Radio en emergencias';

  @override
  String get radioSubtitle => 'Qué escuchar y en qué frecuencias';

  @override
  String get radioKeywords =>
      'radio frecuencia fm am dab onda media noticias autoridades walkie talkie pmr';

  @override
  String get radioListen => 'Qué escuchar';

  @override
  String get radioListenBody =>
      'Estas emisoras transmiten los mensajes oficiales de las autoridades durante una emergencia.';

  @override
  String get radioFm => 'FM en las ciudades principales';

  @override
  String get radioAm => 'Onda media y larga (AM)';

  @override
  String get radioAmNote =>
      'De noche, la onda media y la larga llegan mucho más lejos.';

  @override
  String get radioDab => 'Radio digital DAB+';

  @override
  String get radioNationwide => 'En todo el país';

  @override
  String get radioNoData => 'Todavía no hay datos verificados para este país.';

  @override
  String get radioNotFound => 'Si no encuentras la emisora';

  @override
  String get radioTip1 =>
      'Haz una búsqueda automática en toda la banda FM y luego en AM.';

  @override
  String get radioTip2 =>
      'Acércate a una ventana o sube de piso, y extiende del todo la antena.';

  @override
  String get radioTip3 =>
      'Las frecuencias FM cambian según la zona: las de aquí son de las ciudades principales.';

  @override
  String get radioTip4 =>
      'Escucha a horas fijas, al principio de cada hora, para ahorrar pilas.';

  @override
  String get radioWhich => 'Qué radio tener en casa';

  @override
  String get radioWhich1 =>
      'Una radio de manivela o a pilas con FM, onda media (AM) y, si es posible, DAB+ y onda corta.';

  @override
  String get radioWhich2 =>
      'Pilas de repuesto del mismo tamaño, guardadas aparte.';

  @override
  String get radioWhich3 =>
      'Funciona aunque el móvil esté descargado y no haya red.';

  @override
  String get pmrTitle => 'Walkie-talkies PMR446';

  @override
  String get pmrBody =>
      'Sin licencia en toda Europa (0,5 W, normalmente 1-3 km). Acordad un canal en familia.';

  @override
  String pmrChannel(int n) {
    return 'Can. $n';
  }

  @override
  String get radioOpsec =>
      'Recibir es seguro: quien escucha no emite señal. Transmitir se puede detectar: en zona de guerra, habla poco, breve y solo si hace falta.';

  @override
  String radioChecked(String date) {
    return 'Datos comprobados en fuentes oficiales el $date.';
  }

  @override
  String radioFinder(String name) {
    return 'Busca la frecuencia de tu zona (en línea): $name';
  }

  @override
  String get docDownloadFailed =>
      'La descarga ha fallado. Comprueba la conexión y vuelve a intentarlo.';

  @override
  String docDownloading(String pct) {
    return 'Descargando… $pct %';
  }

  @override
  String docToDownload(String size) {
    return 'Para descargar · $size';
  }

  @override
  String get docNotDownloaded =>
      'Descarga primero el documento desde Manuales y guías.';

  @override
  String get planTitle => 'Plan de emergencia familiar';

  @override
  String get planSubtitle =>
      'Contactos, puntos de encuentro, quién ayuda a quién';

  @override
  String get planIntro =>
      'Poneos de acuerdo antes, todos juntos: en una emergencia el teléfono e internet pueden no funcionar.';

  @override
  String get planContacts => 'Contactos de emergencia';

  @override
  String get planContactsHint =>
      'Nombre y teléfono de 2–3 personas, también una fuera de la ciudad';

  @override
  String get planMeetNear => 'Punto de encuentro cerca de casa';

  @override
  String get planMeetNearHint => 'P. ej. delante de la farmacia de la esquina';

  @override
  String get planMeetFar => 'Punto de encuentro fuera del barrio';

  @override
  String get planMeetFarHint => 'Por si no se puede volver a casa';

  @override
  String get planShelter => 'Refugio o punto de encuentro más cercano';

  @override
  String get planShelterHint => 'El que indica el ayuntamiento';

  @override
  String get planChildren => 'Quién recoge a los niños';

  @override
  String get planChildrenHint =>
      'Colegio, guardería, y quién los recoge si tú no puedes';

  @override
  String get planHelp => 'Quién necesita ayuda';

  @override
  String get planHelpHint =>
      'Personas mayores, con discapacidad, mascotas: quién les ayuda y cómo';

  @override
  String get planHealth => 'Medicinas e información médica';

  @override
  String get planHealthHint => 'Medicamentos, alergias, dispositivos médicos';

  @override
  String get planNotes => 'Otras notas';

  @override
  String get planCopy => 'Copiar el plan';

  @override
  String get planCopied => 'Plan copiado: pégalo en un mensaje o imprímelo.';

  @override
  String get planPaper =>
      'Escribe también el plan en papel y guárdalo con las provisiones. Dáselo a tus contactos de emergencia.';

  @override
  String docDownloadAll(int n, String size) {
    return 'Descargar todos ($n · $size)';
  }

  @override
  String docDownloadingAll(int n) {
    return 'Descargando… faltan $n';
  }

  @override
  String get civilProtectionGuides => 'Guías de Protección Civil';

  @override
  String get civilProtectionGuidesBody =>
      'Qué hacer antes, durante y después: terremoto, inundación, incendios forestales, accidente industrial, tsunami, emergencia nuclear y presas. Textos de la Protección Civil italiana, traducidos y válidos en toda Europa.';

  @override
  String get libraryKeywords =>
      'biblioteca documentos manuales pdf enciclopedia wikipedia wikimed guías protección civil leer manuales guías consultar';

  @override
  String get manageMaps => 'Mapas';

  @override
  String get addPoint => 'Añadir punto';

  @override
  String get savedPoints => 'Puntos guardados';

  @override
  String get recordTrack => 'Recorrido';

  @override
  String get pointName => 'Nombre';

  @override
  String get pointNameHint => 'P. ej. casa, punto de encuentro';

  @override
  String get pointDefaultName => 'Punto';

  @override
  String get coordinates => 'Coordenadas';

  @override
  String get coordinatesHelp =>
      'Decimales (45.4642, 9.1900) o grados, minutos y segundos (45°27\'51\"N 9°11\'24\"E). También puedes mantener pulsado sobre el mapa.';

  @override
  String get coordsInvalid => 'Coordenadas no válidas';

  @override
  String get useMyPosition => 'Usar mi ubicación';

  @override
  String get pointsEmpty =>
      'No hay puntos guardados. Añade uno con coordenadas o mantén pulsado sobre el mapa.';

  @override
  String get clearTrack => 'Borrar';

  @override
  String trackLength(String dist) {
    return 'Recorrido grabado: $dist';
  }

  @override
  String distanceTo(String dist, String dir, int deg) {
    return '$dist en línea recta · hacia $dir ($deg°)';
  }

  @override
  String get onbContentTitle => 'Manuales y enciclopedias';

  @override
  String get onbContentBody =>
      'Elige qué guardar en el móvil para consultarlo sin internet. Las fichas de emergencia y las guías de Protección Civil ya están incluidas.';

  @override
  String get onbPackDocs => 'Documentos oficiales europeos';

  @override
  String get onbPackDocsBody =>
      'Primeros auxilios (ERC, OMS) y guías de preparación de gobiernos europeos. En tu idioma cuando existen.';

  @override
  String get onbPackMedicine => 'Wikipedia: medicina';

  @override
  String get onbPackMedicineBody =>
      'Los artículos de medicina de Wikipedia: enfermedades, síntomas, medicamentos, anatomía.';

  @override
  String onbDownloadSelected(String size) {
    return 'Descargar la selección ($size)';
  }

  @override
  String get trackTitle => 'Recorrido';

  @override
  String get trackHelp =>
      'Toca «Recorrido» para grabar el camino que haces: aparece como una línea azul en el mapa. Sirve para encontrar el camino de vuelta (a casa, al coche, a un refugio) o para mostrar a los servicios de emergencia por dónde has pasado. Solo se graba con esta pantalla abierta; toca otra vez para parar.';

  @override
  String get trackShow => 'Toca para verlo en el mapa';

  @override
  String get pointsAndTrack => 'Puntos y recorrido';

  @override
  String get suppliesHome => 'Casa';

  @override
  String get suppliesBackpack => 'Mochila';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterMissing => 'Lo que falta';

  @override
  String get suppliesQuantities => 'Las cantidades';

  @override
  String get suppliesQuantitiesHint =>
      'Cuánto tienes en comparación con lo que hace falta. Toca una línea para ver y actualizar lo que tienes.';

  @override
  String get quantitiesEnough => 'Las cantidades bastan.';

  @override
  String get suppliesHaveTitle => 'Para tener';

  @override
  String get suppliesHaveHint =>
      'Cosas que tienes o no tienes: marca las que tienes. Los elementos siguen las directrices de la UE y de las protecciones civiles europeas.';

  @override
  String get inBag => 'en la mochila';

  @override
  String get inBagChange =>
      'Está en la mochila: cámbialo en la pestaña Mochila.';

  @override
  String get addOwnItem => 'Añadir un elemento';

  @override
  String get bagLegend =>
      'Para cada cosa elige si ya está en la mochila, si la coges de casa al salir o si falta. La mochila sirve si tienes que salir de casa deprisa.';

  @override
  String get beforeLeaving => 'Antes de salir, coge';

  @override
  String get beforeLeavingAlways => 'Llaves, móvil y cartera';

  @override
  String bagReady(int done, int total) {
    return '$done de $total listas';
  }

  @override
  String get bagCheckTitle => 'Revisa la mochila cada 6 meses';

  @override
  String bagCheckBody(String date) {
    return 'La comida, las medicinas y las pilas caducan. Última revisión: $date';
  }

  @override
  String get bagCheckNever => 'nunca';

  @override
  String get bagCheckDone => 'Hecho hoy';

  @override
  String get bagNoPowerBank =>
      'En casa no hay: añádela en Casa › Electricidad.';

  @override
  String get bagPacked => 'En la mochila';

  @override
  String get bagFromHome => 'De casa, al salir';

  @override
  String get bagMissing => 'Falta';

  @override
  String get attributionsTitle => 'Licencias y atribuciones';

  @override
  String get attributionsSubtitle =>
      'De dónde vienen los contenidos y con qué licencia';

  @override
  String get attributionsBody =>
      'Las fichas están escritas con nuestras palabras a partir de las fuentes oficiales de abajo; los documentos y guías originales siguen siendo de sus autores. Cada ficha indica sus fuentes, frase por frase, en el archivo docs/verifica-schede.md del proyecto.';

  @override
  String get attributionsApp => 'Código de la app y textos de las fichas';

  @override
  String get softwareLicenses => 'Licencias de las bibliotecas de software';

  @override
  String get paperTitle => 'Copia en papel';

  @override
  String get paperSubtitle =>
      'Números, radio, plan familiar, mochila y fichas, en un PDF para imprimir';

  @override
  String get paperIntro =>
      'Imprímela y guárdala con las provisiones y en la mochila: sirve cuando el móvil está sin batería o roto. Actualízala cuando cambie algo.';

  @override
  String get paperNumbers => 'Números y alertas';

  @override
  String get paperBagKey => '[x] listo · [   ] falta';

  @override
  String get paperSources =>
      'Fuentes: ERC 2025, IFRC 2025, directrices de la UE, protecciones civiles nacionales, OMS. Lista completa en la app: Más › Licencias y atribuciones. No sustituye a un curso de primeros auxilios ni a las indicaciones de las autoridades.';

  @override
  String get paperFileName => 'copia-en-papel';

  @override
  String get bagCheckReminder =>
      'Revisa la comida, las medicinas y las pilas de la mochila: algunas cosas pueden haber caducado.';

  @override
  String get hospitalsButton => 'Hospitales';

  @override
  String get hospitalsTitle => 'Hospitales cercanos';

  @override
  String hospitalsNote(String number) {
    return 'Del mapa sin conexión (OpenStreetMap), con la distancia en línea recta. En una emergencia llama siempre al $number: te dirán adónde ir.';
  }

  @override
  String get hospitalsNeedMap =>
      'Para buscar hospitales hace falta el mapa detallado de tu país: descárgalo desde Mapas.';

  @override
  String get hospitalsNone =>
      'Ningún hospital en el mapa a menos de unos 50 km.';

  @override
  String get hospitalUnnamed => 'Hospital';

  @override
  String get hospitalsNeedGps =>
      'Hace falta la posición GPS: espera a que el móvil la encuentre y vuelve a intentarlo.';
}
