import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/countries.dart';
import '../../l10n/app_localizations.dart';
import '../emergency/cards.dart';
import '../tools/radio.dart';
import 'family_plan_screen.dart';
import 'inventory.dart';
import 'prepare_screen.dart' show serviceName;
import 'supply_checklist.dart';

/// Copia su carta: numeri e allerte, radio, piano della famiglia (con righe vuote da completare a mano),
/// zaino e tutte le schede di emergenza, in un PDF da stampare. Il telefono si scarica o si rompe:
/// le guide UE e nazionali chiedono di tenere le informazioni importanti anche su carta.
Future<Uint8List> buildPaperCopy({required String language, required Country country, required AppLocalizations t}) async {
  final prefs = await SharedPreferences.getInstance();
  final cards = await loadCards(language, country, t);
  final radio = (await loadRadio())[country.code];
  final checklist = await SupplyChecklist.load();
  final inv = Inventory.instance;
  await inv.load();

  final base = pw.TextStyle(fontSize: 10.5, lineSpacing: 1.5);
  final small = pw.TextStyle(fontSize: 9, color: PdfColors.grey700);
  pw.Widget h1(String s) => pw.Header(level: 0, child: pw.Text(clean(s), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)));
  pw.Widget h2(String s) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8, bottom: 3),
        child: pw.Text(clean(s), style: pw.TextStyle(fontSize: 12.5, fontWeight: pw.FontWeight.bold)),
      );
  pw.Widget p(String s, {pw.TextStyle? style}) => pw.Text(clean(s), style: style ?? base);
  pw.Widget line() => pw.Container(
        height: 18,
        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.5))),
      );

  final date = DateFormat.yMd(language).format(DateTime.now());
  final doc = pw.Document(title: t.paperTitle, author: t.appTitle);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(40, 36, 40, 36),
    footer: (c) => pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(clean('${t.appTitle} · ${t.paperTitle} · $date'), style: small),
      pw.Text('${c.pageNumber} / ${c.pagesCount}', style: small),
    ]),
    build: (c) => [
      // ---- Numeri, allerte, radio ----
      h1('${t.paperTitle} · ${country.name(t)}'),
      p(t.paperIntro, style: small),
      h2(t.paperNumbers),
      p('${t.emergencyNumber}: ${country.emergency}', style: base.copyWith(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      for (final (kind, number) in country.extra) p('${serviceName(t, kind)}: $number'),
      p('${t.phoneAlerts}: ${country.alertName(t)}'),
      if (country.sirenText(t) case final siren?) p('${t.sirens}: $siren'),
      if (radio != null) ...[
        h2(t.radioTitle),
        for (final e in radio.emergency) p('- ${e.label}'),
        for (final e in radio.fm.take(12)) p('   ${e.label}: ${e.value} MHz${e.detail == null ? '' : ' (${e.detail})'}'),
        for (final e in radio.dab.take(6)) p('   DAB+ ${e.value}: ${e.label}'),
      ],

      // ---- Piano della famiglia (su una pagina sua, da appendere) ----
      pw.NewPage(),
      h1(t.planTitle),
      p(t.planIntro, style: small),
      for (final f in kPlanFields) ...[
        h2(planField(t, f).$1),
        if ((prefs.getString('plan:$f') ?? '').trim().isNotEmpty)
          p(prefs.getString('plan:$f')!.trim())
        else ...[line(), line()],
      ],

      // ---- Zaino ----
      pw.NewPage(),
      h1(t.suppliesBackpack),
      p(t.bagLegend, style: small),
      h2(t.beforeLeaving),
      for (final g in [...checklist.beforeLeaving(inv, language), t.beforeLeavingAlways]) p('- $g'),
      for (final g in checklist.bag) ...[
        h2(g.name(language)),
        for (final i in g.items) p(_bagLine(t, checklist.bagState(inv, i), i.label(language))),
        for (final o in inv.ownBag.where((o) => o.group == g.id)) p(_bagLine(t, o.bag, o.name ?? '')),
      ],
      p(t.paperBagKey, style: small),

      // ---- Schede di emergenza ----
      pw.NewPage(),
      h1(t.tabEmergency),
      for (final card in cards) ...[
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(clean(card.title), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
        ),
        for (final (i, s) in card.steps.indexed) p('${i + 1}. $s'),
        for (final n in card.never) p('${t.neverDo}: $n', style: base.copyWith(fontStyle: pw.FontStyle.italic)),
      ],
      pw.SizedBox(height: 10),
      p(t.paperSources, style: small),
    ],
  ));
  return doc.save();
}

/// "[x] voce", "[x] voce (da casa, al momento)" oppure "[  ] voce" se manca.
String _bagLine(AppLocalizations t, BagState? s, String label) => switch (s) {
      BagState.packed => '[x]  $label',
      BagState.fromHome => '[x]  $label (${t.bagFromHome.toLowerCase()})',
      null => '[   ]  $label',
    };

/// Crea il PDF e apre il pannello di condivisione (stampa, salva in File, invia).
Future<void> sharePaperCopy({required String language, required Country country, required AppLocalizations t}) async {
  final bytes = await buildPaperCopy(language: language, country: country, t: t);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${t.appTitle}-${t.paperFileName}.pdf');
  await file.writeAsBytes(bytes);
  await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'application/pdf')], title: t.paperTitle));
}

/// I caratteri standard del PDF coprono solo l'alfabeto latino di base (Latin-1): i simboli fuori
/// si sostituiscono con equivalenti leggibili, così non spariscono in stampa.
String clean(String s) {
  const map = {
    '≈': '~', '✕': 'x', '✓': 'v', '→': '->', '•': '-', '–': '-', '—': '-', '−': '-', '‘': "'", '’': "'", '‚': "'",
    '“': '"', '”': '"', '„': '"', '′': "'", '″': '"', '…': '...', '›': '>', '‹': '<', '€': 'EUR', 'Œ': 'OE', 'œ': 'oe',
  };
  final b = StringBuffer();
  for (final r in s.runes) {
    final ch = String.fromCharCode(r);
    b.write(map[ch] ?? (r < 0x100 ? ch : '?'));
  }
  return b.toString();
}
