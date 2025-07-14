#! /bin/bash

# MC and data customizations to add AK4 CHS jets and use AK8 PUPPI weights straight from input MiniAOD
read -r -d '' customize_mc <<'EOF'
"process.load('PhysicsTools.NanoAOD.jetsAK4_CHS_cff'); process.jetTable.name = 'JetCHS'; process.linkedObjectsChs = process.linkedObjects.clone(jets = cms.InputTag('finalJets')); process.jetTable.src = cms.InputTag('linkedObjectsChs','jets'); process.bjetNN.src = cms.InputTag('linkedObjectsChs','jets'); process.cjetNN.src = cms.InputTag('linkedObjectsChs','jets'); process.chsJetTask = cms.Task(process.basicJetsForMetForT1METNano,process.jetTask,process.bjetNN,process.cjetNN,process.linkedObjectsChs,process.jetTable); process.nanoSequenceMC.associate(process.chsJetTask); process.packedpuppi.useExistingWeights = True; process.packedpuppiNoLep.useExistingWeights = True"
EOF
customize_data="${customize_mc//nanoSequenceMC/nanoSequence}"

# MC, 2018UL nano v15 customized
cmsDriver.py mc_2018UL --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --fileout file:nano.root --conditions 131X_upgrade2018_realistic_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2018,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_mc

# Data, 2018UL nano v15 customized
cmsDriver.py data_2018UL --data --eventcontent NANOAOD --datatier NANOAOD --fileout file:nano.root --conditions 141X_dataRun2_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2018,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_data

# MC, 2017UL
cmsDriver.py mc_2017UL --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --fileout file:nano.root --conditions 131X_mc2017_realistic_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2017,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_mc

# Data, 2017UL
cmsDriver.py data_2017UL --data --eventcontent NANOAOD --datatier NANOAOD --fileout file:nano.root --conditions 141X_dataRun2_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2017,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_data

# MC, 2016ULpreVFP
cmsDriver.py mc_2016ULpreVFP --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --fileout file:nano.root --conditions 131X_mcRun2_asymptotic_preVFP_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2016_HIPM,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_mc

# Data, 2016ULpreVFP
cmsDriver.py data_2016ULpreVFP --data --eventcontent NANOAOD --datatier NANOAOD --fileout file:nano.root --conditions 141X_dataRun2_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2016_HIPM,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_data

# MC, 2016ULpostVFP
cmsDriver.py mc_2016ULpostVFP --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --fileout file:nano.root --conditions 131X_mcRun2_asymptotic_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2016,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_mc

# Data, 2016ULpostVFP
cmsDriver.py data_2016ULpostVFP --data --eventcontent NANOAOD --datatier NANOAOD --fileout file:nano.root --conditions 141X_dataRun2_v3 --process NANO --filein file:inMINIAOD.root --era Run2_2016,run2_nanoAOD_106Xv2 --no_exec -n -1 --customise_commands=$customize_data

for cfg in $(ls *UL*.py); do
    echo "Adding ParticleNet raw scores to ${cfg}"
    sed -i -e 's@# Customisation from command line@# Customisation from command line\nfrom RecoBTag.ONNXRuntime.pfParticleNetFromMiniAODAK8_cff import _pfParticleNetFromMiniAODAK8JetTagsProbs\nfrom PhysicsTools.NanoAOD.common_cff import Var\nfor prob in _pfParticleNetFromMiniAODAK8JetTagsProbs:\n    name = "ParticleNet_raw_" + prob.split(":")[1]\n    setattr(process.fatJetTable.variables, name, Var("bDiscriminator('"'"'%s'"'"')" % prob, float, doc=prob, precision=-1))@' ${cfg}
done

# TODO: add customizations for new taggers
