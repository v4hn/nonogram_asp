#!/bin/bash

echo "enter row blocks as"
echo "2 3 4 ..."
echo "1 ..."
echo "..."
echo "done"
echo
l=0; while read line; do [[ "$line" = "done" ]] && break; x=0; for i in $line; do echo "row($l,$x,b,$i)."; let x++; done; let l++; done > nonogram_tmp.lp
echo "row_cnt($l)." >> nonogram_tmp.lp
echo "now enter column blocks:"
l=0; while read line; do [[ "$line" = "done" ]] && break; x=0; for i in $line; do echo "col($l,$x,b,$i)."; let x++; done; let l++; done >> nonogram_tmp.lp
echo "col_cnt($l)." >> nonogram_tmp.lp

echo "notoku specification written to nonogram_tmp.lp"
echo "solving nonogram"
clingo nonogram.lp nonogram_tmp.lp --verbose=0 0 | ./visualize_nonogram.py
