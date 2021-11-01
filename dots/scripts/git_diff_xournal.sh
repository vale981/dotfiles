output=`file ${1} | grep -c 'gzip'`
if [ $output -eq "1" ]
then
    gunzip -c ${1}
else
    #our file is not gzipped
    cat ${1}
fi
