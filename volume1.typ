#import "@preview/charged-ieee:0.1.4": ieee
#set text(font: "Noto Serif CJK JP")
#show: ieee.with(
  title: [圏論精義(上)],
  abstract: [Category Theory: Essential Foundations, Volume I develops category theory as a precise mathematical language.
Objects, morphisms, functors, natural transformations, and universal constructions are introduced in a staged and axiomatic manner. Emphasis is placed on commutative diagrams and structural correspondence, clarifying what category theory describes and what it deliberately abstracts away.
This volume establishes the basic grammar required to reason categorically across mathematical domains.],
  authors: (
    (
      name: "Yu Tokunaga",
      department: [Founder],
      organization: [Jocarium Productions],
      location: [Hiroshima, Japan],
      email: "tokunaga@jocarium.productions"
    ),
  ),
  index-terms: ("Scientific writing", "Typesetting", "Document creation", "Syntax"),
  bibliography: bibliography("refs.bib"),
  figure-supplement: [Fig.],
)

#outline(depth: 2)

= 圏と言語
#include "manuscripts/ch01_categories_and_language.typ"

= 射の性質
#include "manuscripts/ch02_morphisms_and_properties.typ"

= 関手
#include "manuscripts/ch03_functors.typ"

= 自然変換
#include "manuscripts/ch04_natural_transformations.typ"

= Homと表現
#include "manuscripts/ch05_hom_functors.typ"

= 普遍性
#include "manuscripts/ch06_universality_and_limits.typ"

= 随伴
#include "manuscripts/ch07_adjunctions.typ"