#!/usr/bin/env python3
"""Compone le guide di primo soccorso con ESTRATTI FEDELI di Wikipedia in italiano (licenza CC BY-SA 4.0).

Il testo delle sezioni scelte è riprodotto senza modifiche (tolti solo note, tabelle e immagini);
ogni estratto è seguito dalla sua citazione. In fondo a ogni guida ci sono i rimandi alle pagine dei
manuali ufficiali inclusi nell'app e alle guide della Protezione Civile sullo stesso argomento.

Uso:  python3 -I tool/import_wikipedia_it.py
"""

import datetime
import html
import json
import pathlib
import re
import sys
import urllib.parse
import urllib.request

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from import_iononrischio import _Converter  # noqa: E402

API = "https://it.wikipedia.org/w/api.php"
UA = {"User-Agent": "Refuge/0.1 (app open source di sopravvivenza offline; 1bonsegnaferdinando@gmail.com)"}
OUT = pathlib.Path(__file__).resolve().parent.parent / "assets" / "guides"

ATP = "us-army-atp-4-02-11-first-aid-2026.pdf"
IFRC = "ifrc-first-aid-guidelines-2020.pdf"
SURV = "us-army-atp-3-50-21-survival-2018.pdf"

# Ogni guida: estratti (voce, sezioni; "" = introduzione della voce; "*" dopo il nome = solo il testo prima delle sottosezioni),
# rimandi ("doc:file#pagina", "guide:id", "zim:titolo da cercare") e, dove Wikipedia contraddice i manuali ufficiali,
# "official": citazioni LETTERALI dai PDF inclusi (verificate a mano sul testo del PDF), mostrate in cima alla guida.
GUIDES = [
    {
        "id": "fa-emorragia",
        "title": "Emorragia e laccio emostatico",
        "urgency": "alta",
        "order": 1,
        "excerpts": [
            ("Emorragia", ["Primo soccorso"]),
            ("Laccio emostatico", ["Utilizzo", "Indicazioni", "Laccio emostatico di emergenza"]),
        ],
        "official": [
            (f"doc:{ATP}#62", "Additionally, TQs should never be removed except by medical personnel at a higher role of care.",
             "ATP 4-02.11, esercito USA (2026), pag. 62"),
            (f"doc:{IFRC}#188", "In both cases, the release of the tourniquet should only be considered under the guidance "
             "of a medical professional.", "Linee guida IFRC (2020), pag. 188"),
        ],
        "links": [
            (f"doc:{ATP}#61", "ATP 4-02.11 (esercito USA) – Medicazione compressiva e laccio, pag. 61"),
            (f"doc:{IFRC}#187", "Linee guida IFRC – Emorragie esterne e laccio emostatico, pag. 187"),
            ("zim:Bleeding", "WikiMed – voce «Bleeding» (se scaricata)"),
        ],
    },
    {
        "id": "fa-rcp",
        "title": "Rianimazione cardiopolmonare (RCP) e defibrillatore",
        "urgency": "alta",
        "order": 2,
        "excerpts": [
            ("Rianimazione cardiopolmonare", ["", "Procedura", "Termine della procedura"]),
            ("Defibrillatore semiautomatico", ["Utilizzo"]),
        ],
        "links": [
            (f"doc:{IFRC}#134", "Linee guida IFRC – Compressioni toraciche e RCP, pag. 134"),
            (f"doc:{ATP}#33", "ATP 4-02.11 (esercito USA) – Rianimazione, pag. 33"),
            ("guide:fa-posizione-laterale", "Posizione laterale di sicurezza"),
            ("zim:Cardiopulmonary resuscitation", "WikiMed – voce «Cardiopulmonary resuscitation»"),
        ],
    },
    {
        "id": "fa-soffocamento",
        "title": "Soffocamento e manovra di Heimlich",
        "urgency": "alta",
        "order": 3,
        "excerpts": [
            ("Manovra di Heimlich", ["Segni di soffocamento", "Esecuzione", "Dopo aver liberato le vie aeree",
                                     "Esecuzione della manovra su neonati"]),
        ],
        "links": [
            (f"doc:{IFRC}#170", "Linee guida IFRC – Soffocamento, pag. 170"),
            (f"doc:{ATP}#81", "ATP 4-02.11 (esercito USA) – Compressioni addominali, pag. 81"),
            ("guide:fa-rcp", "Rianimazione cardiopolmonare, se la persona perde coscienza"),
        ],
    },
    {
        "id": "fa-posizione-laterale",
        "title": "Posizione laterale di sicurezza",
        "urgency": "alta",
        "order": 4,
        "excerpts": [("Posizione laterale di sicurezza", ["", "Scopo", "Esecuzione"])],
        "links": [
            (f"doc:{IFRC}#128", "Linee guida IFRC – Posizione di recupero, pag. 128"),
            (f"doc:{ATP}#74", "ATP 4-02.11 (esercito USA) – Posizione di recupero, pag. 74"),
        ],
    },
    {
        "id": "fa-ustioni",
        "title": "Ustioni",
        "urgency": "alta",
        "order": 5,
        "excerpts": [("Ustione", ["", "Gravità", "Trattamento*", "Cura delle ferite"])],
        "links": [
            (f"doc:{IFRC}#213", "Linee guida IFRC – Ustioni, pag. 213"),
            (f"doc:{ATP}#129", "ATP 4-02.11 (esercito USA) – Ustioni, pag. 129"),
            ("zim:Burn", "WikiMed – voce «Burn»"),
        ],
    },
    {
        "id": "fa-ferite",
        "title": "Ferite",
        "urgency": "media",
        "order": 6,
        "excerpts": [("Ferita", ["", "Terapia"])],
        "links": [
            (f"doc:{IFRC}#202", "Linee guida IFRC – Ferite, pag. 202"),
            (f"doc:{ATP}#65", "ATP 4-02.11 (esercito USA) – Medicazioni, pag. 65"),
            ("guide:fa-emorragia", "Emorragia e laccio emostatico"),
        ],
    },
    {
        "id": "fa-ipotermia",
        "title": "Ipotermia e congelamento",
        "urgency": "alta",
        "order": 7,
        "excerpts": [
            ("Ipotermia", ["Quadro clinico", "Trattamento"]),
            ("Congelamento (medicina)", ["Primo soccorso"]),
        ],
        "links": [
            (f"doc:{IFRC}#343", "Linee guida IFRC – Ipotermia, pag. 343"),
            (f"doc:{IFRC}#349", "Linee guida IFRC – Congelamento, pag. 349"),
            (f"doc:{ATP}#103", "ATP 4-02.11 (esercito USA) – Ipotermia, pag. 103"),
            (f"doc:{SURV}#51", "ATP 3-50.21 Survival – Freddo, pag. 51"),
        ],
    },
    {
        "id": "fa-colpo-di-calore",
        "title": "Colpo di calore",
        "urgency": "alta",
        "order": 8,
        "excerpts": [("Ipertermia", ["", "Segni e sintomi", "Trattamento", "Prevenzione"])],
        "official": [
            (f"doc:{IFRC}#332", "In the case of an adult experiencing hyperthermia due to intense physical activity, the first "
             "aid provider should consider immersing the person from the neck down in cold water (1-26° C/[…]) until a core "
             "body temperature of less than 39°C (102.2°F) is reached.", "Linee guida IFRC (2020), pag. 332"),
            (f"doc:{ATP}#190", "You can immerse the person in a tub of cold water, use ice cooling sheets or apply cold "
             "water to their body using wet towels or sponges.", "ATP 4-02.11, esercito USA (2026), pag. 190"),
        ],
        "links": [
            (f"doc:{IFRC}#335", "Linee guida IFRC – Colpo di calore da sforzo, pag. 335"),
            (f"doc:{ATP}#188", "ATP 4-02.11 (esercito USA) – Colpo di calore, pag. 188"),
            (f"doc:{SURV}#49", "ATP 3-50.21 Survival – Caldo, pag. 49"),
        ],
    },
    {
        "id": "fa-annegamento",
        "title": "Annegamento",
        "urgency": "alta",
        "order": 9,
        "excerpts": [("Annegamento", ["", "Tecniche di primo soccorso"])],
        "links": [
            (f"doc:{IFRC}#412", "Linee guida IFRC – Annegamento, pag. 412"),
            ("guide:fa-rcp", "Rianimazione cardiopolmonare"),
            ("guide:pc-maremoto-cosa-fare", "Protezione Civile – Cosa fare in caso di maremoto"),
            ("guide:pc-alluvione-cosa-fare", "Protezione Civile – Cosa fare in caso di alluvione"),
        ],
    },
    {
        "id": "fa-disidratazione",
        "title": "Disidratazione e soluzione reidratante",
        "urgency": "media",
        "order": 10,
        "excerpts": [
            ("Disidratazione", ["", "Manifestazioni cliniche"]),
            ("Soluzione reidratante orale", ["", "Composizione"]),
        ],
        "links": [
            (f"doc:{IFRC}#338", "Linee guida IFRC – Disidratazione e reidratazione orale, pag. 338"),
            (f"doc:{SURV}#57", "ATP 3-50.21 Survival – Acqua, pag. 57"),
            ("zim:Oral rehydration therapy", "WikiMed – voce «Oral rehydration therapy»"),
        ],
    },
    {
        "id": "fa-avvelenamento",
        "title": "Avvelenamento e intossicazione",
        "urgency": "alta",
        "order": 11,
        "excerpts": [("Avvelenamento", ["", "Per via di ingresso"])],
        "links": [
            (f"doc:{IFRC}#258", "Linee guida IFRC – Avvelenamento, pag. 258"),
            ("guide:pc-industriale-cosa-fare", "Protezione Civile – Cosa fare in caso di incidente industriale"),
        ],
    },
]


class _WikiConverter(_Converter):
    """Come il convertitore della Protezione Civile, ma salta note, tabelle, immagini e titoli di sezione."""

    SKIP_TAGS = {"table", "sup", "figure", "style", "script", "math"}
    SKIP_CLASSES = ("thumb", "hatnote", "navbox", "noprint", "mw-editsection", "reference", "references",
                    "mw-heading", "metadata", "ambox", "infobox", "sinottico", "toc", "gallery", "mw-empty-elt")

    def __init__(self):
        super().__init__()
        self.skip = 0
        self.stack = []

    def handle_starttag(self, tag, attrs):
        if tag in ("br", "img", "hr", "wbr", "link", "meta"):
            if not self.skip and tag == "br":
                super().handle_starttag(tag, attrs)
            return
        cls = dict(attrs).get("class") or ""
        skip = tag in self.SKIP_TAGS or any(c in cls.split() for c in self.SKIP_CLASSES)
        self.stack.append(skip)
        if skip:
            self.skip += 1
        elif not self.skip:
            super().handle_starttag("p" if tag == "dd" else tag, attrs)

    def handle_endtag(self, tag):
        if tag in ("br", "img", "hr", "wbr", "link", "meta") or not self.stack:
            return
        skip = self.stack.pop()
        if skip:
            self.skip -= 1
        elif not self.skip:
            super().handle_endtag("p" if tag == "dd" else tag)

    def handle_data(self, data):
        if not self.skip:
            super().handle_data(data)


def api(**params):
    q = urllib.parse.urlencode({**params, "format": "json", "redirects": 1})
    with urllib.request.urlopen(urllib.request.Request(f"{API}?{q}", headers=UA), timeout=30) as r:
        d = json.load(r)
    if "error" in d:
        raise RuntimeError(d["error"]["info"])
    return d["parse"]


def section_lines(page, revid, index, intro_only):
    text = api(action="parse", oldid=revid, section=index, prop="text", disableeditsection=1,
               disabletoc=1)["text"]["*"]
    if intro_only:
        # Tiene solo il testo prima della prima sottosezione.
        heads = [m.start() for m in re.finditer(r'<div class="mw-heading', text)]
        if len(heads) > 1:
            text = text[: heads[1]]
    c = _WikiConverter()
    c.feed(html.unescape(text))
    lines = c.close()
    # Togli i rimandi del tipo "[1]" rimasti e le righe vuote doppie.
    lines = [re.sub(r"\[\d+\]|\[senza fonte\]|\[citazione necessaria\]", "", l).rstrip() for l in lines]
    return [l for i, l in enumerate(lines) if l or (i and lines[i - 1])]


def build(g):
    today = datetime.date.today().isoformat()
    body, sources = [], []
    if g.get("official"):
        body += ["## Attenzione: cosa dicono i manuali ufficiali", ""]
        body += [f"@@ {target} | {quote} | {source}" for target, quote, source in g["official"]] + [""]
    for page, wanted in g["excerpts"]:
        meta = api(action="parse", page=page, prop="sections|revid")
        title, revid = meta["title"], meta["revid"]
        index = {s["line"]: s["index"] for s in meta["sections"]}
        url = f"https://it.wikipedia.org/w/index.php?oldid={revid}"
        sources.append(f"Wikipedia, voce «{title}» (revisione {revid}, {today}), testo degli autori di Wikipedia, "
                       f"licenza CC BY-SA 4.0 – {url}")
        for want in wanted:
            intro_only = want.endswith("*")
            name = want.rstrip("*")
            if name and name not in index:
                print(f"  ! sezione mancante: {title} › {name}")
                continue
            lines = section_lines(page, revid, index.get(name, 0), intro_only)
            if not any(lines):
                continue
            body += [f"## {title}" if not name else f"## {title}: {name.lower()}", ""] + lines
            body += [f"^^ Da Wikipedia, voce «{title}»{'' if not name else f', sezione «{name}»'} · CC BY-SA 4.0", ""]
    body += ["## Approfondisci nei documenti ufficiali", ""]
    body += [f"=> {target} | {label}" for target, label in g["links"]]
    words = sum(len(l.split()) for l in body)
    front = [
        "---",
        f"title: {g['title']}",
        "category: Primo soccorso",
        f"urgency: {g['urgency']}",
        f"minutes: {max(1, round(words / 180))}",
        f"order: {g['order']}",
        "status: estratti",
        "sources: " + " | ".join(sources),
        "---",
    ]
    (OUT / f"{g['id']}.md").write_text("\n".join(front + body).rstrip() + "\n", encoding="utf-8")
    print(f"{g['id']}.md: {words} parole")


def main():
    for g in GUIDES:
        try:
            build(g)
        except Exception as e:  # una voce mancante non blocca le altre
            print(f"ERRORE {g['id']}: {e}")


if __name__ == "__main__":
    main()
