// Disegna l'icona di Refuge (tetto e croce neri su fondo ambra) in PNG 1024×1024.
// Uso: swift tool/icon/render_icon.swift <uscita.png>
import AppKit

let size: CGFloat = 1024
let s = size / 104 // il disegno originale è su una griglia 104×104
let dy: CGFloat = -2.5 // centra verticalmente tetto + croce
let amber = CGColor(red: 1, green: 0xB3 / 255.0, blue: 0, alpha: 1)
let ink = CGColor(red: 0x0D / 255.0, green: 0x0D / 255.0, blue: 0x0D / 255.0, alpha: 1)

let ctx = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)! // senza trasparenza: la richiede l'App Store
// Coordinate con l'origine in alto a sinistra, come nel disegno SVG.
ctx.translateBy(x: 0, y: size)
ctx.scaleBy(x: 1, y: -1)

// Fondo pieno: gli angoli arrotondati li applicano iOS e Android.
ctx.setFillColor(amber)
ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))

func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: (y + dy) * s) }

// Tetto
ctx.setStrokeColor(ink)
ctx.setLineWidth(10 * s)
ctx.setLineCap(.round)
ctx.setLineJoin(.round)
ctx.move(to: p(18, 58))
ctx.addLine(to: p(52, 26))
ctx.addLine(to: p(86, 58))
ctx.strokePath()

// Croce
ctx.setFillColor(ink)
for r in [CGRect(x: 47, y: 58, width: 10, height: 30), CGRect(x: 37, y: 68, width: 30, height: 10)] {
  let rect = CGRect(x: r.minX * s, y: (r.minY + dy) * s, width: r.width * s, height: r.height * s)
  ctx.addPath(CGPath(roundedRect: rect, cornerWidth: 2 * s, cornerHeight: 2 * s, transform: nil))
  ctx.fillPath()
}

let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
