#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: show-theorion
#show: codly-init.with()
#codly(languages: codly-languages)

前章までで、圏論の基本的な枠組みと構造を理解した。本章では、その集大成として *モナド* (Monad) という概念を導入する。モナドは、随伴関手から自然に生まれる構造であり、現代の計算機科学、特に関数型プログラミングにおいて革命的な役割を果たしている。抽象的な圏論の概念が、いかに具体的で実用的な道具となるかを、Haskell のコード例とともに体感していこう。

== モナドの誕生：随伴から生まれる構造

第7章で学んだ随伴関手 $F tack G$ を思い出そう。この随伴から、合成関手 $T = G compose F$ と二つの自然変換 $eta: 1 -> T$（単位）、$mu: T^2 -> T$（余単位から導かれる）が自然に生まれる。

#definition(title: "モナド (Monad)")[
  圏 $bold(C)$ 上のモナドとは、三つ組 $(T, eta, mu)$ である：
  - $T: bold(C) -> bold(C)$ は自己関手
  - $eta: 1_bold(C) -> T$ は単位 (unit)
  - $mu: T compose T -> T$ は乗法 (multiplication)

  これらは次の *モナド法則* を満たす：
  1. *結合律*: $mu compose T mu = mu compose mu T$
  2. *単位律*: $mu compose eta T = id_T = mu compose T eta$
]

#important-box(title: "モナドの直観")[
  モナドは「計算の文脈」を抽象化したものである。$T(X)$ は「型 $X$ の値を、何らかの文脈（エラー、非決定性、状態など）の中で扱う」ことを表現する。
  - $eta$: 純粋な値を文脈に持ち上げる
  - $mu$: 二重に包まれた文脈を平坦化する
]

== Haskell におけるモナドの実装

抽象的な定義を具体的なコードで理解しよう。Haskell では、モナドは型クラスとして実装される。

```haskell
class Functor m => Monad m where
    return :: a -> m a           -- 単位 η
    (>>=)  :: m a -> (a -> m b) -> m b  -- bind演算子
    
    -- 乗法 μ は bind から導かれる
    join   :: m (m a) -> m a
    join x = x >>= id
```

#remark[
  Haskell の `>>=`（bind）は、圏論の $mu$ を Kleisli 合成の形で表現したものである。`return` は単位 $eta$ に対応する。
]

=== Maybe モナド：失敗の可能性

最もシンプルなモナドの例として、「失敗するかもしれない計算」を表現する Maybe モナドを見てみよう。

```haskell
data Maybe a = Nothing | Just a

instance Monad Maybe where
    return x = Just x
    
    Nothing  >>= _ = Nothing
    (Just x) >>= f = f x

-- 使用例：安全な除算
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide x y = Just (x / y)

-- モナドの合成により、エラー処理が自動化される
computation :: Double -> Double -> Double -> Maybe Double
computation x y z = do
    a <- safeDivide x y
    b <- safeDivide a z
    return (b * 2)
```

#tip-box(title: "モナドの威力")[
  Maybe モナドにより、「途中でエラーが起きたら即座に計算を中断する」という制御フローが、明示的な if-then-else 文なしに自動化される。これは圏論的な構造（モナド法則）が保証する「合成の一貫性」の恩恵である。
]

== List モナド：非決定性計算

非決定性（複数の結果を持つ計算）もモナドとして美しく表現できる。

```haskell
instance Monad [] where
    return x = [x]
    xs >>= f = concat (map f xs)

-- 使用例：非決定的な選択
choose :: [a] -> [a]
choose xs = xs

-- すべての組み合わせを生成
pairs :: [Int] -> [Int] -> [(Int, Int)]
pairs xs ys = do
    x <- xs
    y <- ys
    return (x, y)

-- pairs [1,2] [3,4] = [(1,3), (1,4), (2,3), (2,4)]
```

== IO モナド：副作用の制御

Haskell における IO モナドは、純粋関数型言語で副作用を安全に扱うための仕組みである。

```haskell
-- IO モナドの使用例
main :: IO ()
main = do
    putStrLn "名前を入力してください："
    name <- getLine
    putStrLn ("こんにちは、" ++ name ++ "さん！")
    
-- モナド法則により、IO 操作の順序が保証される
```

#footnote[
  IO モナドの実装は言語処理系の内部に隠されているが、概念的には「現実世界の状態」を表現する State モナドの特殊例として理解できる。
]

== Kleisli 圏：モナドが作る新しい世界

モナド $(T, eta, mu)$ が与えられると、元の圏 $bold(C)$ から新しい圏 *Kleisli 圏* $bold(C)_T$ を構成できる。

#definition(title: "Kleisli 圏")[
  モナド $(T, eta, mu)$ に対する Kleisli 圏 $bold(C)_T$ は次のように定義される：
  - 対象：$bold(C)$ と同じ
  - 射：$f: X -> Y$ in $bold(C)_T$ は、$f: X -> T(Y)$ in $bold(C)$ として表現
  - 合成：$g compose_T f = mu_Z compose T(g) compose f$
  - 恒等射：$eta_X: X -> T(X)$
]

Haskell の文脈では、Kleisli 射は「モナド値を返す関数」に対応する：

```haskell
-- Kleisli 射の例
safeHead :: [a] -> Maybe a
safeHead []     = Nothing
safeHead (x:_)  = Just x

safeTail :: [a] -> Maybe [a]
safeTail []     = Nothing
safeTail (_:xs) = Just xs

-- Kleisli 合成 (>=>)
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g = \x -> f x >>= g

-- 合成例
safeSecond :: [a] -> Maybe a
safeSecond = safeTail >=> safeHead
```

== Eilenberg–Moore 圏：代数的構造としてのモナド

モナドのもう一つの重要な視点は、*代数的構造* としての理解である。

#definition(title: "T-代数")[
  モナド $(T, eta, mu)$ に対し、*$T$-代数* とは対象 $X$ と射 $alpha: T(X) -> X$ の組 $(X, alpha)$ であり、次の条件を満たす：
  1. $alpha compose eta_X = id_X$
  2. $alpha compose T(alpha) = alpha compose mu_X$
]

#definition(title: "Eilenberg–Moore 圏")[
  $T$-代数を対象とし、$T$-代数の準同型を射とする圏を *Eilenberg–Moore 圏* $bold(C)^T$ と呼ぶ。
]

#example(title: "リストモナドの代数")[
  リストモナド `[]` に対する代数は、「リストを畳み込む操作」に対応する：
  
  ```haskell
  -- T-代数の例：リストの和
  sumAlgebra :: [Int] -> Int
  sumAlgebra = foldr (+) 0
  
  -- モナド法則の確認
  -- sumAlgebra . return = id
  -- sumAlgebra . join = sumAlgebra . fmap sumAlgebra
  ```
]

== Beck のモナド性定理：随伴の特徴づけ

モナドと随伴関手の関係を明確にする重要な定理がある。

#theorem(title: "Beck のモナド性定理")[
  関手 $G: bold(D) -> bold(C)$ について、次は同値である：
  1. $G$ が左随伴を持つ
  2. $G$ がある圏からの Eilenberg–Moore 圏への比較関手として表現される
  3. $G$ が反射的余等化子を保存し、$G$ から生じるモナドに対する Beck 条件を満たす
]

この定理により、「どの関手が随伴を持つか」という問題が、モナドの言葉で特徴づけられる。

== Applicative 関手：モナドの弱い版

モナドよりも弱い構造として、*Applicative 関手* がある。これは関数型プログラミングにおいて重要な役割を果たす。

```haskell
class Functor f => Applicative f where
    pure  :: a -> f a                    -- 単位
    (<*>) :: f (a -> b) -> f a -> f b    -- 適用

-- Maybe の Applicative インスタンス
instance Applicative Maybe where
    pure = Just
    Nothing <*> _ = Nothing
    (Just f) <*> x = fmap f x

-- 使用例：複数の Maybe 値の組み合わせ
addThree :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int
addThree x y z = pure (\a b c -> a + b + c) <*> x <*> y <*> z

-- addThree (Just 1) (Just 2) (Just 3) = Just 6
-- addThree (Just 1) Nothing (Just 3) = Nothing
```

#important-box(title: "Applicative vs Monad")[
  - *Applicative*: 固定された「形」の計算を並列実行できる
  - *Monad*: 前の結果に依存して次の計算を決められる（逐次実行）
  
  すべてのモナドは Applicative だが、逆は成り立たない。Applicative の方が制約が弱い分、より多くの最適化が可能である。
]

== モナド変換子：効果の合成

実際のプログラミングでは、複数の効果（エラー処理 + 状態 + IO など）を組み合わせる必要がある。これを実現するのが *モナド変換子* である。

```haskell
-- StateT モナド変換子
newtype StateT s m a = StateT { runStateT :: s -> m (a, s) }

instance Monad m => Monad (StateT s m) where
    return x = StateT $ \s -> return (x, s)
    m >>= k = StateT $ \s -> do
        (a, s') <- runStateT m s
        runStateT (k a) s'

-- 使用例：状態 + IO
type Counter = StateT Int IO

increment :: Counter ()
increment = do
    count <- get
    put (count + 1)
    liftIO $ putStrLn $ "Count: " ++ show (count + 1)
```

#remark(title: "圏論的背景")[
  モナド変換子は、モナドの *分配法則* (distributive law) の概念と深く関連している。二つのモナド $S, T$ の間に適切な分配法則があるとき、それらの合成 $S compose T$ もモナドになる。
]

== モナドの哲学：計算の本質

モナドが革命的である理由は、「計算とは何か」という根本的な問いに対する新しい答えを提示したことにある。

#tip-box(title: "計算の三つの側面")[
  1. *純粋な計算*: 数学的関数（入力→出力）
  2. *文脈を持つ計算*: モナド（入力→文脈付き出力）
  3. *計算の合成*: モナド法則（文脈の一貫した伝播）
]

従来のプログラミングでは、副作用や例外処理は「言語の機能」として ad hoc に実装されていた。しかし、モナドにより、これらすべてが統一的な数学的枠組みの中で理解できるようになった。

#footnote[
  この洞察は、Eugenio Moggi の「Notions of Computation and Monads」（1991年）によって計算機科学にもたらされ、Philip Wadler らによって Haskell に実装された。圏論の抽象的な概念が、実用的なプログラミング言語の設計に直接応用された稀有な例である。
]

== コモナド：双対の世界

モナドの双対概念として *コモナド* (Comonad) がある。

#definition(title: "コモナド")[
  コモナド $(W, epsilon, delta)$ は次からなる：
  - $W: bold(C) -> bold(C)$ は自己関手
  - $epsilon: W -> 1_bold(C)$ は余単位 (counit)
  - $delta: W -> W compose W$ は余乗法 (comultiplication)
]

```haskell
class Functor w => Comonad w where
    extract   :: w a -> a              -- 余単位 ε
    duplicate :: w a -> w (w a)        -- 余乗法 δ
    extend    :: (w a -> b) -> w a -> w b

-- 使用例：無限ストリーム
data Stream a = Cons a (Stream a)

instance Comonad Stream where
    extract (Cons x _) = x
    duplicate s@(Cons _ xs) = Cons s (duplicate xs)
```

コモナドは「文脈から値を取り出す」操作を抽象化し、データフロープログラミングや並列計算において重要な役割を果たす。

#remark(title: "モナドとコモナドの対比")[
  - *モナド*: 値を文脈に入れる（`return`）、文脈を平坦化する（`join`）
  - *コモナド*: 文脈から値を取り出す（`extract`）、文脈を複製する（`duplicate`）
  
  この双対性は、圏論における一般的な双対原理の具体例である。
]

本章を通じて、抽象的な圏論の概念が、いかに具体的で実用的な計算の道具となるかを見てきた。モナドは単なる数学的好奇心ではなく、現代のソフトウェア開発における中核的な概念として、日々無数のプログラムの中で活躍している。圏論と計算機科学の美しい融合の象徴と言えるだろう。