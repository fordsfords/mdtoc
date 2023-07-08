#!/bin/bash
# tst.sh - test the project.

ASSRT() {
  eval "test $1"

  if [ $? -ne 0 ]; then
    echo "ASSRT ERROR `basename ${BASH_SOURCE[1]}`:${BASH_LINENO[0]}, not true: '$1'" >&2
    exit 1
  fi
}  # ASSRT

rm -f x.*

cp tst1.md x.md

./mdtoc.pl x.md; ASSRT "$? -eq 0"

diff tst1.md x.md.bak >x.out; ASSRT "$? -eq 0"
diff tst1.md x.md >x.out; ASSRT "$? -ne 0"

curl -s --user-agent "mdtoc.pl v1.0" --data-binary @x.md -H "Content-Type:text/plain" https://api.github.com/markdown/raw >x.html

./tst.pl x.html


cp tst2.md x.md

./mdtoc.pl x.md; ASSRT "$? -eq 0"

diff tst2.md x.md.bak >x.out; ASSRT "$? -eq 0"
diff tst2.md x.md >x.out; ASSRT "$? -ne 0"

curl -s --user-agent "mdtoc.pl v1.0" --data-binary @x.md -H "Content-Type:text/plain" https://api.github.com/markdown/raw >x.html

./tst.pl x.html
