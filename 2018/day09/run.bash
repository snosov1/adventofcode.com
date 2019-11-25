for i in $(ls *.txt)
do
    cat $i
    rdmd day09_2.d <$i
done
