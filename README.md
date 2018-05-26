# mypassword

generate random password

```
mypassword # default: -l 8
mypassword -l 16
mypassword -l 32
```

generate password by passphrase

```
mypassword -p
```


###### Table of Contents

- [Requirements](#Requirements)
- [Usage](#Usage)
- [License](#License)

<a id="Requirements"></a>
## Requirements

- bash
- sha512sum or shasum


<a id="Usage"></a>
## Usage

```bash
mypasswrod -p
command: (sha512sum or shasum -a 512)
passphrase(1/4):
passphrase(2/4):
passphrase(3/4):
passphrase(4/4):
confirm(1/4):
confirm(2/4):
confirm(3/4):
confirm(4/4):
service: # Enter service name
stretch: # Enter start stretch (show 10 lines)
0: <password>
1: <password>
...
```

1. enter 4 word of passphrase
1. confirmation passphrase
1. enter service name
1. enter start stretch
1. then show generated password

### spec

1. create searvice name hash (with shasum)
1. re-hash stretch count
1. (int)hash + (int)character for each passphrase
1. join result as character
1. join 4 word passphrase with `=` `-` `.` `-` `=`


<a id="License"></a>
## License

mypassword is licensed under the [MIT](LICENSE) license.

Copyright &copy; since 2015 shun.fix9
