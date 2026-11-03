// Disegna l'icona di Refuge (tetto e croce neri su fondo ambra) in PNG 1024×1024.
// Uso: swift tool/icon/render_icon.swift <uscita.png> [--foreground]
// Con --foreground disegna solo il simbolo, su fondo trasparente, per l'icona adattiva di Android:
// lì è visibile solo la parte centrale (72 dp su 108), quindi il disegno si riduce a quella.
import AppKit

let foreground = CommandLine.arguments.contains("--foreground")
let size: CGFloat = 1024
let amber = CGColor(srgbRed: 1, green: 0xB3 / 255.0, blue: 0, alpha: 1)
let ink = CGColor(srgbRed: 0x0D / 255.0, green: 0x0D / 255.0, blue: 0x0D / 255.0, alpha: 1)

let alpha = foreground ? CGImageAlphaInfo.premultipliedLast : CGImageAlphaInfo.noneSkipLast // l'icona intera senza trasparenza: la richiede l'App Store
let ctx = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: alpha.rawValue)!
// Coordinate con l'origine in alto a sinistra, come nel disegno SVG.
ctx.translateBy(x: 0, y: size)
ctx.scaleBy(x: 1, y: -1)

// Fondo pieno: gli angoli arrotondati li applicano iOS e Android.
if !foreground {
  ctx.setFillColor(amber)
  ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))
}

// Il disegno è su una griglia 104×104.
let s = size / 104 * (foreground ? 72 / 108 : 1)
let margin = (size - 104 * s) / 2
func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: margin + x * s, y: margin + y * s) }

ctx.setStrokeColor(ink)
ctx.setLineCap(.round)
ctx.setLineJoin(.round)

// Tetto
ctx.setLineWidth(10.5 * s)
ctx.move(to: p(24, 54))
ctx.addLine(to: p(52, 28))
ctx.addLine(to: p(80, 54))
ctx.strokePath()

// Croce sotto il colmo, con le estremità tonde come il tetto (bracci lunghi 32, spessi 11)
ctx.setLineWidth(11 * s)
ctx.move(to: p(52, 56.5))
ctx.addLine(to: p(52, 77.5))
ctx.move(to: p(41.5, 67))
ctx.addLine(to: p(62.5, 67))
ctx.strokePath()

let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
