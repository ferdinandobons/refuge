#!/usr/bin/env python3
"""Importa le pagine "Cosa fare" / "Cosa sapere" del sito ufficiale "Io non rischio"
(Dipartimento della Protezione Civile) nel formato delle guide di Refuge.

I testi sono riprodotti integralmente, senza modifiche, con licenza CC BY 4.0
e con la dicitura di attribuzione richiesta dal sito (pagina "Note legali").

Uso:  python3 -I tool/import_iononrischio.py
"""

import datetime
import html
import json
import pathlib
import re
import urllib.request
from html.parser import HTMLParser

SITE = "https://iononrischio.protezionecivile.gov.it"
ATTRIBUTION = "Fonte: Io non rischio. Dipartimento della Protezione Civile-Presidenza del Consiglio dei Ministri"
LICENSE = "Licenza CC BY 4.0 (creativecommons.org/licenses/by/4.0). Testo riprodotto integralmente"
OUT = pathlib.Path(__file__).resolve().parent.parent / "assets" / "guides"

# slug -> (categoria nell'app, urgenza "cosa fare")
RISKS = {
    "nucleare": ("Rischio nucleare", "alta"),
    "industriale": ("Rischio chimico e industriale", "alta"),
    "terremoto": ("Terremoto", "alta"),
    "alluvione": ("Alluvione", "alta"),
    "maremoto": ("Maremoto", "alta"),
    "incendi-boschivi": ("Incendi", "alta"),
    "grandi-dighe": ("Dighe", "media"),
    "vulcani/vesuvio": ("Vulcani", "media"),
    "vulcani/campi-flegrei": ("Vulcani", "media"),
    "vulcani/stromboli": ("Vulcani", "media"),
    "vulcani/vulcano": ("Vulcani", "media"),
}


class _Converter(HTMLParser):
    """HTML del sito -> righe nel formato delle guide (paragrafi, '- ', '1. ', '### ', **grassetto**)."""

    def __init__(self):
        super().__init__()
        self.lines, self.buf, self.lists = [], [], []
        self.in_p = self.italic_only = False
        self.saw_plain = False
        self.em = 0

    def _flush(self, kind="p"):
        text = re.sub(r"\s+", " ", "".join(self.buf).replace("\xa0", " ")).strip()
        text = re.sub(r"\*\*\s*\*\*", "", text)
        self.buf = []
        if not text or text == "**":
            return
        if kind == "li":
            if self.lists and self.lists[-1][0] == "ol":
                self.lists[-1][1] += 1
                self.lines.append(f"{self.lists[-1][1]}. {text}")
            else:
                self.lines.append(f"- {text}")
        elif kind == "h" or (self.italic_only and not self.saw_plain):
            self.lines.append(f"### {text.strip('*').strip()}")
        elif text.startswith("•"):
            self.lines.append(f"- {text.lstrip('• ').strip()}")
        else:
            self.lines.append(text)
        self.lines.append("")
        self.saw_plain = False

    def handle_starttag(self, tag, attrs):
        if tag in ("p", "h2", "h3", "h4", "div"):
            self._flush()
            self.in_p, self.italic_only, self.saw_plain = True, False, False
        elif tag in ("ul", "ol"):
            self._flush()
            self.lists.append([tag, 0])
        elif tag == "li":
            self._flush()
        elif tag == "br":
            self._flush("li" if self._in_li() else "p")
        elif tag in ("strong", "b"):
            self.buf.append("**")
        elif tag in ("em", "i"):
            self.em += 1
            if not "".join(self.buf).strip():
                self.italic_only = True

    def handle_endtag(self, tag):
        if tag in ("strong", "b"):
            self.buf.append("**")
        elif tag in ("em", "i"):
            self.em -= 1
        elif tag == "li":
            self._flush("li")
        elif tag in ("ul", "ol"):
            self._flush("li")
            if self.lists:
                self.lists.pop()
        elif tag in ("h2", "h3", "h4"):
            self._flush("h")
        elif tag in ("p", "div"):
            self._flush()

    def handle_data(self, data):
        if data.strip() and self.em == 0:
            self.saw_plain = True
        self.buf.append(data)

    def _in_li(self):
        return bool(self.lists)

    def close(self):
        super().close()
        self._flush()
        return self.lines


def html_to_lines(fragment):
    c = _Converter()
    c.feed(html.unescape(fragment or ""))
    return c.close()


def fetch(path):
    url = f"{SITE}/page-data/it/preparati/{path}/page-data.json"
    req = urllib.request.Request(url, headers={"User-Agent": "Refuge-importer (open source)"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)["result"]["data"]["node"]


def build(slug, kind, category, urgency):
    node = fetch(f"{slug}/{kind}")
    lines = html_to_lines(node.get("body", {}).get("processed"))
    for acc in node.get("relationships", {}).get("field_accordion") or []:
        title = (acc.get("field_titolo") or "").strip()
        if title:
            lines += [f"## {title}", ""]
        lines += html_to_lines((acc.get("field_testo") or {}).get("processed"))

    words = sum(len(l.split()) for l in lines)
    today = datetime.date.today().isoformat()
    page_url = f"{SITE}/it/preparati/{slug}/{kind}/"
    front = [
        "---",
        f"title: {node['title'].strip()}",
        f"category: {category}",
        f"urgency: {urgency if kind == 'cosa-fare' else 'bassa'}",
        f"minutes: {max(1, round(words / 180))}",
        f"order: {0 if kind == 'cosa-fare' else 50}",
        "status: ufficiale",
        f"sources: {ATTRIBUTION} | {page_url} | {LICENSE}, scaricato il {today}",
        "---",
    ]
    text = "\n".join(front + lines).rstrip() + "\n"
    name = f"pc-{slug.replace('/', '-')}-{kind}.md"
    (OUT / name).write_text(text, encoding="utf-8")
    print(f"{name}: {words} parole")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for slug, (category, urgency) in RISKS.items():
        kinds = ["cosa-fare"] if slug.startswith("vulcani/") else ["cosa-fare", "cosa-sapere"]
        for kind in kinds:
            try:
                build(slug, kind, category, urgency)
            except Exception as e:  # una pagina mancante non blocca le altre
                print(f"ERRORE {slug}/{kind}: {e}")


if __name__ == "__main__":
    main()
