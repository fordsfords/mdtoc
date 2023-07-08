#!/bin/bash
# tst.sh - test the project.

ASSRT() {
  eval "test $1"

  if [ $? -ne 0 ]; then
    echo "ASSRT ERROR `basename ${BASH_SOURCE[1]}`:${BASH_LINENO[0]}, not true: '$1'" >&2
    exit 1
  fi
  test_num=`expr $test_num + 1`
  echo "Test $test_num: passed"
}  # ASSRT

test_num=0

#################################
#################################
#################################
# Test case: missing "<!-- mdtoc-start -->".

rm -f x.*
cp tst0.md x.md

./mdtoc.pl x.md >/dev/null 2>x.err; ASSRT "$? -ne 0"
egrep "Could not find '<!-- mdtoc-start -->'" x.err >/dev/null; ASSRT "$? -eq 0"

#################################
# Test case: normal indentation sequences.

rm -f x.*
cp tst1.md x.md

./mdtoc.pl x.md; ASSRT "$? -eq 0"
test -f x.md.bak; ASSRT "$? -eq 0"

diff tst1.md x.md.bak >x.out; ASSRT "$? -eq 0"
diff tst1.md x.md >x.out; ASSRT "$? -ne 0"

curl -s --user-agent "mdtoc.pl v1.0" --data-binary @x.md -H "Content-Type:text/plain" https://api.github.com/markdown/raw >x.html
./tst.pl x.html; ASSRT "$? -eq 0"

#################################
# Test case: abnormal indentation sequences.

rm -f x.*
cp tst2.md x.md

./mdtoc.pl -b "" x.md; ASSRT "$? -eq 0"
test -f x.md.bak; ASSRT "$? -ne 0"

diff tst2.md x.md >x.out; ASSRT "$? -ne 0"

curl -s --user-agent "mdtoc.pl v1.0" --data-binary @x.md -H "Content-Type:text/plain" https://api.github.com/markdown/raw >x.html
./tst.pl x.html; ASSRT "$? -eq 0"

#################################
# Test case: stdin/stdout

rm -f x.*
cp tst1.md x.md

./mdtoc.pl <x.md >x.x; ASSRT "$? -eq 0"

diff tst1.md x.md >x.out; ASSRT "$? -eq 0"

curl -s --user-agent "mdtoc.pl v1.0" --data-binary @x.x -H "Content-Type:text/plain" https://api.github.com/markdown/raw >x.html
./tst.pl x.html; ASSRT "$? -eq 0"

#################################
#################################
#################################

echo "Success: $test_num tests passed."
