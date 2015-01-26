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

</dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c32; echo ""
