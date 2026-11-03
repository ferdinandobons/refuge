"""Catalogo delle cose da avere (casa) e da tenere nello zaino, con fonti.

Uso: python3 tool/supplies/checklist.py assets/supplies/checklist.json

Ogni voce: id stabile (le spunte non dipendono dalla lingua),
testo in 5 lingue, fonte; le voci dello zaino possono rimandare a una voce di casa ("home")
o a un prodotto dell'inventario ("homePreset").
"""
import json, sys

EU = 'EU SWD(2026) 826, 72-hour self-sufficiency'
DV = 'Denk vooruit (NL) 2025, p. 11'
MCF16 = 'MCF (SE) In case of crisis or war 2026, p. 16'
MCF18 = 'MCF (SE) 2026, p. 18'
MCF19 = 'MCF (SE) 2026, p. 19 (evacuation)'
MCF15 = 'MCF (SE) 2026, p. 15'
MCF17 = 'MCF (SE) 2026, p. 17'
BBK22, BBK23, BBK25, BBK26 = ('BBK (DE) 2025, p. 22', 'BBK (DE) 2025, p. 23', 'BBK (DE) 2025, p. 25', 'BBK (DE) 2025, p. 26')
BBK32, BBK33, BBK34, BBK35 = ('BBK (DE) 2025, checklist p. 32', 'BBK (DE) 2025, medicine cabinet p. 33',
                              'BBK (DE) 2025, emergency bags p. 34', 'BBK (DE) 2025, checklist p. 35')
IFRC = 'IFRC Guidelines 2025'
WHO = 'WHO Boil water 2015 (chemical disinfection)'
PC = 'Protezione Civile, rischio industriale: cosa fare'
EU828 = 'EU SWD(2026) 828, disability-inclusive preparedness'

def g(gid, it, en, fr, de, es, items):
    return {'group': gid, 'name': dict(it=it, en=en, fr=fr, de=de, es=es), 'items': items}

def i(iid, src, it, en, fr, de, es, **extra):
    return {'id': iid, 'src': src, 'it': it, 'en': en, 'fr': fr, 'de': de, 'es': es, **extra}

home = [
 g('health', 'Salute e igiene', 'Health and hygiene', 'Santé et hygiène', 'Gesundheit und Hygiene', 'Salud e higiene', [
  i('firstAidKit', f'{EU}; {DV}; {BBK33}', 'Kit di primo soccorso con istruzioni', 'First aid kit with instructions', 'Trousse de premiers secours avec mode d\'emploi', 'Erste-Hilfe-Set mit Anleitung', 'Botiquín de primeros auxilios con instrucciones'),
  i('medicines', f'{EU}; {BBK33}', 'Farmaci che prendi abitualmente', 'Medicines you take regularly', 'Médicaments que vous prenez habituellement', 'Medikamente, die Sie regelmäßig nehmen', 'Medicamentos que tomas habitualmente'),
  i('painkillers', BBK33, 'Antidolorifici e antifebbrili', 'Painkillers and fever reducers', 'Antidouleurs et antipyrétiques', 'Schmerz- und fiebersenkende Mittel', 'Analgésicos y antitérmicos'),
  i('thermometer', BBK33, 'Termometro', 'Thermometer', 'Thermomètre', 'Fieberthermometer', 'Termómetro'),
  i('electrolytes', BBK33, 'Sali reidratanti e farmaci per diarrea e nausea', 'Oral rehydration salts and remedies for diarrhoea and nausea', 'Sels de réhydratation et médicaments contre la diarrhée et les nausées', 'Elektrolyte und Mittel gegen Durchfall und Übelkeit', 'Sales de rehidratación y medicamentos para la diarrea y las náuseas'),
  i('dressings', BBK33, 'Disinfettante, cerotti, garze e bende', 'Disinfectant, plasters, gauze and bandages', 'Désinfectant, pansements, compresses et bandes', 'Desinfektionsmittel, Pflaster, Kompressen und Binden', 'Desinfectante, tiritas, gasas y vendas'),
  i('tourniquet', f'{IFRC} (trauma first aid equipment)', 'Laccio emostatico', 'Tourniquet', 'Garrot', 'Tourniquet', 'Torniquete'),
  i('gloves', BBK33, 'Guanti monouso', 'Disposable gloves', 'Gants jetables', 'Einmalhandschuhe', 'Guantes desechables'),
  i('spareGlasses', f'{BBK34}; {EU828}', 'Occhiali di ricambio e ausili che usi ogni giorno', 'Spare glasses and aids you use every day', 'Lunettes de rechange et aides utilisées chaque jour', 'Ersatzbrille und Hilfsmittel, die Sie täglich brauchen', 'Gafas de repuesto y ayudas que usas cada día'),
  i('masks', BBK35, 'Mascherine FFP2', 'FFP2 masks', 'Masques FFP2', 'FFP2-Masken', 'Mascarillas FFP2'),
  i('purification', WHO, 'Pastiglie potabilizzanti', 'Water purification tablets', 'Pastilles de purification de l\'eau', 'Wasserentkeimungstabletten', 'Pastillas potabilizadoras'),
  i('soap', f'{BBK35}; {DV}', 'Sapone e disinfettante', 'Soap and disinfectant', 'Savon et désinfectant', 'Seife und Desinfektionsmittel', 'Jabón y desinfectante'),
  i('toothpaste', f'{BBK35}; {DV}', 'Spazzolini e dentifricio', 'Toothbrushes and toothpaste', 'Brosses à dents et dentifrice', 'Zahnbürsten und Zahnpasta', 'Cepillos de dientes y pasta de dientes'),
  i('toiletPaper', f'{BBK35}; {DV}', 'Carta igienica e salviette umidificate', 'Toilet paper and wet wipes', 'Papier toilette et lingettes', 'Toilettenpapier und Feuchttücher', 'Papel higiénico y toallitas húmedas'),
  i('sanitary', f'{BBK35}; {DV}', 'Assorbenti e pannolini, se servono', 'Sanitary pads and nappies, if needed', 'Protections hygiéniques et couches, si besoin', 'Binden und Windeln, falls nötig', 'Compresas y pañales, si hacen falta'),
 ]),
 g('toilet', 'Bagno senz\'acqua', 'Toilet without water', 'Toilettes sans eau', 'Toilette ohne Wasser', 'Váter sin agua', [
  i('binBags', f'{MCF18}; {BBK35}', 'Sacchi della spazzatura robusti', 'Strong rubbish bags', 'Sacs-poubelle résistants', 'Reißfeste Müllbeutel', 'Bolsas de basura resistentes'),
  i('bucket', MCF18, 'Secchio con coperchio', 'Bucket with a lid', 'Seau avec couvercle', 'Eimer mit Deckel', 'Cubo con tapa'),
  i('litter', MCF18, 'Lettiera o segatura', 'Cat litter or sawdust', 'Litière ou sciure', 'Katzenstreu oder Sägemehl', 'Arena para gatos o serrín'),
 ]),
 g('light', 'Luce, radio e telefono', 'Light, radio and phone', 'Éclairage, radio et téléphone', 'Licht, Radio und Telefon', 'Luz, radio y teléfono', [
  i('torch', f'{BBK32}; {DV}', 'Torcia o lampada frontale', 'Torch or headlamp', 'Lampe torche ou frontale', 'Taschen- oder Stirnlampe', 'Linterna o frontal'),
  i('spareBatteries', f'{BBK32}; {MCF16}', 'Batterie di ricambio', 'Spare batteries', 'Piles de rechange', 'Ersatzbatterien', 'Pilas de repuesto'),
  i('radio', f'{EU}; {BBK32}; {MCF16}', 'Radio a pile, a manovella o solare', 'Battery, wind-up or solar radio', 'Radio à piles, à manivelle ou solaire', 'Batterie-, Kurbel- oder Solarradio', 'Radio de pilas, de manivela o solar'),
  i('candles', f'{BBK32}; {DV}', 'Candele e accendino o fiammiferi', 'Candles and a lighter or matches', 'Bougies et briquet ou allumettes', 'Kerzen und Feuerzeug oder Streichhölzer', 'Velas y mechero o cerillas'),
  i('carCharger', MCF16, 'Caricatore da auto per il telefono', 'Car charger for the phone', 'Chargeur de voiture pour le téléphone', 'Kfz-Ladekabel für das Handy', 'Cargador de coche para el móvil'),
  i('warningApp', BBK32, 'Allerte di emergenza attive sul telefono', 'Emergency alerts switched on on the phone', 'Alertes d\'urgence activées sur le téléphone', 'Warnungen auf dem Handy eingeschaltet', 'Alertas de emergencia activadas en el móvil'),
 ]),
 g('heat', 'Caldo e freddo', 'Heat and cold', 'Chaud et froid', 'Wärme und Kälte', 'Calor y frío', [
  i('blankets', f'{BBK32}; {DV}', 'Coperte o sacco a pelo per ogni persona', 'Blankets or a sleeping bag for each person', 'Couvertures ou sac de couchage pour chaque personne', 'Decken oder Schlafsack für jede Person', 'Mantas o saco de dormir para cada persona'),
  i('warmClothes', f'{MCF16}; {BBK32}', 'Vestiti caldi per ogni persona: lana, calze pesanti, cappello, guanti', 'Warm clothes for each person: wool, thick socks, hat, gloves', 'Vêtements chauds pour chaque personne : laine, chaussettes épaisses, bonnet, gants', 'Warme Kleidung für jede Person: Wolle, dicke Socken, Mütze, Handschuhe', 'Ropa de abrigo para cada persona: lana, calcetines gruesos, gorro, guantes'),
  i('heater', f'{BBK23}; {BBK32}', 'Stufa per l\'interno che funziona senza corrente, con il combustibile', 'Indoor heater that works without power, with its fuel', 'Chauffage d\'intérieur qui fonctionne sans courant, avec son combustible', 'Netzunabhängiges Heizgerät für Innenräume, mit Brennstoff', 'Estufa para interior que funciona sin luz, con su combustible'),
  i('foilBlanket', f'{IFRC}, hypothermia p. 461 (reflective material)', 'Telo termico', 'Foil blanket', 'Couverture de survie', 'Rettungsdecke', 'Manta térmica'),
 ]),
 g('kitchen', 'Cucina e acqua', 'Kitchen and water', 'Cuisine et eau', 'Küche und Wasser', 'Cocina y agua', [
  i('stove', f'{BBK22}; {BBK32}', 'Fornello da campeggio o barbecue a gas, da usare solo all\'aperto', 'Camping stove or gas barbecue, for outdoor use only', 'Réchaud de camping ou barbecue à gaz, à utiliser uniquement dehors', 'Campingkocher oder Gasgrill, nur im Freien benutzen', 'Hornillo de camping o barbacoa de gas, solo para usar al aire libre'),
  i('tinOpener', BBK34, 'Apriscatole', 'Tin opener', 'Ouvre-boîte', 'Dosenöffner', 'Abrelatas'),
  i('waterContainers', f'{MCF15}; {BBK35}', 'Taniche o secchi con coperchio per l\'acqua', 'Water containers or buckets with lids', 'Jerricans ou seaux avec couvercle pour l\'eau', 'Wasserkanister oder Eimer mit Deckel', 'Garrafas o cubos con tapa para el agua'),
  i('petFood', f'{BBK32}; {DV}', 'Cibo per gli animali, se ne hai', 'Pet food, if you have pets', 'Nourriture pour les animaux, si vous en avez', 'Tierfutter, falls Sie Haustiere haben', 'Comida para mascotas, si tienes'),
 ]),
 g('docs', 'Soldi e documenti', 'Money and documents', 'Argent et papiers', 'Geld und Dokumente', 'Dinero y documentos', [
  i('cash', f'{EU}; {DV}; {MCF17}', 'Contanti in banconote piccole e monete', 'Cash in small notes and coins', 'Espèces en petites coupures et pièces', 'Bargeld in kleinen Scheinen und Münzen', 'Efectivo en billetes pequeños y monedas'),
  i('docCopies', DV, 'Copie dei documenti d\'identità', 'Copies of identity documents', 'Copies des pièces d\'identité', 'Kopien der Ausweisdokumente', 'Copias de los documentos de identidad'),
  i('phoneList', f'{BBK32}; {DV}', 'Numeri importanti scritti su carta', 'Important phone numbers written on paper', 'Numéros importants notés sur papier', 'Wichtige Telefonnummern auf Papier', 'Números importantes escritos en papel'),
  i('paperMap', DV, 'Mappa cartacea della zona', 'Paper map of your area', 'Carte papier de votre secteur', 'Papierkarte Ihrer Umgebung', 'Mapa en papel de tu zona'),
  i('spareKeys', DV, 'Chiavi di riserva di casa e auto', 'Spare house and car keys', 'Clés de rechange de la maison et de la voiture', 'Ersatzschlüssel für Haus und Auto', 'Llaves de repuesto de casa y coche'),
  i('familyPlan', f'{EU}; Denk vooruit (NL) 2025, p. 12', 'Piano di emergenza della famiglia, anche su carta', 'Family emergency plan, also on paper', 'Plan d\'urgence familial, aussi sur papier', 'Notfallplan der Familie, auch auf Papier', 'Plan de emergencia familiar, también en papel'),
 ]),
 g('safety', 'Casa e sicurezza', 'Home and safety', 'Maison et sécurité', 'Haus und Sicherheit', 'Casa y seguridad', [
  i('extinguisher', f'{BBK35}; {MCF16}', 'Estintore', 'Fire extinguisher', 'Extincteur', 'Feuerlöscher', 'Extintor'),
  i('smokeDetector', BBK35, 'Rilevatori di fumo', 'Smoke alarms', 'Détecteurs de fumée', 'Rauchmelder', 'Detectores de humo'),
  i('coDetector', BBK22, 'Rilevatore di monossido di carbonio', 'Carbon monoxide detector', 'Détecteur de monoxyde de carbone', 'Kohlenmonoxid-Melder', 'Detector de monóxido de carbono'),
  i('whistle', DV, 'Fischietto per farti trovare', 'Whistle to help rescuers find you', 'Sifflet pour vous faire repérer', 'Trillerpfeife, damit man Sie findet', 'Silbato para que te encuentren'),
  i('tools', DV, 'Attrezzi: martello, sega, tronchesi', 'Tools: hammer, saw, wire cutters', 'Outils : marteau, scie, pince coupante', 'Werkzeug: Hammer, Säge, Seitenschneider', 'Herramientas: martillo, sierra, alicates de corte'),
  i('tape', PC, 'Nastro adesivo e teli di plastica, per sigillare una stanza', 'Tape and plastic sheeting, to seal a room', 'Ruban adhésif et bâches en plastique, pour calfeutrer une pièce', 'Klebeband und Plastikfolie, um einen Raum abzudichten', 'Cinta adhesiva y láminas de plástico, para sellar una habitación'),
  i('helmet', BBK35, 'Casco di protezione', 'Safety helmet', 'Casque de protection', 'Schutzhelm', 'Casco de protección'),
 ]),
]

bag = [
 g('clothes', 'Vestiti e riparo', 'Clothes and shelter', 'Vêtements et abri', 'Kleidung und Schutz', 'Ropa y abrigo', [
  i('bagClothes', f'{BBK34}; {MCF19}', 'Vestiti caldi, impermeabile e scarpe robuste, per ogni persona', 'Warm clothes, rain gear and sturdy shoes, for each person', 'Vêtements chauds, imperméable et chaussures solides, pour chaque personne', 'Warme Kleidung, Regenschutz und feste Schuhe, für jede Person', 'Ropa de abrigo, impermeable y calzado resistente, para cada persona', home='warmClothes'),
  i('bagChange', f'{BBK34}; {MCF19}', 'Un cambio di vestiti per ogni persona', 'A change of clothes for each person', 'Des vêtements de rechange pour chaque personne', 'Wechselkleidung für jede Person', 'Una muda de ropa para cada persona'),
  i('bagSleeping', BBK34, 'Sacco a pelo o coperta per ogni persona', 'Sleeping bag or blanket for each person', 'Sac de couchage ou couverture pour chaque personne', 'Schlafsack oder Decke für jede Person', 'Saco de dormir o manta para cada persona', home='blankets'),
  i('bagSun', BBK34, 'Crema solare e cappello', 'Sun cream and a hat', 'Crème solaire et chapeau', 'Sonnencreme und Kopfbedeckung', 'Crema solar y gorra'),
  i('bagGloves', BBK34, 'Guanti da lavoro', 'Work gloves', 'Gants de travail', 'Arbeitshandschuhe', 'Guantes de trabajo'),
 ]),
 g('health', 'Salute e igiene', 'Health and hygiene', 'Santé et hygiène', 'Gesundheit und Hygiene', 'Salud e higiene', [
  i('bagFirstAid', BBK34, 'Materiale di primo soccorso', 'First aid supplies', 'Matériel de premiers secours', 'Erste-Hilfe-Material', 'Material de primeros auxilios', home='firstAidKit'),
  i('bagMedicines', f'{BBK34}; {MCF19}', 'Farmaci personali', 'Personal medicines', 'Médicaments personnels', 'Persönliche Medikamente', 'Medicamentos personales', home='medicines'),
  i('bagToiletries', f'{BBK34}; {MCF19}', 'Prodotti per l\'igiene personale', 'Toiletries', 'Produits d\'hygiène personnelle', 'Hygieneartikel', 'Productos de higiene personal'),
  i('bagGlasses', f'{BBK34}; {MCF19}', 'Occhiali o apparecchi acustici di ricambio', 'Spare glasses or hearing aids', 'Lunettes ou appareils auditifs de rechange', 'Ersatzbrille oder Ersatz-Hörgeräte', 'Gafas o audífonos de repuesto', home='spareGlasses'),
 ]),
 g('food', 'Cibo e acqua', 'Food and water', 'Nourriture et eau', 'Essen und Wasser', 'Comida y agua', [
  i('bagFood', f'{BBK34}; {MCF19}', 'Cibo a lunga conservazione per qualche giorno', 'Long-life food for a few days', 'Nourriture de longue conservation pour quelques jours', 'Haltbare Lebensmittel für einige Tage', 'Comida de larga duración para unos días'),
  i('bagBottle', BBK34, 'Borraccia riempibile per ogni persona', 'Refillable water bottle for each person', 'Gourde réutilisable pour chaque personne', 'Nachfüllbare Trinkflasche für jede Person', 'Botella rellenable para cada persona'),
  i('bagTableware', BBK34, 'Posate e stoviglie', 'Cutlery and tableware', 'Couverts et vaisselle', 'Besteck und Geschirr', 'Cubiertos y vajilla'),
  i('bagKnife', BBK34, 'Coltellino e apriscatole', 'Pocket knife and tin opener', 'Couteau de poche et ouvre-boîte', 'Taschenmesser und Dosenöffner', 'Navaja y abrelatas', home='tinOpener'),
 ]),
 g('light', 'Luce, radio e telefono', 'Light, radio and phone', 'Éclairage, radio et téléphone', 'Licht, Radio und Telefon', 'Luz, radio y teléfono', [
  i('bagTorch', BBK34, 'Torcia', 'Torch', 'Lampe torche', 'Taschenlampe', 'Linterna', home='torch'),
  i('bagRadio', f'{BBK34}; {MCF19}', 'Radio a pile, solare o a manovella', 'Battery, solar or wind-up radio', 'Radio à piles, solaire ou à manivelle', 'Batterie-, Solar- oder Kurbelradio', 'Radio de pilas, solar o de manivela', home='radio'),
  i('bagPowerBank', BBK34, 'Power bank carico', 'Charged power bank', 'Batterie externe chargée', 'Geladene Powerbank', 'Batería externa cargada', homePreset='powerBank'),
  i('bagPhone', MCF19, 'Telefono e caricatore', 'Phone and charger', 'Téléphone et chargeur', 'Handy und Ladegerät', 'Móvil y cargador'),
  i('bagLighter', BBK34, 'Accendino o fiammiferi', 'Lighter or matches', 'Briquet ou allumettes', 'Feuerzeug oder Streichhölzer', 'Mechero o cerillas', home='candles'),
 ]),
 g('docs', 'Documenti e soldi', 'Documents and money', 'Papiers et argent', 'Dokumente und Geld', 'Documentos y dinero', [
  i('bagDocs', f'{BBK34}; {BBK25}; {MCF19}', 'Cartellina con i documenti importanti', 'Folder with important documents', 'Pochette avec les papiers importants', 'Mappe mit wichtigen Dokumenten', 'Carpeta con los documentos importantes', home='docCopies'),
  i('bagCash', f'{BBK34}; {MCF19}; {EU}', 'Contanti', 'Cash', 'Espèces', 'Bargeld', 'Efectivo', home='cash'),
  i('bagPhoneList', MCF19, 'Numeri e informazioni importanti scritti su carta', 'Important numbers and information written on paper', 'Numéros et informations importants notés sur papier', 'Wichtige Nummern und Informationen auf Papier', 'Números e información importantes escritos en papel', home='phoneList'),
  i('bagMap', MCF19, 'Mappa e bussola', 'Map and compass', 'Carte et boussole', 'Karte und Kompass', 'Mapa y brújula', home='paperMap'),
  i('bagNotepad', BBK34, 'Blocco e penna', 'Notepad and pen', 'Bloc-notes et stylo', 'Notizblock und Stift', 'Libreta y bolígrafo'),
 ]),
]

out = {
    'sources': {
        'beforeLeaving': f'{BBK26} (keys, mobile phone and wallet to hand)',
        'bagCheck': 'Denk vooruit (NL) 2025, p. 10 (check your emergency kit every six months)',
    },
    'home': home,
    'bag': bag,
}
json.dump(out, open(sys.argv[1], 'w'), ensure_ascii=False, indent=1)
print(sum(len(x['items']) for x in home), 'home items;', sum(len(x['items']) for x in bag), 'bag items')
