#!MC 1410
# Complete Primary Vortex Core Identification with Lambda-2 and Time-Based Extraction
# Fixed based on Tecplot Knowledge Base

# Calculate velocity gradients
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'VELOCITYGRADIENT\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''

# Calculate Q-criterion
$!ALTERDATA EQUATION = '{P} = -({dUdX}+{dVdY}+{dWdZ})'
$!ALTERDATA EQUATION = '{Q} = (-{dUdY}*{dVdX}-{dUdZ}*{dWdX}-{dVdZ}*{dWdY}+{dUdX}*{dVdY}+{dWdZ}*{dUdX}+{dWdZ}*{dVdY})'

# Calculate strain and vorticity tensors
$!ALTERDATA EQUATION = '{s11} = {dUdX}'
$!ALTERDATA EQUATION = '{s12} = 0.5*({dUdY}+{dVdX})'
$!ALTERDATA EQUATION = '{s13} = 0.5*({dUdZ}+{dWdX})'
$!ALTERDATA EQUATION = '{s22} = {dVdY}'
$!ALTERDATA EQUATION = '{s23} = 0.5*({dVdZ}+{dWdY})'
$!ALTERDATA EQUATION = '{s33} = {dWdZ}'
$!ALTERDATA EQUATION = '{Omga12} = 0.5*({dUdY}-{dVdX})'
$!ALTERDATA EQUATION = '{Omga13} = 0.5*({dUdZ}-{dWdX})'
$!ALTERDATA EQUATION = '{Omga23} = 0.5*({dVdZ}-{dWdY})'

# Calculate S²+Ω² tensor
$!ALTERDATA EQUATION = '{s2o2_11} = {s11}**2 + {s12}**2 + {s13}**2 - {Omga12}**2 - {Omga13}**2'
$!ALTERDATA EQUATION = '{s2o2_12} = {s11}*{s12} + {s12}*{s22} + {s13}*{s23} - {Omga13}*{Omga23}'
$!ALTERDATA EQUATION = '{s2o2_13} = {s11}*{s13} + {s12}*{s23} + {s13}*{s33} + {Omga12}*{Omga23}'
$!ALTERDATA EQUATION = '{s2o2_22} = {s12}**2 + {s22}**2 + {s23}**2 - {Omga12}**2 - {Omga23}**2'
$!ALTERDATA EQUATION = '{s2o2_23} = {s12}*{s13} + {s22}*{s23} + {s23}*{s33} - {Omga12}*{Omga13}'
$!ALTERDATA EQUATION = '{s2o2_33} = {s13}**2 + {s23}**2 + {s33}**2 - {Omga13}**2 - {Omga23}**2'

# Get variable numbers for eigenvalue calculation
$!GETVARNUMBYNAME |numVars2o2_11|
  NAME = "s2o2_11"
$!GETVARNUMBYNAME |numVars2o2_12|
  NAME = "s2o2_12"
$!GETVARNUMBYNAME |numVars2o2_13|
  NAME = "s2o2_13"
$!GETVARNUMBYNAME |numVars2o2_22|
  NAME = "s2o2_22"
$!GETVARNUMBYNAME |numVars2o2_23|
  NAME = "s2o2_23"
$!GETVARNUMBYNAME |numVars2o2_33|
  NAME = "s2o2_33"

# Calculate eigenvalues (creates EgnVal1, EgnVal2, EgnVal3)
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'Tensor Eigensystem'
  COMMAND = 'T11VarNum = |numVars2o2_11|, T12VarNum = |numVars2o2_12|, T13VarNum = |numVars2o2_13|, T22VarNum = |numVars2o2_22|, T23VarNum = |numVars2o2_23|, T33VarNum = |numVars2o2_33|, SortEgnV = TRUE, SaveEgnVect = TRUE'

# PRIMARY VORTEX CORE IDENTIFICATION using Lambda-2 (EgnVal2) and Q-criterion
$!ALTERDATA EQUATION = '{Primary_Vortex_Core} = if({EgnVal2} < -2000 && {Q} > 4000, 1, 0)'

# Secondary vortex identification with relaxed thresholds
$!ALTERDATA EQUATION = '{Secondary_Vortex_Core} = if({EgnVal2} < -1000 && {Q} > 2000, 1, 0)'

# Lambda-2 based vortex strength
$!ALTERDATA EQUATION = '{Lambda2_Strength} = abs({EgnVal2})'

# TIME-BASED VORTEX EXTRACTION
$!EXTENDEDCOMMAND COMMANDPROCESSORID='extend time mcr'
    COMMAND='QUERY.NUMTIMESTEPS NUMTIMESTEPS'

$!LOOP |NUMTIMESTEPS|
    $!EXTENDEDCOMMAND COMMANDPROCESSORID='extend time mcr'
        COMMAND='SET.CURTIMESTEP |LOOP|'

    # Extract vortex cores using valid Eigenmodes method only
    $!EXTENDEDCOMMAND
        COMMANDPROCESSORID = 'CFDAnalyzer4'
        COMMAND = 'ExtractFlowFeature Feature=\'VortexCores\' VCoreMethod=\'Eigenmodes\' ResidenceTime=1 SolutionTime=|LOOP| ExcludeBlanked=\'F\''

$!ENDLOOP

# Visualization
$!GLOBALCONTOUR 1 VAR = 'Primary_Vortex_Core'
$!GLOBALCONTOUR 2 VAR = 'Secondary_Vortex_Core'
$!REDRAWALL
