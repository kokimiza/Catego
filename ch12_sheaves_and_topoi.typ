#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: show-theorion
#show: codly-init.with()
#codly(languages: codly-languages)

本章では、現代数学の最も深遠で美しい理論の一つである *層理論* (Sheaf Theory) と *トポス理論* (Topos Theory) を探求する。これらの理論は、幾何学的直観を論理的・代数的構造へと昇華させ、数学基礎論から代数幾何学まで、広範囲にわたって革命的な洞察をもたらした。Grothendieck によって創始されたこの理論は、「空間」の概念を根本から再定義し、現代数学の統一的理解を可能にした。

== 前層：局所情報の収集装置

層理論の出発点は、幾何学的対象上の「局所的な情報」を系統的に扱う方法を見つけることにあった。

#definition(title: "前層 (Presheaf)")[
  位相空間 $X$ 上の *前層* $cal(F)$ とは、反変関手 $cal(F): op("Open")(X)^op -> bold("Set")$ である。ここで $op("Open")(X)$ は $X$ の開集合を対象とし、包含関係を射とする圏である。

  具体的には：
  - 各開集合 $U subset.eq X$ に対し、集合 $cal(F)(U)$ が対応
  - 包含 $V subset.eq U$ に対し、*制限写像* $rho_(U,V): cal(F)(U) -> cal(F)(V)$ が対応
  - $rho_(U,U) = id$ かつ $rho_(V,W) compose rho_(U,V) = rho_(U,W)$ （関手性）
]

#important-box(title: "前層の直観的意味")[
  前層 $cal(F)(U)$ は「開集合 $U$ 上で定義された何らかの数学的対象（関数、微分形式、ベクトル場など）の集合」と考えられる。制限写像は「大きな領域で定義された対象を、小さな部分領域に制限する操作」を抽象化している。
]

#example(title: "基本的な前層の例")[
  1. *連続関数の前層* $cal(C)$: $cal(C)(U) = {f: U -> RR | f "は連続"}$
  2. *定数前層* $underline(A)$: $underline(A)(U) = A$ （すべての開集合で同じ集合）
  3. *可微分関数の前層* $cal(C)^infinity$: $cal(C)^infinity(U) = {f: U -> RR | f "は無限回微分可能"}$
]

```haskell
-- Haskell での前層の抽象的表現
class Ord u => OpenSet u where
  contains :: u -> u -> Bool  -- 包含関係

-- 前層の型クラス
class (OpenSet u) => Presheaf f u a where
  sections :: f -> u -> [a]           -- U 上の切断
  restrict :: f -> u -> u -> a -> Maybe a  -- 制限写像
  
-- 連続関数の前層の例
data ContinuousFunctions = ContFun

instance Presheaf ContinuousFunctions OpenInterval Double where
  sections ContFun interval = undefined -- 実装は複雑
  restrict ContFun u v f 
    | v `contains` u = Just f  -- 制限は関数の定義域を狭める
    | otherwise = Nothing
```

== 層：局所-大域原理の具現化

前層に「局所的な情報から大域的な情報を復元できる」という条件を加えたものが層である。

#definition(title: "層 (Sheaf)")[
  前層 $cal(F)$ が *層* であるとは、任意の開集合 $U$ とその開被覆 ${U_i}_(i in I)$ に対して、次の二つの条件を満たすことである：

  1. *単射性* (Identity): $s, t in cal(F)(U)$ について、すべての $i$ で $s|_(U_i) = t|_(U_i)$ ならば $s = t$

  2. *貼り合わせ* (Gluing): 各 $i$ に対して $s_i in cal(F)(U_i)$ が与えられ、すべての $i, j$ で $s_i|_(U_i inter U_j) = s_j|_(U_i inter U_j)$ が成り立つとき、$s in cal(F)(U)$ が一意に存在して $s|_(U_i) = s_i$ となる
]

これらの条件は、次の完全列として表現される：

$ cal(F)(U) -> product_(i in I) cal(F)(U_i) arrow.r.double product_(i,j in I) cal(F)(U_i inter U_j) $

#figure(
  caption: [前層と層の比較],
  placement: top,
  table(
    columns: (8em, auto, auto),
    align: (left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*性質*][*前層*][*層*],

    [局所性],
    [保証されない],
    [単射性により保証],

    [貼り合わせ],
    [一般には不可能],
    [貼り合わせ条件により可能],

    [大域切断],
    [局所情報と無関係],
    [局所情報から完全に決定],

    [幾何学的意味],
    [局所データの単純な集積],
    [真の幾何学的対象],
  )
)

#theorem(title: "層化 (Sheafification)")[
  任意の前層 $cal(F)$ に対し、層 $cal(F)^+$ と前層の射 $cal(F) -> cal(F)^+$ が存在し、次の普遍性を満たす：任意の層 $cal(G)$ と前層の射 $cal(F) -> cal(G)$ に対し、一意の層の射 $cal(F)^+ -> cal(G)$ が存在して図式が可換になる。
]

#proof[
  層化は「茎」(stalk) を用いて構成される。各点 $x in X$ での茎 $cal(F)_x$ は、$x$ を含む開集合上の切断の帰納極限として定義される：
  $ cal(F)_x = op("colim")_(x in U) cal(F)(U) $
  層化された前層 $cal(F)^+(U)$ は、$U$ 上で連続な茎の切断として定義される。
]

== サイト：位相の一般化

Grothendieck の革命的洞察は、「開集合と被覆」という位相的概念を、任意の圏上で抽象化できることであった。

#definition(title: "Grothendieck サイト")[
  *Grothendieck サイト* $(bold(C), J)$ とは、圏 $bold(C)$ と *Grothendieck 位相* $J$ の組である。$J$ は各対象 $U in bold(C)$ に対し、$U$ への射の族の集合 $J(U)$ を対応させ、次の公理を満たす：

  1. *最大元*: 恒等射 ${id_U}$ は $J(U)$ に属する
  2. *安定性*: ${f_i: U_i -> U}_(i in I) in J(U)$ かつ $g: V -> U$ ならば、引き戻し ${g^* f_i: V times_U U_i -> V}_(i in I) in J(V)$
  3. *推移性*: 被覆の被覆は被覆である
]

#example(title: "重要なサイトの例")[
  1. *位相的サイト*: 位相空間の開集合の圏、開被覆
  2. *エタール サイト*: スキームのエタール射の圏、エタール被覆
  3. *ザリスキー サイト*: スキームの開埋め込みの圏、ザリスキー被覆
  4. *フラット サイト*: 平坦射による被覆
]

```haskell
-- サイトの抽象的表現
class Category c => Site c where
  type Coverage c :: * -> *
  
  -- 被覆の公理
  maximal :: c a a -> Coverage c a
  stable :: c b a -> Coverage c a -> Coverage c b
  transitive :: Coverage c a -> (forall i. Coverage c (CoverObject i)) -> Coverage c a

-- 位相空間のサイト
data TopologicalSite = TopSite

instance Site TopologicalSite where
  type Coverage TopologicalSite = OpenCovering
  
  maximal identity = SingletonCover identity
  stable morphism covering = pullbackCover morphism covering
  transitive = composeCoverings
```

== トポス：論理的宇宙としての圏

層の圏は、集合論的宇宙の一般化である *トポス* の最も重要な例である。

#definition(title: "初等トポス (Elementary Topos)")[
  圏 $bold(E)$ が *初等トポス* であるとは、次の条件を満たすことである：
  1. 有限極限を持つ
  2. 指数対象を持つ（直積閉圏）
  3. *部分対象分類子* $Omega$ を持つ

  部分対象分類子とは、対象 $Omega$ と射 $"true": 1 -> Omega$ であって、任意のモノ射 $m: A arrow.r.hook B$ に対し、一意の射 $chi_m: B -> Omega$ が存在し、次の図式が引き戻しになるものである：

  引き戻し図式：$A arrow.r.hook B arrow.r^(chi_m) Omega$ かつ $1 arrow.r^"true" Omega$

  ここで $A$ は $B$ の部分対象であり、$chi_m$ はその特性関数である。
]

#important-box(title: "部分対象分類子の意味")[
  部分対象分類子 $Omega$ は「真理値対象」として機能する。射 $chi_m: B -> Omega$ は「$x in B$ が部分対象 $A$ に属するかどうか」を判定する特性関数の一般化である。集合の圏では $Omega = {0, 1}$ だが、一般のトポスでは $Omega$ はより豊かな構造を持つ。
]

#theorem(title: "Giraud の定理")[
  圏 $bold(E)$ について、次は同値である：
  1. $bold(E)$ は Grothendieck トポス（ある小さなサイト上の層の圏）
  2. $bold(E)$ は初等トポスであり、集合による余極限を持ち、生成子を持つ
]

#figure(
  caption: [トポスの分類と性質],
  placement: top,
  table(
    columns: (8em, auto, auto, auto),
    align: (left, left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*トポス*][*部分対象分類子*][*論理*][*応用*],

    [$bold("Set")$],
    [${0, 1}$],
    [古典論理],
    [素朴集合論],

    [$bold("Sh")(X)$],
    [開集合の層],
    [局所古典論理],
    [微分幾何学],

    [$bold("Sh")(bold(C), J)$],
    [篩の層],
    [幾何学的論理],
    [代数幾何学],

    [$[bold(G), bold("Set")]$],
    [軌道空間],
    [同変論理],
    [ガロア理論],
  )
)

== 大域切断関手と点の概念

トポスにおける「点」の概念は、通常の集合論的直観を超えた豊かさを持つ。

#definition(title: "幾何学的射 (Geometric Morphism)")[
  トポス $bold(E), bold(F)$ の間の *幾何学的射* $f: bold(E) -> bold(F)$ とは、随伴対 $f^* tack f_*$ であって、$f^*: bold(F) -> bold(E)$ が有限極限を保存することをいう。
]

#definition(title: "点 (Point)")[
  トポス $bold(E)$ の *点* とは、幾何学的射 $p: bold("Set") -> bold(E)$ のことである。
]

#theorem(title: "Deligne の定理")[
  コホモロジー次元が有限の連結トポスは点を持つ。
]

この定理は、代数幾何学における重要な応用を持つ。

```haskell
-- トポスの抽象的表現
class Category e => Topos e where
  -- 部分対象分類子
  omega :: e () (TruthValue e)
  true :: e () (TruthValue e)
  
  -- 指数対象
  exponential :: e a b -> e c (Exponential e a b c)
  
  -- 特性関数
  characteristic :: Mono e a b -> e b (TruthValue e)

-- 集合のトポス
instance Topos Set where
  type TruthValue Set = Bool
  omega = const True
  true = const True
  characteristic = membershipTest

-- 層のトポス（概念的実装）
instance Topos (Sheaf X) where
  type TruthValue (Sheaf X) = OpenSetSheaf X
  omega = openSetsSheaf
  true = constantSheaf True
  characteristic = characteristicSheaf
```

== Beck–Chevalley 条件：基底変換の整合性

幾何学的射の合成において重要な役割を果たすのが Beck–Chevalley 条件である。

#theorem(title: "Beck–Chevalley 条件")[
  引き戻し図式：
  
  $bold(E') arrow.r^(g') bold(F')$ および $bold(E) arrow.r^g bold(F)$ において、
  
  $f': bold(E') -> bold(E)$ と $f: bold(F') -> bold(F)$ が縦の射であるとき、
  において、$f^* g_* approx g'_* f'^*$ が成り立つとき、この図式は Beck–Chevalley 条件を満たすという。
]

この条件は、「基底変換と直像の可換性」を表し、代数幾何学における平坦基底変換定理の圏論的一般化である。

== 内部論理：トポス内での数学

トポスの最も驚くべき性質の一つは、その内部で通常の数学を展開できることである。

#definition(title: "トポスの内部論理")[
  トポス $bold(E)$ において：
  - *命題*: 射 $phi: X -> Omega$
  - *論理結合*: $Omega$ のモノイダル構造
  - *量化*: 随伴関手による定義
  - *等式*: 対角射と部分対象分類子の合成
]

#example(title: "実数対象")[
  適切なトポスにおいて、「内部実数対象」$RR$ を定義できる。これは通常の実数とは異なる性質を持つ場合がある：
  - 直観主義的実数：すべての実数が比較可能とは限らない
  - 滑らかな実数：無限小を含む実数体系
  - $p$-進実数：$p$-進位相における完備化
]

== ガロア圏：対称性の圏論的記述

ガロア理論の圏論的定式化は、トポス理論の美しい応用例である。

#definition(title: "ガロア圏 (Galois Category)")[
  圏 $bold(C)$ が *ガロア圏* であるとは、次の条件を満たすことである：
  1. 有限極限と余極限を持つ
  2. すべての対象が有限集合の余積
  3. すべてのエピ射が分裂する
  4. 連結性条件を満たす
]

#theorem(title: "ガロア圏の基本定理")[
  ガロア圏 $bold(C)$ と「ファイバー関手」$F: bold(C) -> bold("FinSet")$ に対し、$bold(C)$ は群 $G = op("Aut")(F)$ の作用による $bold("FinSet")$ の商圏と同値である。
]

```haskell
-- ガロア圏の抽象的表現
class Category c => GaloisCategory c where
  -- 有限対象の性質
  isFinite :: c a a -> Bool
  
  -- 連結性
  isConnected :: c () a -> Bool
  
  -- 分裂エピ射
  splits :: Epi c a b -> c b a

-- ガロア群の作用
class Group g => GaloisGroup g where
  type BaseField g :: *
  type Extension g :: *
  
  action :: g -> Extension g -> Extension g
  fixedField :: [g] -> BaseField g

-- 有限ガロア拡大の例
data CyclicGroup n = CyclicGen deriving (Show, Eq)

instance GaloisGroup (CyclicGroup n) where
  type BaseField (CyclicGroup n) = Rational
  type Extension (CyclicGroup n) = AlgebraicNumber
  
  action generator x = conjugate x  -- 共役作用
  fixedField generators = intersectFields (map fixBy generators)
```

== 高次トポス理論への展望

トポス理論は、さらに高次の構造へと一般化される。

#important-box(title: "高次トポス理論の発展")[
  - *$infinity$-トポス*: 高次圏論におけるトポスの一般化
  - *導来代数幾何学*: スペクトラムのトポス
  - *ホモトピー型理論*: 型理論とトポス理論の融合
  - *量子トポス*: 量子論理のトポス的モデル

  これらの発展により、現代数学の最前線における統一的理解が進んでいる。
]

#figure(
  caption: [トポス理論の応用分野と発展],
  placement: top,
  table(
    columns: (8em, auto, auto),
    align: (left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*分野*][*トポス的概念*][*具体的応用*],

    [代数幾何学],
    [エタール トポス],
    [ガロア理論、コホモロジー],

    [微分幾何学],
    [滑らかな層],
    [微分形式、ベクトル束],

    [論理学],
    [内部論理],
    [直観主義論理、型理論],

    [計算機科学],
    [効果的トポス],
    [プログラム意味論],

    [物理学],
    [量子トポス],
    [量子論理、場の理論],
  )
)

== 層コホモロジー：大域的性質の解析

層理論の最も重要な応用の一つが、層コホモロジーによる大域的性質の研究である。

#definition(title: "層コホモロジー")[
  層 $cal(F)$ の *$n$ 次コホモロジー群* $H^n(X, cal(F))$ は、大域切断関手 $Gamma: bold("Sh")(X) -> bold("Ab")$ の $n$ 次右導来関手として定義される：
  $ H^n(X, cal(F)) = R^n Gamma(cal(F)) $
]

これにより、局所的には自明でも大域的には非自明な現象を捉えることができる。

#example(title: "リーマン面上の正則関数")[
  コンパクトリーマン面 $X$ 上で、$H^0(X, cal(O)) = CC$（定数関数のみ）だが、$H^1(X, cal(O)) != 0$ となり、これが $X$ の種数と関係する。
]

本章を通じて、層とトポスの理論が現代数学の統一的理解にいかに貢献しているかを見てきた。Grothendieck の革命的洞察により、幾何学、代数学、論理学が一つの枠組みの中で理解され、数学の新たな地平が開かれた。この理論は今なお発展を続け、21世紀の数学における中核的な役割を果たし続けている。