#!/bin/sh

# Restore deleted files
git checkout $(git ls-files -d)

python python/site.py

CHANGES=`git whatchanged --since="3 days ago" -p pubs/ src_docs/`

rm python/*.pyc

cp style.css ~/public_html/

rm -rf ~/public_html/teaching/*
for CLASS in LBSC_690_2012 INFM_718_2011 COS_280_2008 CMSC_773_2012 DATA_DIGGING CMSC_723_2013 CSCI_5832 DEEP
        do
           mkdir -p ~/public_html/teaching/$CLASS
           cp teaching/$CLASS/*.* ~/public_html/teaching/$CLASS
	   for SUBDIR in slides reading
	   do
               if [ -d teaching/$CLASS/$SUBDIR ]
                   then
                     mkdir -p ~/public_html/teaching/$CLASS/$SUBDIR
	             cp teaching/$CLASS/$SUBDIR/*.* ~/public_html/teaching/$CLASS/$SUBDIR
               fi
	   done
done

if [ ${#CHANGES} -gt 0 ]
   then
        echo "CHANGES DETECTED!"
        for FILE in `ls pubs/*.tex`
        do
            pdflatex $FILE; rm $FILE
        done
fi
rm *.aux *.log *.out; 
rm pubs/*.*
rm pubs/#*#
rm pubs/*~
mv *.pdf docs

for SUBDIR in docs images downloads teaching qb projects style
        do
            mkdir -p ~/public_html/$SUBDIR
            cp $SUBDIR/*.* ~/public_html/$SUBDIR
done

# Clean up cruft
rm */*~
rm *~
rm */*/*~
rm docs/*.pdf
git checkout $(git ls-files -d)
