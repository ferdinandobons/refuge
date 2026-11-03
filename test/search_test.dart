import 'package:flutter_test/flutter_test.dart';
import 'package:rifugio/features/search/search_index.dart';

void main() {
  final index = [
    Indexed('bleeding', title: 'Sangue che esce forte', keywords: 'emorragia ferita laccio emostatico'),
    Indexed('burns', title: 'Ustione', keywords: 'bruciatura scottatura'),
    Indexed('cpr', title: 'Non risponde e non respira', keywords: 'rianimazione massaggio cardiaco'),
    Indexed('heat', title: 'Hitzschlag', keywords: 'hitze überhitzung'),
    Indexed('torch', title: 'Torcia e SOS', keywords: 'luce buio', priority: 1),
  ];

  test('normalizzazione', () {
    expect(normalize('Überhitzung, ÉTOUFFEMENT!'), 'uberhitzung etouffement');
  });

  test('parole intere, sinonimi e parole incomplete', () {
    expect(search(index, 'sangue').first, 'bleeding');
    expect(search(index, 'emorragia').first, 'bleeding');
    expect(search(index, 'emorr').first, 'bleeding');
    expect(search(index, 'massaggio cardiaco').first, 'cpr');
    expect(search(index, 'luce').first, 'torch');
  });

  test('errori di battitura e accenti mancanti', () {
    expect(search(index, 'emoragia').first, 'bleeding');
    expect(search(index, 'ustone').first, 'burns');
    expect(search(index, 'uberhitzung').first, 'heat');
  });

  test('nessun risultato per parole estranee', () {
    expect(search(index, 'astronave'), isEmpty);
    expect(search(index, ''), isEmpty);
  });
}
