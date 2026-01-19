#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#show: show-theorion

圏と圏の間の「構造を保つ写像」である関手を定義し、その諸性質を俯瞰する。

== 関手の定義

#definition(title: "関手 (Functor)")[
  圏 $bold(C)$ から圏 $bold(D)$ への *共変関手* (covariant functor) $F: bold(C) -> bold(D)$ とは、以下の対応からなる：

  - 任意のオブジェクト $X in bold(C)$ に対し、オブジェクト $F(X) in bold(D)$ を割り当てる。
  - 任意の射 $f: X -> Y in bold(C)$ に対し、射 $F(f): F(X) -> F(Y) in bold(D)$ を割り当てる。

  これらは以下の公理（構造の保存）を満たす必要がある：
  + *恒等射の保存*: 任意の $X in bold(C)$ に対して $F(id_X) = id_(F(X))$
  + *合成の保存*: 任意の合成可能な射 $f, g in bold(C)$ に対して $F(g compose f) = F(g) compose F(f)$
]

== 共変／反変

射の向きを逆転させる関手を反変関手と呼ぶ。これは双対圏からの共変関手としてスマートに記述できる。

#lemma(title: "反変関手の性質")[
  反変関手 $F: bold(C) -> bold(D)$ は、合成の順序を入れ替える：
  $ F(g compose f) = F(f) compose F(g) $
  これは共変関手 $F: bold(C)^op -> bold(D)$ と本質的に等価である。
]

== 恒等関手と合成

#theorem(title: "関手の合成")[
  関手 $F: bold(C) -> bold(D)$ と $G: bold(D) -> bold(E)$ が存在するとき、その合成 $G compose F: bold(C) -> bold(E)$ もまた関手となる。
]

関手の合成は結合律を満たし、各圏 $bold(C)$ に対して恒等関手 $1_bold(C)$ が存在することから、*「圏を対象とし、関手を射とする圏」* $bold("Cat")$ が構成される。

== 忘却関手

#definition(title: "忘却関手 (Forgetful Functor)")[
  群の圏 $bold("Grp")$ から集合の圏 $bold("Set")$ への関手のように、代数的な構造（演算や単位元）を「忘れて」台集合のみを取り出す関手を $U$ (Underlying/Utile) と表記し、忘却関手と呼ぶ。
]

忘却関手は情報を捨てる操作だが、数学的には非常に重要な役割（随伴対の片割れ）を担うことが多い。

== 忠実充満

関手が「射の集合（Hom集合）」に対してどのような写像になっているかに注目する。

#definition(title: "忠実・充満")[
  関手 $F: bold(C) -> bold(D)$ が誘導する写像 $F_(X,Y): "Hom"_bold(C)(X, Y) -> "Hom"_bold(D)(F X, F Y)$ について：
  - これが *単射* であるとき、$F$ は *忠実* (faithful) であるという。
  - これが *全射* であるとき、$F$ は *充満* (full) であるという。
  - 双射（全単射）であるとき、*忠実充満* (fully faithful) であるという。
]

== 埋め込み関手

#theorem(title: "埋め込み (Embedding)")[
  関手 $F: bold(C) -> bold(D)$ が忠実充満であり、かつオブジェクトレベルで単射であるとき、これを *埋め込み* と呼ぶ。
  これにより、$bold(C)$ は $bold(D)$ の充満部分圏として「再現」される。
]

#proof[
  忠実充満関手は、$bold(C)$ における射の構造を $bold(D)$ の中で完全に保存するため、$bold(C)$ の性質を $bold(D)$ の中で調べることを可能にする。
]