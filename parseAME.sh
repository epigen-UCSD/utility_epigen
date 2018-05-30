
allres="ame.all.res.txt"
>$allres

find . -name "*ame.txt"| while read res
do
    c=$(echo $res | perl -ne '/\/(.*)\// && print "$1"')
    perl -ne '/(MA(\d+.\d))\s+(.*)\s+\(([A-Z]+)\)(.*)(\(Corrected p-values: (.*)\))/ && print "$1\t$3\t$4\t$6\n"' $res |\
        awk -v OFS='\t' -v clust=$c '{print $1,$2,$3,$7,clust}' >> $allres
done

