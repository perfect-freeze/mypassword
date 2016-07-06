mypassword
==========

パスワード生成器

usage
-----

```bash
./bin/mypassword.sh
./bin/mypassword.sh -l 16
./bin/mypassword.sh -l 32
```

[0-9a-zA-Z] の範囲でランダムな文字列を出力する

長さは -l オプションで指定する(デフォルトは 8文字)

passphrase
----------

```bash
./bin/mypasswrod.sh -s by_passphrase
command: shasum -a 512
passphrase(1/4):
passphrase(2/4):
passphrase(3/4):
passphrase(4/4):
confirm(1/4):
confirm(2/4):
confirm(3/4):
confirm(4/4):
service: icloud
stretch: 6
password: ******
```

1. ４語のパスフレーズを入力（同じものを後からもう一度入力）
1. パスワードを使用するサービス名を入力
2. ハッシュを通す回数を入力
3. パスワードが表示されます

-l オプションでハッシュのアルゴリズムを指定可能
* sha512sum とかあればそれを使用
* もしなければ shasum があればそれを使用
* どちらもなければエラー

### 生成手順

1. サービス名をハッシュコマンドでハッシュ化（指定された回数ハッシュ化）
2. パスフレーズを１文字づつ取り出す
3. パスフレーズとハッシュの２文字を数値として合計
4. その数値を 0-9a-zA-Z(その他記号) のマップで文字に変換
5. = - . - = でパスフレーズをつなげて出力
