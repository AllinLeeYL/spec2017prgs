#!/bin/bash

# SPECLANG=/home/allin/llvm-project/build/bin/ # absulote path
CONFIGFILE=my_test.cfg
SIZE=test
SPECDIR="/home/allin/spec2017"
DESDIR="/home/allin/specprg" # absulote path

mkdir ${DESDIR}
cd $SPECDIR && cp benchspec/Makefile.defaults ${DESDIR}/Makefile.defaults && source shrc

for file in $(cd $SPECDIR/benchspec/CPU/ && ls -d */)
do
    benc=${file:0:$(expr ${#file} - 1)}

    LOGFILE=$(runcpu --fake --loose --size ${SIZE} --tune base --config my_test ${benc} | grep "The log for this run is in" -m 1 | grep -e "/.*\.log" -o) # log file
    BUILDDIR=$(grep -e "build/.*/Makefile" "${LOGFILE}" -m 1 | grep -e "'/.*Makefile" -o)
    LEN=$(expr ${#BUILDDIR} - 9)
    BUILDDIR=${BUILDDIR:1:${LEN}} # build directory
    RUNDIR=$(grep -e "run/run" ${LOGFILE} -m 1 | grep -e "/.*" -o) # run directory

    echo "LOGFILE=${LOGFILE}"
    echo "BUILDDIR=${BUILDDIR}"
    echo "RUNDIR=${RUNDIR}"

    cd $BUILDDIR
    # specmake SPECLANG=${SPECLANG} -n > compile.sh
    specmake -n > compile.sh

    cd $RUNDIR
    specinvoke -n > run.sh

    cd ${DESDIR} && mkdir ${benc}
    cd ${benc}
    cp -r $BUILDDIR .
    cp -r $RUNDIR .

    cd build*
    sed -i "2,2c -include ${DESDIR}/Makefile.defaults" Makefile

    echo "----------------------------------------------------------------------"
done

