#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#show: show-theorion

これまでの章では、一般的な圏の性質を学んできた。本章では、代数学や代数的位相幾何学において中心的な役割を果たす特殊な圏――*加法圏* と *アーベル圏* ――を詳しく調べる。これらの圏では、射に「足し算」の構造が備わり、線形代数的な手法が圏論的に一般化される。さらに、ホモロジー代数の基礎となる完全列や導来圏についても探求する。

== 加法圏：射の線形構造

通常の圏では、二つの射 $f, g: X -> Y$ を「足す」ことはできない。しかし、アーベル群や加群の圏では、射（線形写像）同士を自然に加算できる。この構造を抽象化したのが加法圏である。

#definition(title: "加法圏 (Additive Category)")[
  圏 $bold(A)$ が *加法圏* であるとは、次の条件を満たすことである：
  1. *有限積の存在*: 任意の有限個の対象の積が存在する（特に終対象 $0$ が存在）
  2. *Hom 集合の加法構造*: 各 $op("hom")(X, Y)$ がアーベル群の構造を持つ
  3. *合成の双線形性*: 射の合成が加法に関して分配律を満たす：
     $ (f + g) compose h = f compose h + g compose h $
     $ h compose (f + g) = h compose f + h compose g $
]

#important-box(title: "零対象の特殊性")[
  加法圏では、終対象と始対象が一致し、これを *零対象* (zero object) と呼ぶ。零対象 $0$ は、任意の対象 $X$ に対して $op("hom")(X, 0) = op("hom")(0, X) = \{0\}$ を満たす。
]

=== 加法圏の基本性質

加法圏では、積と余積が自然に一致する。

#theorem(title: "双積 (Biproduct)")[
  加法圏において、任意の二つの対象 $A, B$ に対し、その積 $A times B$ と余積 $A plus.o B$ は同型である。この統一された構造を *双積* (biproduct) と呼び、$A plus.o B$ と表記する。
]

#proof[
  積の射影 $p_A: A plus.o B -> A$, $p_B: A plus.o B -> B$ と余積の入射 $i_A: A -> A plus.o B$, $i_B: B -> A plus.o B$ の間に、次の関係が成り立つ：
  $ p_A compose i_A = id_A, quad p_B compose i_B = id_B $
  $ p_A compose i_B = 0, quad p_B compose i_A = 0 $
  $ i_A compose p_A + i_B compose p_B = id_(A plus.o B) $
]

#figure(
  caption: [加法圏における主要な概念の比較],
  placement: top,
  table(
    columns: (8em, auto, auto),
    align: (left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*概念*][*一般の圏*][*加法圏*],

    [射の集合],
    [単なる集合],
    [アーベル群],

    [積と余積],
    [一般には異なる],
    [同型（双積）],

    [零射],
    [存在しない場合がある],
    [常に存在：$0: X -> Y$],

    [分解],
    [一般的でない],
    [kernel-cokernel 分解],
  )
)

== アーベル圏：完全性の世界

加法圏にさらに強い条件を課すことで、線形代数の完全な一般化であるアーベル圏が得られる。

#definition(title: "アーベル圏 (Abelian Category)")[
  加法圏 $bold(A)$ が *アーベル圏* であるとは、次の条件を満たすことである：
  1. 任意の射が kernel と cokernel を持つ
  2. 任意のモノ射が kernel であり、任意のエピ射が cokernel である
]

#remark[
  条件2は、アーベル圏では「単射性・全射性」と「kernel・cokernel であること」が完全に一致することを意味する。これにより、線形代数における「単射 ⟺ kernel が自明」「全射 ⟺ cokernel が自明」という性質が圏論的に一般化される。
]

=== Kernel と Cokernel

#definition(title: "Kernel と Cokernel")[
  射 $f: A -> B$ に対して：
  - $f$ の *kernel* とは、射 $k: K -> A$ であって $f compose k = 0$ を満たし、同様の性質を持つ任意の射が $k$ を通して一意に分解されるもの
  - $f$ の *cokernel* とは、射 $c: B -> C$ であって $c compose f = 0$ を満たし、同様の性質を持つ任意の射が $c$ を通して一意に分解されるもの
]

これらは次の普遍性によって特徴づけられる：

$ 
cases(
  op("ker")(f) = op("lim")(A arrow.r.double^f B arrow.r.double^0 0),
  op("coker")(f) = op("colim")(0 arrow.r.double^0 A arrow.r.double^f B)
)
$

== 射の標準分解

アーベル圏の最も美しい性質の一つは、任意の射が標準的な形に分解されることである。

#theorem(title: "射の標準分解")[
  アーベル圏において、任意の射 $f: A -> B$ は次のように分解される：
  $ A arrow.r.double op("coim")(f) arrow.r.hook op("im")(f) arrow.r.hook B $
  ここで：
  - $op("coim")(f) = op("coker")(op("ker")(f))$ は $f$ の余像
  - $op("im")(f) = op("ker")(op("coker")(f))$ は $f$ の像
  - 中央の射 $op("coim")(f) -> op("im")(f)$ は同型射
]

射の標準分解は次の可換図式で表される：

$
op("ker")(f) arrow.r.hook A arrow.r.double op("coim")(f) arrow.r^"≅" op("im")(f) arrow.r.hook B arrow.r.double op("coker")(f)
$

ここで、縦の射 $A -> B$ が元の射 $f$ である。

この分解により、任意の射は「全射部分」「同型部分」「単射部分」に美しく分かれる。

== 完全列：情報の流れの解析

アーベル圏における最も重要な概念の一つが *完全列* (exact sequence) である。

#definition(title: "完全列")[
  射の列
  $ ... -> A_(n-1) arrow.r^(f_(n-1)) A_n arrow.r^(f_n) A_(n+1) -> ... $
  が *完全* であるとは、各点で $op("im")(f_(n-1)) = op("ker")(f_n)$ が成り立つことである。
]

特に重要なのは *短完全列* (short exact sequence) である：

$ 0 -> A arrow.r^f B arrow.r^g C -> 0 $

この列が完全であることは、次と同値である：
1. $f$ は単射（$op("ker")(f) = 0$）
2. $g$ は全射（$op("coker")(g) = 0$）
3. $op("im")(f) = op("ker")(g)$

#figure(
  caption: [短完全列の解釈],
  placement: top,
  table(
    columns: (6em, auto),
    align: (left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*記号*][*意味*],

    [$0 -> A -> B$],
    [$A$ は $B$ の部分対象として埋め込まれる],

    [$B -> C -> 0$],
    [$C$ は $B$ の商対象として得られる],

    [$A -> B -> C$],
    [$B$ は $A$ と $C$ の「拡張」として構成される],
  )
)

=== 五項補題と蛇の補題

完全列の操作において基本的な道具となるのが、次の補題群である。

#lemma(title: "五項補題 (Five Lemma)")[
  可換図式
  $
  cases(
    A_1 arrow.r^(f_1) A_2 arrow.r^(f_2) A_3 arrow.r^(f_3) A_4 arrow.r^(f_4) A_5,
    B_1 arrow.r^(g_1) B_2 arrow.r^(g_2) B_3 arrow.r^(g_3) B_4 arrow.r^(g_4) B_5
  )
  $
  において、上下の行が完全で、$alpha_1, alpha_2, alpha_4, alpha_5$ が同型ならば、$alpha_3$ も同型である。
]

#lemma(title: "蛇の補題 (Snake Lemma)")[
  可換図式
  $
  cases(
    0 arrow.r A arrow.r^f B arrow.r^g C arrow.r 0,
    0 arrow.r A' arrow.r^(f') B' arrow.r^(g') C' arrow.r 0
  )
  $
  において、上下の行が完全ならば、次の長完全列が存在する：
  $ op("ker")(alpha) -> op("ker")(beta) -> op("ker")(gamma) -> op("coker")(alpha) -> op("coker")(beta) -> op("coker")(gamma) $
]

== 導来圏：ホモロジーの圏論的統一

アーベル圏における複体（chain complex）とホモロジーの理論は、*導来圏* (derived category) という概念によって圏論的に統一される。

#definition(title: "複体圏")[
  アーベル圏 $bold(A)$ 上の *複体圏* $bold(C)(bold(A))$ とは、次のデータからなる圏である：
  - 対象：複体 $(A^bullet, d^bullet)$ ただし $d^(n+1) compose d^n = 0$
  - 射：複体の射（各次数で可換な射の族）
]

複体 $A^bullet$ の $n$ 次ホモロジーは次で定義される：
$ H^n(A^bullet) = op("ker")(d^n) / op("im")(d^(n-1)) $

#definition(title: "導来圏")[
  複体圏 $bold(C)(bold(A))$ において、準同型射（ホモロジーで同型を誘導する射）を同型射として扱うことで得られる圏を *導来圏* $bold(D)(bold(A))$ と呼ぶ。
]

導来圏では、「ホモロジー的に同じ」複体が同型として扱われ、ホモロジー代数の深い構造が明らかになる。

== 三角圏：導来圏の公理的特徴づけ

導来圏の本質的な性質を抽出したのが *三角圏* (triangulated category) である。

#definition(title: "三角圏")[
  加法圏 $bold(T)$ が三角圏であるとは、次のデータと公理を持つことである：
  - *平行移動関手* $T: bold(T) -> bold(T)$
  - *識別三角* (distinguished triangles) の族
  - 三角圏の公理（回転、完備性、八面体公理）
]

識別三角は次の形を持つ：
$ X arrow.r^f Y arrow.r^g Z arrow.r^h T(X) $

ここで $g compose f = 0$ かつ $h compose g = 0$ かつ $T(f) compose h = 0$ である。

#figure(
  caption: [三角圏における基本構造の比較],
  placement: top,
  table(
    columns: (8em, auto, auto),
    align: (left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*概念*][*アーベル圏*][*三角圏*],

    [基本列],
    [短完全列 $0 -> A -> B -> C -> 0$],
    [識別三角 $A -> B -> C -> T(A)$],

    [射の分解],
    [kernel-cokernel 分解],
    [錐による分解],

    [ホモロジー],
    [直接定義],
    [コホモロジー関手として],

    [長完全列],
    [蛇の補題から],
    [三角の回転から],
  )
)

== 応用：代数的位相幾何学への橋渡し

本章で学んだ概念は、代数的位相幾何学において中心的な役割を果たす。

#example(title: "特異ホモロジー")[
  位相空間 $X$ に対し、特異単体の複体
  $ ... -> C_2(X) arrow.r^(partial_2) C_1(X) arrow.r^(partial_1) C_0(X) -> 0 $
  を考える。この複体のホモロジー $H_n(X) = op("ker")(partial_n) / op("im")(partial_(n+1))$ が特異ホモロジー群である。
]

#example(title: "層コホモロジー")[
  代数幾何学において、スキーム上の層 $cal(F)$ のコホモロジー $H^i(X, cal(F))$ は、層の導来関手として定義される。これにより、幾何学的対象の大域的性質が代数的に記述される。
]

#important-box(title: "ホモロジー代数の統一的視点")[
  本章で学んだアーベル圏・導来圏・三角圏の理論により、数学の様々な分野に現れるホモロジー的現象が統一的に理解される：
  - 代数学：群・環・加群のホモロジー
  - 幾何学：ド・ラーム コホモロジー、層コホモロジー
  - 位相幾何学：特異ホモロジー、コホモロジー
  - 代数的位相幾何学：安定ホモトピー論
]

本章を通じて、圏論が単なる抽象的枠組みではなく、現代数学の中核的な計算技法を統一する強力な言語であることが明らかになった。加法構造を持つ圏の理論は、線形代数から代数幾何学、位相幾何学に至るまで、数学の広大な領域を貫く共通原理を提供している。