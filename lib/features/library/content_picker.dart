import 'package:flutter/material.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'documents.dart';
import 'zim/downloads.dart';
import 'zim/kiwix_catalog.dart';
import 'zim/zim_library.dart';

/// Raccolta proposta nella configurazione iniziale.
class _Pack {
  _Pack(this.id, this.icon, this.title, this.body, {required this.selected});

  final String id, title, body;
  final IconData icon;
  bool selected;

  /// File dal catalogo Kiwix (null per i documenti o se non trovato).
  CatalogEntry? entry;
  int size = 0;
}

/// Scelta di enciclopedie e documenti da scaricare, come per le mappe: ogni voce con la sua dimensione.
class ContentPicker extends StatefulWidget {
  const ContentPicker({super.key, this.onStarted});

  /// Chiamato dopo aver avviato i download.
  final VoidCallback? onStarted;

  @override
  State<ContentPicker> createState() => _ContentPickerState();
}

class _ContentPickerState extends State<ContentPicker> {
  List<_Pack>? _packs;
  List<OfficialDocument> _docs = [];
  bool _offline = false, _wifiOnly = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_packs == null) _load(AppLocalizations.of(context));
  }

  /// Il primo file che esiste, nella lingua scelta e poi in inglese, con la variante preferita.
  static Future<CatalogEntry?> _find(List<String> names, List<String> flavours) async {
    for (final name in names) {
      final entries = (await KiwixCatalog.byName(name)).where((e) => !e.isZimit).toList();
      for (final f in flavours) {
        final e = entries.where((e) => e.flavour == f).firstOrNull;
        if (e != null) return e;
      }
      if (entries.isNotEmpty) return entries.first;
    }
    return null;
  }

  Future<void> _load(AppLocalizations t) async {
    final lang = AppSettings.instance.language;
    final names = <String>{lang, 'en'};
    final packs = [
      _Pack('docs', Icons.picture_as_pdf, t.onbPackDocs, t.onbPackDocsBody, selected: true),
      _Pack('wikimed', Icons.medical_information, t.onbPackWikimed, t.onbPackWikimedBody, selected: true),
      _Pack('medicine', Icons.local_hospital, t.onbPackMedicine, t.onbPackMedicineBody, selected: true),
      _Pack('wikivoyage', Icons.map, t.onbPackWikivoyage, t.onbPackWikivoyageBody, selected: false),
      _Pack('wikipedia', Icons.public, t.onbPackWikipedia, t.onbPackWikipediaBody, selected: false),
    ];
    setState(() => _packs = packs);
    final docs = await loadDocuments(lang);
    await DocumentFiles.instance.refresh(docs);
    _docs = docs.where((d) => !DocumentFiles.instance.isAvailable(d)).toList();
    packs[0].size = _docs.fold(0, (s, d) => s + d.size);
    try {
      final found = await Future.wait([
        _find(['mdwiki_en_all'], ['maxi', 'nopic', 'mini']),
        _find([for (final l in names) 'wikipedia_${l}_medicine'], ['maxi', 'nopic']),
        _find([for (final l in names) 'wikivoyage_${l}_all'], ['maxi', 'nopic']),
        _find([for (final l in names) 'wikipedia_${l}_all'], ['nopic', 'mini']),
      ]);
      for (final (i, e) in found.indexed) {
        packs[i + 1]
          ..entry = e
          ..size = e?.size ?? 0;
      }
    } catch (_) {
      _offline = true;
    }
    if (mounted) setState(() {});
  }

  bool _installed(_Pack p) => p.id == 'docs'
      ? _docs.isEmpty
      : p.entry != null && ZimLibrary.instance.books.any((b) => b.file.uri.pathSegments.last == p.entry!.fileName);

  bool _available(_Pack p) => p.id == 'docs' || p.entry != null;

  List<_Pack> get _chosen =>
      (_packs ?? const []).where((p) => p.selected && _available(p) && !_installed(p) && (p.id == 'docs' || !_offline)).toList();

  Future<void> _start() async {
    for (final p in _chosen) {
      if (p.id == 'docs') {
        // I documenti sono piccoli: si scaricano uno dopo l'altro mentre l'app è aperta.
        () async {
          for (final d in _docs) {
            await DocumentFiles.instance.download(d);
          }
        }();
      } else {
        await ZimDownloads.instance.start(p.entry!, wifiOnly: _wifiOnly);
      }
    }
    widget.onStarted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final packs = _packs;
    if (packs == null) return const Center(child: CircularProgressIndicator());
    final total = _chosen.fold(0, (s, p) => s + p.size);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (_offline)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(t.catalogUnreachable, style: const TextStyle(color: kDanger)),
        ),
      for (final p in packs) _tile(t, p),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(t.wifiOnly),
        value: _wifiOnly,
        onChanged: (v) => setState(() => _wifiOnly = v ?? true),
      ),
      const SizedBox(height: 8),
      FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
        icon: const Icon(Icons.download),
        label: Text(total > 0 ? t.onbDownloadSelected(formatBytes(total)) : t.mapDownloadSelected,
            style: const TextStyle(fontSize: 18)),
        onPressed: _chosen.isEmpty ? null : _start,
      ),
    ]);
  }

  Widget _tile(AppLocalizations t, _Pack p) {
    final installed = _installed(p);
    final loading = p.id != 'docs' && p.entry == null && !_offline;
    final Widget status;
    if (installed) {
      status = Text(t.mapReady, style: const TextStyle(color: Colors.lightGreen));
    } else if (loading) {
      status = Text(t.mapSizeCalc, style: const TextStyle(color: Colors.white54));
    } else if (!_available(p)) {
      status = Text(t.notAvailable, style: const TextStyle(color: Colors.white38));
    } else {
      status = Text(
        [
          if (p.entry != null) languageName(p.entry!.language),
          formatBytes(p.size),
        ].join(' · '),
        style: const TextStyle(color: Colors.white54),
      );
    }
    final enabled = !installed && _available(p) && (p.id == 'docs' || !_offline);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: CheckboxListTile(
        value: installed || (p.selected && enabled),
        onChanged: enabled ? (v) => setState(() => p.selected = v ?? false) : null,
        secondary: Icon(p.icon, color: kAccent, size: 30),
        title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.body),
          const SizedBox(height: 4),
          status,
        ]),
        isThreeLine: true,
      ),
    );
  }
}
