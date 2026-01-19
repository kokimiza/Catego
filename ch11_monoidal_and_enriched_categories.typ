#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: show-theorion
#show: codly-init.with()
#codly(languages: codly-languages)

これまでの章では、圏における「積」や「余積」を学んできたが、これらは特定の普遍性によって特徴づけられる特別な構造であった。本章では、より一般的な「テンソル積」の概念を導入し、*モノイダル圏* (Monoidal Category) という豊かな構造を探求する。さらに、Hom 集合を他の圏の対象に置き換えた *豊穣圏* (Enriched Category) の理論を展開し、現代数学における応用を見ていく。

== モノイダル圏：テンソル積の抽象化

線形代数におけるテンソル積 $V times.o.big W$ や、集合の直積 $X times Y$ は、二つの対象を「組み合わせる」操作の具体例である。これらを統一的に扱うのがモノイダル圏の概念である。

#definition(title: "モノイダル圏 (Monoidal Category)")[
  圏 $bold(C)$ が *モノイダル圏* であるとは、次のデータを持つことである：
  - *テンソル積関手* $times.o.big: bold(C) times bold(C) -> bold(C)$
  - *単位対象* $I in op("ob")(bold(C))$
  - *結合子* (associator) $alpha: (X times.o.big Y) times.o.big Z -> X times.o.big (Y times.o.big Z)$
  - *左単位子* $lambda: I times.o.big X -> X$
  - *右単位子* $rho: X times.o.big I -> X$

  これらは次の *コヒーレンス条件* を満たす：
  1. *五角形等式* (Pentagon Identity)
  2. *三角形等式* (Triangle Identity)
]

#important-box(title: "コヒーレンス条件の意味")[
  コヒーレンス条件は、「異なる方法で結合や単位を適用しても、最終的に同じ結果になる」ことを保証する。これにより、テンソル積の計算において「括弧の付け方」や「単位元の挿入位置」を気にする必要がなくなる。
]

=== 五角形等式と三角形等式

五角形等式は、4つの対象のテンソル積における結合の一貫性を保証する：

$
((W times.o.big X) times.o.big Y) times.o.big Z arrow.r^(alpha times.o.big id) (W times.o.big X) times.o.big (Y times.o.big Z) arrow.r^alpha W times.o.big (X times.o.big (Y times.o.big Z))
$

$
(W times.o.big (X times.o.big Y)) times.o.big Z arrow.r^alpha W times.o.big ((X times.o.big Y) times.o.big Z) arrow.r^(id times.o.big alpha) W times.o.big (X times.o.big (Y times.o.big Z))
$

三角形等式は、結合子と単位子の整合性を表す：

$
(X times.o.big I) times.o.big Y arrow.r^alpha X times.o.big (I times.o.big Y) arrow.r^(id times.o.big lambda) X times.o.big Y
$

$
(X times.o.big I) times.o.big Y arrow.r^(rho times.o.big id) X times.o.big Y
$

#figure(
  caption: [モノイダル圏の基本例],
  placement: top,
  table(
    columns: (8em, auto, auto, auto),
    align: (left, left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*圏*][*テンソル積*][*単位対象*][*応用分野*],

    [$bold("Set")$],
    [直積 $times$],
    [1点集合],
    [組み合わせ論],

    [$bold("Vect")_k$],
    [テンソル積 $times.o.big$],
    [体 $k$],
    [線形代数],

    [$bold("Ab")$],
    [テンソル積 $times.o.big_ZZ$],
    [整数環 $ZZ$],
    [代数学],

    [$bold("Top")$],
    [直積 $times$],
    [1点空間],
    [位相幾何学],
  )
)

== 対称モノイダル圏：交換可能性

多くの具体的なモノイダル圏では、$X times.o.big Y$ と $Y times.o.big X$ が自然に同型である。この性質を抽象化したのが対称モノイダル圏である。

#definition(title: "対称モノイダル圏 (Symmetric Monoidal Category)")[
  モノイダル圏 $bold(C)$ が *対称* であるとは、自然同型 $sigma: X times.o.big Y -> Y times.o.big X$（*ブレイディング* (braiding)）が存在し、次の条件を満たすことである：
  1. $sigma compose sigma = id$ （対合性）
  2. 結合子との整合性（六角形等式）
]

Haskell では、対称モノイダル圏の構造を型クラスとして表現できる：

```haskell
-- モノイダル圏の抽象化
class Functor f => Monoidal f where
    unit  :: f ()                    -- 単位対象
    (⊗)   :: f a -> f b -> f (a, b)  -- テンソル積

-- 対称性
swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

-- 具体例：Maybe モナド
instance Monoidal Maybe where
    unit = Just ()
    Nothing ⊗ _ = Nothing
    _ ⊗ Nothing = Nothing
    (Just x) ⊗ (Just y) = Just (x, y)

-- リストモナド
instance Monoidal [] where
    unit = [()]
    xs ⊗ ys = [(x, y) | x <- xs, y <- ys]
```

== 閉モノイダル圏：内部 Hom の存在

テンソル積に対する「指数対象」が存在するモノイダル圏を閉モノイダル圏と呼ぶ。

#definition(title: "閉モノイダル圏 (Closed Monoidal Category)")[
  モノイダル圏 $bold(C)$ が *閉* であるとは、任意の対象 $Y$ に対して、関手 $- times.o.big Y: bold(C) -> bold(C)$ が右随伴を持つことである。この右随伴を $[Y, -]: bold(C) -> bold(C)$ と表記し、*内部 Hom* と呼ぶ。
]

随伴関係は次のように表される：
$ op("hom")(X times.o.big Y, Z) approx op("hom")(X, [Y, Z]) $

この同型は *カリー化* (currying) として知られ、関数型プログラミングの基礎となる。

```haskell
-- Haskell における閉モノイダル圏の例
-- 型の圏 Hask は閉モノイダル圏

-- テンソル積：タプル (,)
-- 単位対象：() 
-- 内部 Hom：関数型 (->)

-- カリー化
curry :: ((a, b) -> c) -> (a -> b -> c)
curry f x y = f (x, y)

-- 逆カリー化
uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry f (x, y) = f x y

-- 随伴の単位と余単位
eval :: (a -> b, a) -> b
eval (f, x) = f x

-- 使用例：部分適用
add :: Int -> Int -> Int
add x y = x + y

addFive :: Int -> Int
addFive = add 5  -- カリー化により部分適用が可能
```

== コヒーレンス定理：Mac Lane の定理

モノイダル圏における最も深い結果の一つが、Mac Lane のコヒーレンス定理である。

#theorem(title: "Mac Lane のコヒーレンス定理")[
  モノイダル圏において、結合子と単位子のみを用いて構成される任意の二つの射が等しいならば、それらは実際に等しい。すなわち、「自由モノイダル圏」では、すべての等式が五角形等式と三角形等式から導かれる。
]

#proof[
  証明の概略：任意の射を「標準形」に変換する書き換え規則を定義し、この標準形が一意であることを示す。五角形等式と三角形等式により、異なる書き換え経路が同じ結果に収束することが保証される。
]

#tip-box(title: "コヒーレンス定理の実用的意味")[
  この定理により、モノイダル圏での計算において「括弧の付け方を気にしなくてよい」ことが数学的に保証される。プログラミング言語の設計において、結合律や単位律を満たす演算子の実装が一意に定まることの理論的根拠となる。
]

== 線形論理との関係

モノイダル圏の理論は、Girard の線形論理と深い関係がある。

#figure(
  caption: [線形論理とモノイダル圏の対応],
  placement: top,
  table(
    columns: (8em, auto, auto),
    align: (left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*線形論理*][*モノイダル圏*][*直観的意味*],

    [乗法的連言 $A times.o.big B$],
    [テンソル積 $A times.o.big B$],
    [同時に使用可能なリソース],

    [乗法的単位 $1$],
    [単位対象 $I$],
    [空のリソース],

    [線形含意 $A multimap B$],
    [内部 Hom $[A, B]$],
    [$A$ を消費して $B$ を生産],

    [指数 $!A$],
    [余モナド構造],
    [複製可能なリソース],
  )
)

この対応により、計算の「リソース使用」を数学的に記述できる：

```haskell
-- 線形型システムの Haskell での近似
-- (実際の線形型は Rust や Linear Haskell で実現)

-- リソースを一度だけ使用する関数
useOnce :: a -> b
useOnce x = ... -- x は一度だけ参照される

-- テンソル積：両方のリソースが必要
both :: (a, b) -> c
both (x, y) = ... -- x と y を両方使用

-- 線形含意：リソースの変換
transform :: a -> b  -- a を消費して b を生産
transform x = ...
```

== 豊穣圏：Hom 集合の一般化

通常の圏では、Hom 集合 $op("hom")(X, Y)$ は単なる集合である。豊穣圏では、これを任意のモノイダル圏の対象に置き換える。

#definition(title: "V-豊穣圏 (V-Enriched Category)")[
  モノイダル圏 $bold(V)$ に対し、*$bold(V)$-豊穣圏* $bold(C)$ とは次のデータからなる：
  - 対象の集まり $op("ob")(bold(C))$
  - 各 $X, Y in op("ob")(bold(C))$ に対する $bold(V)$ の対象 $bold(C)(X, Y)$
  - 合成射 $bold(C)(Y, Z) times.o.big bold(C)(X, Y) -> bold(C)(X, Z)$ in $bold(V)$
  - 恒等射 $I -> bold(C)(X, X)$ in $bold(V)$

  これらは結合律と単位律を満たす。
]

#example(title: "豊穣圏の具体例")[
  1. *距離空間*: $bold(V) = ([0, infinity], +, 0)$ として、$bold(C)(X, Y) = d(X, Y)$ とする
  2. *順序豊穣圏*: $bold(V) = ({0, 1}, and, 1)$ として、$bold(C)(X, Y) = 1$ iff $X <= Y$
  3. *確率的圏*: $bold(V) = ([0, 1], times, 1)$ として、$bold(C)(X, Y)$ を遷移確率とする
]

```haskell
-- 距離空間の豊穣圏をHaskellで表現
newtype Distance = Distance Double
  deriving (Show, Eq, Ord)

-- モノイダル構造：距離の加算
instance Semigroup Distance where
  (Distance x) <> (Distance y) = Distance (x + y)

instance Monoid Distance where
  mempty = Distance 0

-- 距離豊穣圏
class DistanceEnriched a where
  distance :: a -> a -> Distance

-- 例：ユークリッド空間
instance DistanceEnriched (Double, Double) where
  distance (x1, y1) (x2, y2) = 
    Distance $ sqrt ((x2-x1)^2 + (y2-y1)^2)

-- 合成：三角不等式により well-defined
compose :: DistanceEnriched a => a -> a -> a -> Distance
compose x y z = distance x y <> distance y z
```

== 豊穣関手と豊穣自然変換

豊穣圏の間の構造保存写像を定義する。

#definition(title: "豊穣関手 (Enriched Functor)")[
  $bold(V)$-豊穣圏 $bold(C), bold(D)$ の間の *豊穣関手* $F: bold(C) -> bold(D)$ とは：
  - 対象の対応 $F: op("ob")(bold(C)) -> op("ob")(bold(D))$
  - 各 $X, Y$ に対する $bold(V)$ の射 $F_(X,Y): bold(C)(X, Y) -> bold(D)(F X, F Y)$

  これらは合成と恒等を保存する。
]

#theorem(title: "豊穣米田の補題")[
  $bold(V)$-豊穣圏 $bold(C)$ と $bold(V)$-関手 $F: bold(C) -> bold(V)$ に対し、次の自然同型が存在する：
  $ op("Nat")_bold(V)(bold(C)(A, -), F) approx F(A) $
  ここで左辺は豊穣自然変換の集合である。
]

この一般化により、通常の米田の補題（第5章）が豊穣設定でも成り立つことが分かる。

== 応用：量子圏論と情報理論

豊穣圏の理論は、現代の量子情報理論や計算機科学に重要な応用を持つ。

#example(title: "量子圏論")[
  複素ヒルベルト空間の圏において、$bold(C)(H_1, H_2) = B(H_1, H_2)$（有界線形作用素の空間）とする豊穣構造を考える。これにより、量子状態の進化や量子もつれが圏論的に記述される。
]

```haskell
-- 確率的プログラミングの豊穣圏的モデル
newtype Probability = Prob Double
  deriving (Show, Eq, Ord)

-- 確率の乗法的モノイド
instance Semigroup Probability where
  (Prob x) <> (Prob y) = Prob (x * y)

instance Monoid Probability where
  mempty = Prob 1.0

-- 確率的遷移系
class Stochastic s where
  transition :: s -> s -> Probability

-- マルコフ連鎖の例
data Weather = Sunny | Rainy deriving (Show, Eq)

instance Stochastic Weather where
  transition Sunny Sunny = Prob 0.8
  transition Sunny Rainy = Prob 0.2
  transition Rainy Sunny = Prob 0.3
  transition Rainy Rainy = Prob 0.7

-- 多段階遷移の合成
multiStep :: Stochastic s => s -> s -> s -> Probability
multiStep x y z = transition x y <> transition y z
```

== 高次圏論への展望

豊穣圏の理論は、さらに高次の構造へと一般化される。

#important-box(title: "豊穣圏から高次圏論へ")[
  - *2-豊穣圏*: Hom 対象が圏である豊穣圏
  - *∞-豊穣圏*: Hom 対象が ∞-群胞体である豊穣圏
  - *導来豊穣圏*: ホモトピー論的な豊穣構造

  これらの発展により、現代の代数的位相幾何学や高次圏論の基礎が築かれている。
]

#figure(
  caption: [豊穣圏の階層と応用分野],
  placement: top,
  table(
    columns: (8em, auto, auto),
    align: (left, left, left),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[*豊穣の種類*][*Hom 対象*][*応用分野*],

    [集合豊穣],
    [集合],
    [古典的圏論],

    [位相豊穣],
    [位相空間],
    [関数解析],

    [順序豊穣],
    [順序集合],
    [計算機科学],

    [確率豊穣],
    [確率分布],
    [機械学習],

    [2-豊穣],
    [圏],
    [高次圏論],
  )
)

本章を通じて、モノイダル圏と豊穣圏の理論が、古典的な圏論を大幅に拡張し、現代数学の様々な分野に深い洞察をもたらすことを見てきた。テンソル積の抽象化から始まり、線形論理、量子情報理論、高次圏論まで、その応用範囲は驚くほど広い。これらの概念は、21世紀の数学と計算機科学における中核的な道具として、今後ますます重要性を増していくであろう。