// ShearFlowLibrary.jl — public project overview (README as PDF)
// Compile with Typst ≥ 0.13:  typst compile ShearFlowLibrary_README.typ
#import "figlib.typ": *

#set document(
  title: "ShearFlowLibrary.jl — A Julia Toolbox for the Analysis of Thin-Walled Sections",
  author: "Sampreet Kulkarni",
  keywords: ("thin-walled sections", "shear flow", "Julia", "aircraft structures", "multicell"),
)

#set page(
  paper: "a4",
  margin: (x: 2cm, top: 1.9cm, bottom: 2.1cm),
  footer: context {
    set text(size: 7.8pt, fill: muted)
    line(length: 100%, stroke: 0.4pt + gold)
    v(-5pt)
    grid(columns: (1fr, auto),
      [ShearFlowLibrary.jl · Project overview],
      [#counter(page).display() / #counter(page).final().first()])
  },
)
#set text(font: "Libertinus Serif", size: 10.4pt, fill: ink, lang: "en", region: "GB")
#set par(justify: true, leading: 0.6em, spacing: 0.85em)
#set math.equation(numbering: "(1)", supplement: [Eq.])
#show math.equation.where(block: true): set block(spacing: 0.8em)
#set list(indent: 0.6em, body-indent: 0.45em, marker: text(fill: maroon, sym.bullet))
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => {
  v(8pt)
  block(below: 7pt, sticky: true, {
    text(size: 13.5pt, weight: "bold", fill: maroon, it)
    v(-7pt)
    line(length: 100%, stroke: 0.7pt + gold)
  })
}
#show heading.where(level: 2): it => block(above: 11pt, below: 6pt, sticky: true,
  text(size: 10.8pt, weight: "bold", fill: navy, it))
#show figure.caption: it => text(size: 8.8pt, fill: muted, {
  text(weight: "bold", fill: maroon, [#it.supplement #context it.counter.display(it.numbering).])
  [ ]
  it.body
})
#show link: set text(fill: maroon)
#show ref: it => {
  let el = it.element
  if el != none and el.func() == math.equation {
    link(el.location(), [Eq.~#numbering(el.numbering, ..counter(math.equation).at(el.location()))])
  } else { it }
}
#show table: set par(justify: false)

// ── small components ─────────────────────────────────────────
#let badge(label, value, color: navy) = box(baseline: 28%, radius: 2pt, clip: true, stroke: 0.5pt + color, {
  box(fill: color, inset: (x: 4.5pt, y: 2.8pt), text(fill: white, size: 7.4pt, weight: "bold", label))
  box(fill: white, inset: (x: 4.5pt, y: 2.8pt), text(fill: color, size: 7.4pt, value))
})

#let callout(title: none, body) = block(
  width: 100%, fill: cream, stroke: (left: 3pt + maroon), radius: (right: 3pt),
  inset: (left: 11pt, right: 10pt, y: 8pt), breakable: false,
  { if title != none { text(weight: "bold", fill: maroon, title); h(6pt) }; body },
)

#let card-title(body) = text(weight: "bold", fill: navy, size: 10pt, body)

#let pill(kind) = {
  let (bg, ln, lbl) = if kind == "done" { (ok-bg, ok-ln, [Completed]) }
    else if kind == "prog" { (ip-bg, ip-ln, [In progress]) }
    else if kind == "plan" { (white, muted, [Planned]) }
    else { (df-bg, df-ln, [Deferred]) }
  box(fill: bg, stroke: 0.6pt + ln, radius: 7pt, inset: (x: 6pt, y: 2.2pt), text(size: 8pt, lbl))
}

#let th(body) = text(weight: "bold", fill: white, size: 8.8pt, body)
#let zebra = (x, y) => if y == 0 { maroon } else if calc.even(y) { cream } else { white }

// ═════════════════════════════════════════════════════════════
//  TITLE
// ═════════════════════════════════════════════════════════════
#block(width: 100%, below: 10pt, {
  text(size: 27pt, weight: "bold", fill: maroon)[ShearFlowLibrary.jl]
  v(-14pt)
  text(size: 13.5pt, style: "italic", fill: navy)[A Julia Toolbox for the Analysis of Thin-Walled Sections]
  v(-2pt)
  text(size: 10.5pt)[A graph-based computational framework for shear-flow analysis of arbitrary
  open, single-cell and multicell thin-walled sections.]
  v(2pt)
  badge[language][Julia]
  h(3pt)
  badge[domain][thin-walled structures]
  h(3pt)
  badge[sections][open · single-cell · multicell]
  h(3pt)
  badge(color: maroon)[status][active M.Tech research]
  h(3pt)
  badge(color: muted)[implementation][private]
  v(2pt)
  line(length: 100%, stroke: 0.7pt + gold)
  v(-5pt)
  text(size: 8.8pt, fill: muted)[*Sampreet Kulkarni* #h(4pt)·#h(4pt) M.Tech, Department of Aerospace Engineering,
  IIT Madras \ Guide: Nidish Narayanaa Balaji #h(4pt)·#h(4pt) Project overview, November 2026]
})

ShearFlowLibrary.jl is an ongoing M.Tech research project that develops a modular Julia framework for
the analysis of thin-walled aerospace structures. A cross-section is described as a graph of nodes and
straight walls; from that description the library derives the section topology, the section properties and
the shear-flow distribution, with *one formulation covering open, single-cell and multicell sections*. The
objective is a flexible, extensible tool that bridges classical aircraft structural analysis with modern
scientific computing.

#figure(
  fig-topologies(),
  caption: [The three section classes handled by the library, drawn with the geometries of the benchmark
  cases in @tab-val (loads shown schematically). The number of closed cells $N_c$ follows from the number of
  nodes $V$ and walls $E$ alone.],
) <fig-topo>

#callout(title: [One formulation for every topology])[
  $bold(q) = bold(q)_b + bold(C) bold(q)_s$ #h(1.2em) with #h(0.6em) $N_c = E - V + 1$ #h(0.6em) —
  the closed cells and their redundant shear flows are identified from the section graph, so the
  analyst never has to choose where to cut a cell.
]

= Key features

#grid(
  columns: (1fr, 1fr),
  stroke: 0.6pt + rgb("#DCCFAE"),
  inset: (x: 9pt, y: 8pt),
  fill: (x, y) => if calc.even(x + y) { white } else { rgb("#FBF8EF") },
  [
    #card-title[Graph-based geometry]
    #set text(size: 9.3pt)
    #set par(justify: false)
    - Node- and edge-based description of the section.
    - Half-edge topology for section connectivity.
    - Automatic identification of closed cells.
    - Spanning-tree representation of independent cycles.
  ],
  [
    #card-title[Section properties]
    #set text(size: 9.3pt)
    #set par(justify: false)
    - Centroid of the thin-walled section.
    - Second moments of area $I_(x x)$, $I_(y y)$, $I_(x y)$.
    - Closed-form evaluation for straight wall strips.
    - Optional discrete boom areas.
  ],
  [
    #card-title[Generalised shear flow]
    #set text(size: 9.3pt)
    #set par(justify: false)
    - Open, single-cell and multicell sections.
    - Arbitrary cell adjacency; no sequential cell ordering assumed.
    - Shear loads $S_x$, $S_y$ with a general line of action.
  ],
  [
    #card-title[Analytical, matrix-based solution]
    #set text(size: 9.3pt)
    #set par(justify: false)
    - Exact integration along straight, constant-thickness walls.
    - No numerical quadrature and no mesh.
    - Multicell equations assembled from incidence matrices.
  ],
)

= Theoretical formulation

The library follows the classical thin-walled assumptions of aircraft structural analysis [1]: the wall
thickness is small compared with the section dimensions, and the shear stress is constant through the
thickness and tangential to the wall mid-line, so the shear flow $q = tau t$ is the primary unknown. Each wall
is a straight element $e$ of length $L_e$ and constant thickness $t_e$.

== Section properties

With total wall area $A_w$ and optional boom areas $B_r$ located at $(x_r, y_r)$, the centroid is

$ macron(x) = (integral_A x dif A + sum_r B_r x_r) / (A_w + sum_r B_r), #h(2em)
  macron(y) = (integral_A y dif A + sum_r B_r y_r) / (A_w + sum_r B_r). $

Using centroidal coordinates $xi = x - macron(x)$ and $eta = y - macron(y)$, the second moments of area are

$ I_(x x) = integral_A eta^2 dif A + sum_r B_r eta_r^2, quad
  I_(y y) = integral_A xi^2 dif A + sum_r B_r xi_r^2, quad
  I_(x y) = integral_A xi eta dif A + sum_r B_r xi_r eta_r . $

== Basic shear flow

For shear resultants $S_x$ and $S_y$, longitudinal equilibrium of a wall element gives the basic shear flow
along a wall, measured by the coordinate $s$ from its start [1]:

$ q_b (s) = q_(b,0) - k_x (integral_0^s t xi dif s + sum_r B_r xi_r)
                    - k_y (integral_0^s t eta dif s + sum_r B_r eta_r), $ <eq:qb>

$ k_x = (S_x I_(x x) - S_y I_(x y)) / (I_(x x) I_(y y) - I_(x y)^2), #h(2em)
  k_y = (S_y I_(y y) - S_x I_(x y)) / (I_(x x) I_(y y) - I_(x y)^2). $

Here $q_(b,0)$ is the flow at the start of the wall (zero at a free edge) and the boom sums include every
boom passed. Continuity of flow at each joint fixes the starting values of the walls that leave it. For an
open section, @eq:qb is the complete solution.

== Topology and redundant shear flows

For a connected section graph with $V$ nodes and $E$ walls, the number of independent closed cells is the
cyclomatic number of the graph:

$ N_c = E - V + 1. $ <eq:nc>

A spanning tree of the graph contains $V - 1$ walls. Cutting the remaining $N_c$ walls leaves an open,
tree-shaped section on which the basic flow is defined, so the cuts are chosen by the graph, not by the
user. The wall shear flows $bold(q) in RR^E$ are then written as

$ bold(q) = bold(q)_b + bold(C) bold(q)_s, $ <eq:q>

where $bold(q)_s in RR^(N_c)$ holds the redundant cell circulations and $bold(C) in {-1, 0, 1}^(E times N_c)$
is the edge–cell incidence matrix,

$ C_(e R) = cases(
  +1 & "if cell" R "traverses wall" e "along its stored direction,",
  -1 & "if cell" R "traverses wall" e "against its stored direction,",
  #h(0.75em) 0 & "if wall" e "is not on the boundary of cell" R .
) $

All cells are taken positive counter-clockwise, so a wall shared by cells $R$ and $S$ carries
$q_(s,R) - q_(s,S)$. @fig-topo shows how $N_c$ follows from $V$ and $E$ for the three section classes.

== Compatibility and moment equilibrium

All cells of a section twist together. With shear modulus $G$ and rate of twist $theta' = upright(d) theta slash upright(d) z$, the twist of cell $R$ is [1]

$ G theta' = 1 / (2 A_R) integral.cont_R q / t dif s, #h(2em) R = 1, dots, N_c. $

Substituting @eq:q and summing wall by wall gives the compatibility equations in matrix form,

$ bold(D) = bold(C)^T bold(W) bold(C), quad bold(W) = op("diag")(L_e / t_e), quad
  bold(B) = bold(C)^T bold(j), quad j_e = integral_e q_b / t dif s, $

$ bold(D) bold(q)_s + bold(B) = 2 bold(A) G theta', $ <eq:compat>

where $bold(A) = (A_1, dots, A_(N_c))^T$ holds the enclosed cell areas. $bold(D)$ is the cell flexibility
matrix (its off-diagonal terms couple cells through shared walls) and $bold(B)$ is the twist produced by
the basic flow. Moment equilibrium about any reference point closes the system. A constant circulation
$q_(s,R)$ around cell $R$ contributes a torque $2 A_R q_(s,R)$, so

$ 2 bold(A)^T bold(q)_s = M_"load" - M_(q_b), #h(2em) M_(q_b) = sum_e integral_e p_e q_b dif s, $ <eq:moment>

where $p_e$ is the perpendicular distance from the reference point to the line of wall $e$ and $M_"load"$
is the moment of $S_x$, $S_y$ acting along their line of action. Together, @eq:compat and @eq:moment form
the bordered system

$ mat(delim: "[", bold(D), -2 bold(A); 2 bold(A)^T, 0)
  vec(delim: "{", bold(q)_s, G theta') =
  vec(delim: "{", -bold(B), M_"load" - M_(q_b)) $ <eq:bordered>

of size $(N_c + 1) times (N_c + 1)$. Its solution gives the cell circulations and the common rate of
twist, and the total shear flow follows from @eq:q. Because $bold(D)$ is assembled from the incidence
matrix, the formulation handles arbitrary cell adjacency without a sequential cell arrangement.

#callout(title: [Special cases])[
  *Open* ($N_c = 0$): no redundant unknowns, $bold(q) = bold(q)_b$.
  *Single cell* ($N_c = 1$): @eq:bordered reduces to the classical single-cell relations; moment
  equilibrium gives $q_(s,0)$, and $G theta' = 0$ when the load acts through the shear centre.
  *Multicell* ($N_c >= 2$): $N_c$ compatibility equations share one rate of twist and are closed by a
  single moment equation.
]

== Analytical element integration

On a straight wall of constant thickness, $xi$ and $eta$ vary linearly with $s$, so $q_b (s)$ in
@eq:qb is quadratic in $s$. The wall integrals $j_e$ and $integral_e p_e q_b dif s$ are therefore
evaluated exactly in closed form: for this class of section the results carry no quadrature or
discretisation error, and no mesh is required.

= Application overview

@fig-app shows how the library is intended to be used. A section definition and its loading go in;
section properties, wall shear flows and cell twist rates come out and feed downstream analyses. The
figure describes the scope of the library, not its internal algorithms.

#figure(
  fig-application(),
  caption: [Application overview. Solid boxes are available today; dashed boxes are planned features or
  exploratory application pathways.],
) <fig-app>

#pagebreak()
= Verification and validation

The implementation is checked against textbook solutions and through internal consistency checks that
cover each section class.

#figure(
  kind: table,
  table(
    columns: (auto, 1.35fr, auto, 1.45fr),
    stroke: none,
    fill: zebra,
    inset: (x: 6pt, y: 5pt),
    align: (left + horizon, left + horizon, left + horizon, left + horizon),
    table.header(th[Case], th[Section and loading], th[Reference], th[Quantities compared]),
    [*Open channel* \ $N_c = 0$],
    [$h = 200$, $b = 100$, $t = 2$ mm; $S_y = 10$ kN through the shear centre ($x_S = -37.5$ mm)],
    [Megson, \ Ex. 17.3],
    [$q_2 = 37.5$ N/mm (corner), \ $q_max = 56.25$ N/mm (mid-web)],
    [*Single-cell dart* \ $N_c = 1$],
    [$a = 10$ mm, $t = 1$ mm; $S_y = 10$ kN at $x_0 = -10a slash 3$],
    [Megson, \ Ex. 17.7],
    [$q_4 = 50.93$ N/mm (book: 50.95); $G theta' = 0$, confirming the shear centre at $-10a slash 3$
      (book: $-3.35a$)],
    [*Two-cell box* \ $N_c = 2$],
    [$(300 + 200) times 120$ mm, $t = 1.5$–$2.5$ mm; $S = (2, 20)$ kN at $(125, 80)$ mm],
    [No textbook \ case],
    [Equilibrium and equal twist; $G theta' = -0.1373$ N/mm³ from an independent global formulation],
    table.hline(stroke: 0.8pt + maroon),
  ),
  caption: [Benchmark cases. Cases 1 and 2 are textbook examples from Megson [1]; case 3 has no textbook solution.],
) <tab-val>

#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  [
    #set par(justify: false)
    #block(below: 5pt, text(weight: "bold", fill: navy)[Additional consistency checks])
    #set text(size: 9.6pt)
    - Force equilibrium: wall flows reproduce $S_x$ and $S_y$.
    - Moment equilibrium about an arbitrary point.
    - Equal rate of twist in every cell.
    - Invariance of the total shear flow under a change of spanning-tree root.
  ],
  [
    #set par(justify: false)
    #block(below: 5pt, text(weight: "bold", fill: navy)[Note on small differences])
    #set text(size: 9.6pt)
    The section properties keep the through-thickness $t^3 slash 12$ terms of each wall strip, whereas
    the textbook solutions use the thin-line approximation, so differences of order $10^(-5)$ are expected.
    Verification and regression testing are ongoing.
  ],
)

= Development status

#figure(
  kind: table,
  table(
    columns: (1.25fr, 1.6fr, auto),
    stroke: none,
    fill: zebra,
    inset: (x: 6pt, y: 4.2pt),
    align: (left + horizon, left + horizon, center + horizon),
    table.header(th[Component], th[Scope], th[Status]),
    [Geometry and topology], [graph, half-edge topology, cell identification], pill("done"),
    [Section properties], [centroid, $I_(x x)$, $I_(y y)$, $I_(x y)$, optional booms], pill("done"),
    [Shear load definition], [$S_x$, $S_y$ and line of action], pill("done"),
    [Shear-flow analysis], [open, single-cell and multicell sections], pill("done"),
    [Verification and regression tests], [Megson benchmark suite], pill("prog"),
    [API consolidation], [single, unified analysis interface], pill("prog"),
    [Visualisation], [geometry plots], pill("prog"),
    [Shear-centre calculation], [separate analysis function], pill("plan"),
    [Shear-stress post-processing], [$tau = q slash t$], pill("plan"),
    [Torque loading], [closed-cell torque and open-section torsion], pill("plan"),
    [Shear-flow plots], [wall-by-wall post-processing], pill("plan"),
    [Boom–skin idealisation], [automatic idealisation from raw geometry], pill("def"),
    table.hline(stroke: 0.8pt + maroon),
  ),
  caption: [Status as of November 2026. Automatic boom–skin idealisation is deferred on supervisor
  direction; user-supplied boom areas are already supported.],
) <tab-status>

#pagebreak()
= Future development and applications

== Library roadmap

- *Shear centre* as a separate analysis, followed by *torque loading* and *open-section torsion*.
- *Shear-stress evaluation* $tau = q slash t$ and improved post-processing and visualisation.
- A *consolidated public interface* and a regression suite built on textbook benchmarks.
- Longer term: *curved (polynomial) wall elements* for more general geometry and *modulus-weighted
  sections* for walls and booms of different materials.

== Potential applications

Beyond conventional aircraft section analysis (wing boxes, spars, ribs and fuselage frames), two
application pathways are being explored. Both are feasibility studies, *not current deliverables*.

#grid(
  columns: (1fr, 1fr),
  column-gutter: 10pt,
  stroke: (paint: maroon, thickness: 0.8pt, dash: "dashed"),
  inset: 9pt,
  {
    card-title[Strain-based shear-flow monitoring]
    v(1pt)
    set text(size: 9.3pt)
    set math.equation(numbering: none)
    [The solver is linear in the applied loads, so unit-load solutions form an influence matrix
    $bold(Q)$ with $bold(q) = bold(Q) bold(L)$. Measured strains $bold(epsilon)$ give a least-squares
    estimate of the section loads, from which the full shear-flow field follows:]
    $ hat(bold(L)) = op("arg min", limits: #true)_(bold(L)) norm(bold(epsilon) - bold(H) bold(L))^2,
      quad hat(bold(q)) = bold(Q) hat(bold(L)). $
    [_Open questions:_ the strain–load model $bold(H)$, sensor placement, measurement noise and model
    error.]
  },
  {
    card-title[Additively manufactured thin walls]
    v(1pt)
    set text(size: 9.3pt)
    set math.equation(numbering: none)
    [Slicer toolpaths of a printed layer can be converted into nodes and walls and analysed as a
    multicell section, layer by layer and for several build orientations. A per-wall check, e.g. Tresca
    for metals with $tau = q slash t$,]
    $ tau_max = sqrt((sigma_z slash 2)^2 + tau^2) <= sigma_Y slash 2, $
    [or interlayer bond strength for polymers, needs one small linear solve per slice instead of a full
    3-D finite-element model. _Requires:_ per-wall $E$, $G$, anisotropy, interlayer strength, process
    effects and experiments.]
  },
)

= About the project

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  [
    == Technology stack
    #set text(size: 9.6pt)
    #table(
      columns: (auto, 1fr),
      stroke: none,
      inset: (x: 0pt, y: 3.2pt),
      column-gutter: 8pt,
      text(fill: maroon, weight: "bold")[Language], [Julia],
      text(fill: maroon, weight: "bold")[Numerics], [linear algebra, matrix-based formulations],
      text(fill: maroon, weight: "bold")[Geometry], [graph and half-edge representations],
      text(fill: maroon, weight: "bold")[Domain], [aircraft structures, thin-walled mechanics],
      text(fill: maroon, weight: "bold")[Versioning], [Git and GitHub],
    )
  ],
  [
    == Research context
    #set text(size: 9.6pt)
    Developed as part of an M.Tech project in Aerospace Engineering at the Indian Institute of Technology
    Madras, under the guidance of Nidish Narayanaa Balaji. The project focuses on computational methods
    for thin-walled aerospace structures, with emphasis on graph-based modelling, structural mechanics
    and numerical implementation in Julia.
  ],
)

== Collaboration and contact

Interested in the formulation, potential applications or academic collaboration? Please open an issue on
this repository or get in touch through the contact details on my GitHub profile.

#v(4pt)
#block(width: 100%, fill: rgb("#F4F4F4"), radius: 3pt, inset: (x: 10pt, y: 7pt), text(size: 8.8pt, fill: muted)[
  This repository is a project overview and technical showcase. The implementation, internal tests and
  unpublished research files are not included.
])

#v(6pt)
#text(size: 9pt)[
  *Reference* \
  [1] T. H. G. Megson, _Aircraft Structures for Engineering Students_. Butterworth-Heinemann, 2021.
]
