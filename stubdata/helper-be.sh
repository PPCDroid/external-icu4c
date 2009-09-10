#!/bin/bash
export DYLD_LIBRARY_PATH=/Users/malfet/android/icu4c/lib
export TOOLS=/Users/malfet/android/icu4c/bin
export WHICH=$1

if [ "$WHICH" == "" ]; then
    echo "Usage: ./helper <config name>"
    exit
fi;

if [ ! -d "cfg-$WHICH" ]; then
    echo "Configuration $WHICH does not exist."
    exit
fi;

cp cfg-$WHICH/icudt38l/res_index.txt icudt38b
cp cfg-$WHICH/icudt38l/brkitr/res_index.txt icudt38b/brkitr
cp cfg-$WHICH/icudt38l/coll/res_index.txt icudt38b/coll
cp cfg-$WHICH/icudt38l/rbnf/res_index.txt icudt38b/rbnf

echo "Compiling (possibly modified) source files into binaries..."
cd icudt38b
$TOOLS/gencnval convrtrs.txt
$TOOLS/genrb res_index.txt
cd ..

cd icudt38b/brkitr
$TOOLS/genrb res_index.txt
cd ../..

cd icudt38b/coll
$TOOLS/genrb res_index.txt
cd ../..

cd icudt38b/rbnf
$TOOLS/genrb res_index.txt
cd ../..

echo "Creating ICU data file..."
$TOOLS/icupkg -tb -s icudt38b -a cfg-$WHICH/icudt38l.txt new icudt38b.dat
cp icudt38b.dat icudt38b-$WHICH.dat
rm icudt38b.dat

echo "Finished."
