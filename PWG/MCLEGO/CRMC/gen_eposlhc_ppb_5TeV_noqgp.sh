#!/bin/bash
set -e

if [[ $# -lt 1 ]]; then
    echo "You must specify at least where to write output to as first parameter."
    exit -1
fi

echo "running in `pwd`, writing HepMC to $1"

# prepare environment
source /cvmfs/alice.cern.ch/etc/login.sh
eval $(alienv printenv CRMC::v1.5.4-3)

# force path to requested output
sed -e s#__CRMC_BASEDIR__#"$CRMC_ROOT"# ${ALICE_PHYSICS}/PWG/MCLEGO/CRMC/crmc_template_ppb.param > crmc.param

#disable the 'fusion' option in EPOS-LHC parameter file

sed -i s/\!switch\ fusion\ off/switch\ fusion\ off/ crmc.param

# ${ALICE_PHYSICS}/PWG/MCLEGO/CRMC/crmc_template.param > crmc.param
# ${ALICE_PHYSICS}/PWGLF/CommonUtils/MConthefly/macros/crmc_template.param > crmc.param

# run CRMC
crmc -o hepmc -p 3998 -P-1576 -I 822080 -n 10000000 -m 0 -f $1
