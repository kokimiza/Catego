#import "@preview/charged-ieee:0.1.4": ieee
#set text(font: "Noto Serif CJK JP")
#show: ieee.with(
  title: [圏論精義(下)],
  abstract: [Category Theory: Essential Foundations, Volume II extends the categorical language toward richer structural frameworks.
Adjunctions, monads, monoidal categories, topoi, and higher categorical structures are developed as systematic consequences of the foundational grammar. Selected dynamic and computational models are used to illuminate composition, coherence, and structure preservation across categorical levels.
This volume demonstrates how category theory functions as a unifying framework rather than a collection of isolated techniques.],
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

= サイズと内部構造
#include "manuscripts/ch08_size_and_internal_structure.typ"

= モナドとその周辺
#include "manuscripts/ch09_monads_and_related_constructions.typ"

= 加法圏とホモロジー的圏
#include "manuscripts/ch10_additive_and_homological_categories.typ"

= モノイダル性と構造
#include "manuscripts/ch11_monoidal_and_enriched_categories.typ"

= シーブとトポス
#include "manuscripts/ch12_sheaves_and_topoi.typ"

= 高次と拡張
#include "manuscripts/ch13_higher_and_extended_category_theory.typ"
