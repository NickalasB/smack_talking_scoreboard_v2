#!/usr/bin/env bash

# to run these run "$ sh scripts.sh test" from the command line

run_tests() {
    local dir=$(pwd)
    while read data; do
        cd "$dir/$data"
            echo "testing $data ..."
            flutter test --null-assertions
    done
    cd $dir
}

update() {
    local dir=$(pwd)
    PARALLEL=12
    while read data; do
        ((i=i%PARALLEL)); ((i++==0)) && wait
        echo "updating $data"
        cd "$dir/$data"
        flutter packages get --suppress-analytics &
    done
    wait
    cd $dir
}

clean() {
    local dir=$(pwd)
    while read data; do
        echo "cleaning $data ..."
        cd "$dir/$data"
        flutter clean
    done
    cd $dir
}

CMD_NAME=$1
if [ $CMD_NAME = 'test' ]
then
    # test is special cased because if we have a function called "test" we override the built-in bash conditional testing function and can't use it!
    CMD_NAME='run_tests'
fi
START=$(date +%s)
find . -name pubspec.yaml -print0 | xargs -0 -n1 dirname | "$CMD_NAME"
FINISH=$(date +%s)
echo "Finished in $(($FINISH - $START)) second(s)"