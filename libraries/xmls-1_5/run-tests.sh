#!/bin/sh -x
# $Id: run-tests.sh 982 2012-08-02 02:55:34Z rpgoldman $

FORM="(xmls::test)"
SEPARATOR=""

usage () {
    cat <<USAGE
usage: run-tests.sh [options] [tests]
options: 
    --sbcl run tests with sbcl (default)
    --cmucl run tests with cmucl
    --abcl run tests with abcl
    --ccl run tests with clozure common lisp
    --allegro run tests with Allegro Common Lisp, ANSI mode
    --allegromodern run tests with Allegro Common Lisp, modern case-sensitive mode
    --all run all tests in tests directory
    --verbose output parsed xml
USAGE
    exit 1
}

command="${SBCL:-sbcl}"
CMDLINE="${command} --no-userinit --load xmls --load xmlrep-helpers --eval"
while [ $# -gt 0 ]; do 
    case $1 in
        --abcl)
            command="${ABCL:-abcl}"
            CMDLINE="${command} --noinit --noinform --load xmls --load xmlrep-helpers --eval"
            shift
            ;;
        --ccl)
            command="${CCL:-ccl}"
            CMDLINE="${command} --no-init --quiet --load xmls --load xmlrep-helpers --eval"
            SEPARATOR="--"
            shift
            ;;
        --cmucl)
            command="${CMUCL:-lisp}"
            CMDLINE="${command} -load xmls -load xmlrep-helpers -eval"
            shift
            ;;
        --allegro)
            command="${ALLEGRO:-alisp}"
            CMDLINE="${command} -q -L xmls -L xmlrep-helpers -e"
            SEPARATOR="--"
            shift
            ;;
        --allegromodern)
            command="${ALLEGROMODERN:-mlisp}"
            CMDLINE="${command} -q -L xmls -L xmlrep-helpers -e"
            SEPARATOR="--"
            shift
            ;;
        --sbcl)
            # the default...
            shift
            ;;
        --clisp)
            command="${CLISP:-clisp}"
            CMDLINE="${command} -norc -ansi -i xmls -i xmlrep-helpers -x"
            SEPARATOR="--"
            shift
            ;;
        --all)
            TESTS="tests/*/*"
            shift
            ;;
        --verbose)
            FORM="(progn (setf xmls::*test-verbose* t)(xmls::test))"
            shift
            ;;
        --help)
            usage
            ;;
        -u) 
            usage
            ;;
        *)
            TESTS="$*"
            break
            ;;
        esac
done



if test -z "$TESTS"; then
    usage
fi

$CMDLINE "$FORM" $SEPARATOR $TESTS