// ─────────────────────────────────────────────────────────────
//  figlib.typ — drawing helpers and figures for the
//  ShearFlowLibrary.jl project overview (pure Typst, no packages)
// ─────────────────────────────────────────────────────────────

#let maroon = rgb("#7A1B1B")
#let gold   = rgb("#C8A040")
#let navy   = rgb("#0D1B3E")
#let cream  = rgb("#F5F0E0")
#let cellbg = rgb("#F4EBD3")
#let ink    = rgb("#222222")
#let muted  = rgb("#5E5E5E")
#let ok-bg  = rgb("#E3EFD9")
#let ok-ln  = rgb("#7FA36B")
#let ip-bg  = rgb("#F7DCC4")
#let ip-ln  = rgb("#C98A55")
#let df-bg  = rgb("#E6E6E6")
#let df-ln  = rgb("#9A9A9A")

// model → canvas mapping (y up in the model, y down on the page)
#let mapper(xmin, ymax, s, pad) = p => (
  (p.at(0) - xmin) * s + pad,
  (ymax - p.at(1)) * s + pad,
)

#let _ang(a, b) = calc.atan2((b.at(0) - a.at(0)) / 1pt, (b.at(1) - a.at(1)) / 1pt)

#let arrowhead(tip, ang, len: 6pt, wid: 2.4pt, fill: maroon) = {
  let (tx, ty) = tip
  let bx = tx - len * calc.cos(ang)
  let by = ty - len * calc.sin(ang)
  let nx = -calc.sin(ang)
  let ny = calc.cos(ang)
  place(top + left, polygon(
    fill: fill, stroke: none,
    (tx, ty), (bx + wid * nx, by + wid * ny), (bx - wid * nx, by - wid * ny),
  ))
}

// straight arrow between two canvas points
#let arrow(a, b, color: maroon, thickness: 1.1pt, head: 6pt) = {
  let ang = _ang(a, b)
  let b2 = (b.at(0) - head * 0.8 * calc.cos(ang), b.at(1) - head * 0.8 * calc.sin(ang))
  place(top + left, line(start: a, end: b2, stroke: thickness + color))
  arrowhead(b, ang, len: head, wid: head * 0.42, fill: color)
}

// counter-clockwise circulation arrow (as seen on the page)
#let circulation(c, r, color: gold, thickness: 1.1pt, from: 50deg, to: 335deg, n: 40, head: 5.5pt) = {
  let (cx, cy) = c
  let pt(phi) = (cx + r * calc.cos(phi), cy - r * calc.sin(phi))
  // the head sits on the chord between the base point and the tip
  let base = to - (head / r) * 1rad
  let pts = range(n + 1).map(i => pt(from + (base - from) * i / n))
  place(top + left, curve(
    stroke: thickness + color,
    curve.move(pts.first()),
    ..pts.slice(1).map(p => curve.line(p)),
  ))
  let tip = pt(to)
  arrowhead(tip, _ang(pts.last(), tip), len: head, wid: head * 0.44, fill: color)
}

#let wall(m, a, b, color: navy, thickness: 2.1pt) = place(
  top + left, line(start: m(a), end: m(b), stroke: (paint: color, thickness: thickness, cap: "round")),
)

#let node(m, p, r: 2.5pt) = {
  let (x, y) = m(p)
  place(top + left, dx: x - r, dy: y - r, circle(radius: r, fill: maroon, stroke: 0.7pt + white))
}

#let cell(m, pts, fill: cellbg) = place(top + left, polygon(fill: fill, stroke: none, ..pts.map(m)))

// content centred on a canvas point
#let at(p, body, dx: 0pt, dy: 0pt) = context {
  let sz = measure(body)
  place(top + left, dx: p.at(0) - sz.width / 2 + dx, dy: p.at(1) - sz.height / 2 + dy, body)
}

#let lab(body, size: 8.5pt, color: ink) = text(size: size, fill: color, body)

// small x–y axis triad
#let triad(o, len: 14pt) = {
  let (x, y) = o
  arrow((x, y), (x + len, y), color: muted, thickness: 0.6pt, head: 3.6pt)
  arrow((x, y), (x, y - len), color: muted, thickness: 0.6pt, head: 3.6pt)
  at((x + len + 4pt, y), lab(size: 7pt, color: muted, $x$))
  at((x, y - len - 4.5pt), lab(size: 7pt, color: muted, $y$))
}

// ── Panel (a): open channel ─────────────────────────────────
#let panel-open() = {
  let s = 0.48pt
  let pad = 6pt
  let (xmin, xmax, ymin, ymax) = (-78, 112, -112, 112)
  let m = mapper(xmin, ymax, s, pad)
  let W = (xmax - xmin) * s + 2 * pad
  let H = (ymax - ymin) * s + 2 * pad
  let n1 = (100, -100); let n2 = (0, -100); let n3 = (0, 100); let n4 = (100, 100)
  box(width: W, height: H, {
    wall(m, n1, n2); wall(m, n2, n3); wall(m, n3, n4)
    // basic shear flow, offset from the walls
    arrow(m((72, -118)), m((28, -118)), color: gold, thickness: 1pt, head: 5pt)
    arrow(m((16, -30)), m((16, 30)), color: gold, thickness: 1pt, head: 5pt)
    arrow(m((28, 118)), m((72, 118)), color: gold, thickness: 1pt, head: 5pt)
    at(m((34, 0)), lab(size: 8pt, $q_b$))
    // applied shear
    arrow(m((-42, -55)), m((-42, 55)), color: maroon, thickness: 1.2pt, head: 6pt)
    at(m((-42, 0)), lab($S_y$), dx: -9pt)
    for p in (n1, n2, n3, n4) { node(m, p) }
    triad(m((-74, -108)))
  })
}

// ── Panel (b): closed single-cell dart ──────────────────────
#let panel-single() = {
  let s = 5.6pt
  let pad = 6pt
  let (xmin, xmax, ymin, ymax) = (-5.2, 16.2, -9.4, 9.4)
  let m = mapper(xmin, ymax, s, pad)
  let W = (xmax - xmin) * s + 2 * pad
  let H = (ymax - ymin) * s + 2 * pad
  let n1 = (15, 8); let n2 = (0, 0); let n3 = (15, -8); let n4 = (9, 0)
  box(width: W, height: H, {
    cell(m, (n2, n1, n4, n3))
    wall(m, n2, n1); wall(m, n1, n4); wall(m, n4, n3); wall(m, n3, n2)
    circulation(m((6.6, 0)), 10.5pt)
    at(m((6.6, 0)), lab(size: 8pt, $"I"$))
    arrow(m((-2.6, -4.6)), m((-2.6, 4.6)), color: maroon, thickness: 1.2pt, head: 6pt)
    at(m((-2.6, 0)), lab($S_y$), dx: -9pt)
    for p in (n1, n2, n3, n4) { node(m, p) }
    triad(m((-4.8, -9.0)))
  })
}

// ── Panel (c): two-cell box (benchmark case 3) ─────────────
#let panel-multi() = {
  let s = 0.36pt
  let pad = 6pt
  let (xmin, xmax, ymin, ymax) = (-46, 508, -10, 128)
  let m = mapper(xmin, ymax, s, pad)
  let W = (xmax - xmin) * s + 2 * pad
  let H = (ymax - ymin) * s + 2 * pad
  let n1 = (0, 0); let n2 = (300, 0); let n3 = (500, 0)
  let n4 = (500, 120); let n5 = (300, 120); let n6 = (0, 120)
  box(width: W, height: H, {
    cell(m, (n1, n2, n5, n6))
    cell(m, (n2, n3, n4, n5), fill: cellbg.lighten(25%))
    for (p, q) in ((n1, n2), (n2, n3), (n3, n4), (n5, n4), (n5, n6), (n6, n1), (n5, n2)) {
      wall(m, p, q)
    }
    circulation(m((150, 60)), 13pt)
    at(m((150, 60)), lab(size: 8pt, $"I"$))
    circulation(m((400, 60)), 13pt)
    at(m((400, 60)), lab(size: 8pt, $"II"$))
    arrow(m((-24, 10)), m((-24, 110)), color: maroon, thickness: 1.2pt, head: 6pt)
    at(m((-24, 60)), lab($S_y$), dx: -9pt)
    for p in (n1, n2, n3, n4, n5, n6) { node(m, p) }
  })
}

#let legend-item(sym, body) = box(inset: (x: 5pt), {
  box(baseline: 30%, sym)
  h(3pt)
  text(size: 7.6pt, fill: muted, body)
})

#let topology-legend() = {
  let c = box(width: 8pt, height: 8pt, align(center + horizon, circle(radius: 2.4pt, fill: maroon)))
  let w = box(width: 14pt, height: 8pt, align(horizon, line(length: 14pt, stroke: 2.1pt + navy)))
  let qb = box(width: 16pt, height: 8pt, { place(top + left, dy: 0pt, arrow((0pt, 4pt), (15pt, 4pt), color: gold, thickness: 1pt, head: 4.5pt)) })
  let sy = box(width: 16pt, height: 8pt, { place(top + left, arrow((0pt, 4pt), (15pt, 4pt), color: maroon, thickness: 1.2pt, head: 5pt)) })
  let cc = box(width: 12pt, height: 12pt, { place(top + left, circulation((6pt, 6pt), 4.6pt, thickness: 0.9pt)) })
  let cb = box(width: 10pt, height: 8pt, fill: cellbg)
  align(center, {
    legend-item(c, [node])
    legend-item(w, [straight wall])
    legend-item(cb, [closed cell])
    legend-item(sy, [applied shear])
    legend-item(qb, [basic flow $q_b$])
    legend-item(cc, [cell circulation $q_s$])
  })
}

#let panel-caption(title, counts, eq) = align(center, text(size: 8.6pt, {
  text(weight: "bold", fill: maroon, title)
  linebreak()
  counts
  linebreak()
  eq
}))

#let fig-topologies() = {
  grid(
    columns: (auto, auto, auto),
    column-gutter: 10pt,
    row-gutter: 6pt,
    align: (center + bottom),
    panel-open(), panel-single(), panel-multi(),
    panel-caption([(a) Open section], $V = 4, E = 3 ⇒ N_c = 0$, $q = q_b$),
    panel-caption([(b) Single-cell section], $V = 4, E = 4 ⇒ N_c = 1$, $bold(q) = bold(q)_b + bold(C) bold(q)_s$),
    panel-caption([(c) Multicell section], $V = 6, E = 7 ⇒ N_c = 2$, $bold(q) = bold(q)_b + bold(C) bold(q)_s$),
  )
  v(4pt)
  topology-legend()
}

// ── Application overview flowchart ──────────────────────────
#let fbox(body, kind: "done", width: 100%) = {
  let (fill, stroke) = if kind == "done" { (white, 0.7pt + navy) }
    else if kind == "core" { (cream, 0.7pt + maroon) }
    else if kind == "planned" { (white, (paint: muted, thickness: 0.7pt, dash: "dashed")) }
    else { (white, (paint: maroon, thickness: 0.8pt, dash: "dashed")) }
  block(width: width, fill: fill, stroke: stroke, radius: 3pt, inset: (x: 5pt, y: 4.5pt), breakable: false, {
    set par(justify: false, leading: 0.5em)
    set text(size: 7.6pt, fill: ink, hyphenate: false)
    align(center, body)
  })
}

#let ftitle(body) = text(weight: "bold", fill: navy, size: 7.9pt, body)
#let colhead(body) = align(center, text(size: 7.6pt, weight: "bold", fill: maroon, tracking: 0.6pt, upper(body)))
#let harrow = align(center + horizon, box(width: 16pt, height: 10pt, place(top + left, arrow((0pt, 5pt), (15pt, 5pt), color: maroon, thickness: 1.2pt, head: 5.5pt))))
#let varrow = align(center, box(width: 10pt, height: 9pt, place(top + left, arrow((5pt, 0pt), (5pt, 9pt), color: maroon, thickness: 1pt, head: 4.5pt))))

#let fig-application() = {
  let inputs = stack(spacing: 6pt,
    fbox[#ftitle[Section geometry] \ nodes, straight walls, thickness $t$, optional boom areas $B_r$],
    fbox[#ftitle[Loading] \ shear resultants $S_x, S_y$ and their line of action],
  )
  let core = block(width: 100%, stroke: 1.2pt + maroon, radius: 4pt, inset: 0pt, clip: true, {
    block(width: 100%, fill: maroon, inset: (x: 5pt, y: 4pt),
      align(center, text(fill: white, weight: "bold", size: 8pt)[ShearFlowLibrary.jl]))
    block(width: 100%, inset: (x: 5pt, top: 2pt, bottom: 5pt), stack(spacing: 2pt,
      fbox(kind: "core")[#ftitle[Topology] \ section graph, automatic cell identification],
      varrow,
      fbox(kind: "core")[#ftitle[Section properties] \ centroid, $I_(x x), I_(y y), I_(x y)$],
      varrow,
      fbox(kind: "core")[#ftitle[Shear-flow analysis] \ one formulation: open, single-cell and multicell],
    ))
  })
  let outputs = stack(spacing: 6pt,
    fbox[#ftitle[Section properties] \ for stress and stiffness checks],
    fbox[#ftitle[Shear flow] $q(s)$ \ in every wall],
    fbox[#ftitle[Rate of twist] $G theta'$ \ of each closed cell],
    fbox(kind: "planned")[#ftitle[Planned] \ shear centre, $tau = q slash t$, torsion],
  )
  let apps = stack(spacing: 6pt,
    fbox[#ftitle[Aircraft sections] \ wing boxes, spars, ribs, fuselage frames],
    fbox[#ftitle[Teaching and verification] \ against classical thin-walled results],
    fbox(kind: "explore")[#ftitle[Strain-based monitoring] \ #text(style: "italic", fill: maroon)[exploratory]],
    fbox(kind: "explore")[#ftitle[Additively manufactured thin walls] \ #text(style: "italic", fill: maroon)[exploratory]],
  )
  grid(
    columns: (1fr, 18pt, 1.12fr, 18pt, 1fr, 18pt, 1.05fr),
    row-gutter: 6pt,
    align: (center + horizon),
    colhead[Inputs], [], colhead[Analysis core], [], colhead[Results], [], colhead[Applications],
    inputs, harrow, core, harrow, outputs, harrow, apps,
  )
  v(5pt)
  let sw(kind) = box(width: 16pt, height: 8pt, baseline: 20%, fbox(kind: kind, width: 16pt)[])
  align(center, text(size: 7.4pt, fill: muted, {
    box(baseline: 25%, block(width: 14pt, height: 8pt, stroke: 0.7pt + navy, radius: 2pt)); h(3pt); [available]; h(12pt)
    box(baseline: 25%, block(width: 14pt, height: 8pt, stroke: (paint: muted, thickness: 0.7pt, dash: "dashed"), radius: 2pt)); h(3pt); [planned]; h(12pt)
    box(baseline: 25%, block(width: 14pt, height: 8pt, stroke: (paint: maroon, thickness: 0.8pt, dash: "dashed"), radius: 2pt)); h(3pt); [exploratory pathway (not a current deliverable)]
  }))
}
