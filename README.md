# Custom NanoAOD v15 production

Produce custom NanoAODs.

<!-- TOC -->

- [NanoAOD production](#nanoaod-production)
    - [Version](#version)
    - [Setup](#setup)
    - [Production](#production)

<!-- /TOC -->

---

## Version

The current version is based on [NanoAODv15](https://gitlab.cern.ch/cms-nanoAOD/nanoaod-doc/-/wikis/Releases/NanoAODv15).

Customizations:

- Add all raw scores of the new central ParticleNetMD AK8 training (`FatJet_ParticleNet_raw_*`).
- Add all raw scores of the private ParticleNetMD AK8 training with ee, emu, and mumu scores (`FatJet_ParticleNet_newlabel_raw_*`)
- Add all raw scores of the private ParticleNetMD AK8 training with ee, emu, and mumu scores and W+Jets samples included in the training (`FatJet_ParticleNet_newlabelwjets_raw_*`)


---

## Setup

```bash
cmsrel CMSSW_15_0_7
cd CMSSW_15_0_7/src
cmsenv
```

Customized CMSSW to add new taggers:
```bash
git cms-init
git cms-addpkg PhysicsTools/NanoAOD PhysicsTools/PatAlgos RecoBTag/ONNXRuntime RecoBTag/Combined
git remote add danyifork git@github.com:danyi211/cmssw.git
git fetch danyifork
git pull danyifork from-CMSSW_15_0_7
git clone git@github.com:danyi211/RecoBTag-Combined.git RecoBTag/Combined/data
scram b -j
```

Clone this repository:
```bash
git clone -b nano-v15-run2-customized git@github.com:slaurila/hh-bbtt-prod.git
cd hh-bbtt-prod
```

## Production

**Step 0**: Run the steps above and then set up the grid proxy, CRAB environment, etc:

```bash
# set up grid proxy
voms-proxy-init -rfc -voms cms --valid 168:00
# set up CRAB env (must be done after cmsenv)
source /cvmfs/cms.cern.ch/common/crab-setup.sh
```

**Step 1**: generate the python config file by running `./generateConfigs.sh`.

**Step 2**: use the `crab.py` script to submit the CRAB jobs:

For MC (to process the QCD samples, just replace `part1` by `part2_QCD` in the commands):

```bash
python3 crab.py -p mc_2018UL_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2018/mc -t NanoAOD-v15_July2025 -i mc/mc_2018_part1.conf --num-cores 4 -s FileBased -n 2 --work-area crab_projects_2018UL --dryrun

python3 crab.py -p mc_2017UL_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2017/mc -t NanoAOD-v15_July2025 -i mc/mc_2017_part1.conf --num-cores 4 -s FileBased -n 2 --work-area crab_projects_2017UL --dryrun

python3 crab.py -p mc_2016ULpostVFP_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2016/mc -t NanoAOD-v15_July2025 -i mc/mc_2016post_part1.conf --num-cores 4 -s FileBased -n 2 --work-area crab_projects_2016ULpostVFP --dryrun

python3 crab.py -p mc_2016ULpreVFP_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2016APV/mc -t NanoAOD-v15_July2025 -i mc/mc_2016pre_part1.conf --num-cores 4 -s FileBased -n 2 --work-area crab_projects_2016ULpreVFP --dryrun
```

For Data:

```bash
python3 crab.py -p data_2018UL_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2018/data -t NanoAOD-v15_July2025 -i data/data_2018.conf --num-cores 4 -s EventAwareLumiBased -n 100000 -j 'https://cms-service-dqmdc.web.cern.ch/CAF/certification/Collisions18/13TeV/Legacy_2018/Cert_314472-325175_13TeV_Legacy2018_Collisions18_JSON.txt' --work-area crab_projects_data_2018UL --dryrun

python3 crab.py -p data_2017UL_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2017/data -t NanoAOD-v15_July2025 -i data/data_2017.conf --num-cores 4 -s EventAwareLumiBased -n 100000 -j 'https://cms-service-dqmdc.web.cern.ch/CAF/certification/Collisions17/13TeV/Legacy_2017/Cert_294927-306462_13TeV_UL2017_Collisions17_GoldenJSON.txt' --work-area crab_projects_data_2017UL --dryrun

python3 crab.py -p data_2016ULpostVFP_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2016/data -t NanoAOD-v15_July2025 -i data/data_2016post.conf --num-cores 4 -s EventAwareLumiBased -n 100000 -j 'https://cms-service-dqmdc.web.cern.ch/CAF/certification/Collisions16/13TeV/Legacy_2016/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt' --work-area crab_projects_data_2016ULpostVFP --dryrun

python3 crab.py -p data_2016ULpreVFP_NANO.py --max-memory 4000 --site T2_CH_CERN -o /store/group/cmst3/group/hh/NanoAOD/20250717_NanoAODv15/2016APV/data -t NanoAOD-v15_July2025 -i data/data_2016pre.conf --num-cores 4 -s EventAwareLumiBased -n 100000 -j 'https://cms-service-dqmdc.web.cern.ch/CAF/certification/Collisions16/13TeV/Legacy_2016/Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt' --work-area crab_projects_data_2016ULpreVFP --dryrun
```

These command will perform a "dryrun" to print out the CRAB configuration files. Please check everything is correct (e.g., the output path, version number, requested number of cores, etc.) before submitting the actual jobs. To actually submit the jobs to CRAB, just remove the `--dryrun` option at the end.

**Step 3**: check job status

The status of the CRAB jobs can be checked with:

```bash
./crab.py --status --work-area crab_projects_*  --options "maxjobruntime=4000 maxmemory=4000" && ./crab.py --summary
```

Note that this will also **resubmit** failed jobs automatically.

The crab dashboard can also be used to get a quick overview of the job status:

- [https://monit-grafana.cern.ch/d/cmsTMGlobal/cms-tasks-monitoring-globalview?orgId=11](https://monit-grafana.cern.ch/d/cmsTMGlobal/cms-tasks-monitoring-globalview?orgId=11)

More options of this `crab.py` script can be found with:

```bash
./crab.py -h
```
