"""Immagini per l'App Store (1320×2868): titolo e sottotitolo sopra, schermata dell'app sotto.
Uso: python store_shots.py <cartella_schermate> <lingua> <uscita>
"""
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

SRC, LANG, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
FONTS = os.path.expanduser('~/development/flutter/bin/cache/artifacts/material_fonts')
W, H = 1320, 2868
INK, AMBER, TEXT, MUTED = (13, 13, 13), (255, 179, 0), (242, 235, 221), (168, 159, 145)

CAPTIONS = {
    'en': [
        ('What to do,', 'step by step', 'Even without internet'),
        ('Clear', 'first aid', 'From official European guidelines'),
        ('See how', 'prepared you are', 'Plan, supplies, backpack, maps'),
        ('Water and food', 'for your family', 'How much you need, how much you have'),
        ('Your position,', 'without signal', 'Coordinates for rescuers, offline maps'),
        ('Which radio', 'to listen to', 'Official stations for your country'),
    ],
    'it': [
        ('Cosa fare,', 'passo per passo', 'Anche senza internet'),
        ('Primo soccorso', 'chiaro', 'Dalle linee guida ufficiali europee'),
        ('Guarda quanto', 'sei pronto', 'Piano, scorte, zaino, mappe'),
        ('Acqua e cibo', 'per la famiglia', 'Quanto serve e quanto ne hai'),
        ('La tua posizione,', 'senza campo', 'Coordinate per i soccorsi, mappe offline'),
        ('Quale radio', 'ascoltare', 'Le emittenti ufficiali del tuo paese'),
    ],
}
FILES = ['1-emergency', '2-card', '3-prepare', '4-supplies', '5-location', '6-radio']


def font(name, size):
    return ImageFont.truetype(os.path.join(FONTS, f'Roboto-{name}.ttf'), size)


def fit(d, text, name, size, width):
    while d.textlength(text, font=font(name, size)) > width and size > 40:
        size -= 4
    return font(name, size)


os.makedirs(OUT, exist_ok=True)
for i, (f, (l1, l2, sub)) in enumerate(zip(FILES, CAPTIONS[LANG]), 1):
    img = Image.new('RGBA', (W, H), INK + (255,))
    glow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(glow).ellipse((160, 900, 1160, 2300), fill=AMBER + (55,))
    img.alpha_composite(glow.filter(ImageFilter.GaussianBlur(220)))
    d = ImageDraw.Draw(img)
    big1 = fit(d, l1, 'Black', 128, W - 160)
    big2 = fit(d, l2, 'Black', 128, W - 160)
    d.text((W // 2, 300), l1, font=big1, fill=(255, 255, 255), anchor='ms')
    d.text((W // 2, 440), l2, font=big2, fill=AMBER, anchor='ms')
    d.text((W // 2, 545), sub, font=fit(d, sub, 'Medium', 56, W - 160), fill=MUTED, anchor='ms')

    # Schermata con angoli arrotondati e cornice scura, che esce dal fondo.
    shot = Image.open(os.path.join(SRC, f'{f}.png')).convert('RGB')
    sw = 1080
    shot = shot.resize((sw, round(shot.height * sw / shot.width)), Image.LANCZOS)
    r = 120
    mask = Image.new('L', shot.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, shot.width - 1, shot.height - 1), r, fill=255)
    pad = 26
    top = 680
    d.rounded_rectangle(((W - sw) // 2 - pad, top - pad, (W + sw) // 2 + pad, top + shot.height + pad), r + pad,
                        fill=(30, 30, 30), outline=(70, 70, 70), width=4)
    img.paste(shot, ((W - sw) // 2, top), mask)
    img.convert('RGB').save(os.path.join(OUT, f'{i:02d}.png'), optimize=True)
print(OUT)
