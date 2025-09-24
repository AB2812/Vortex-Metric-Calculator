#!MC 1410
# Loops over time and extracts the vortex core

# Retrieve the number of time steps
$!EXTENDEDCOMMAND COMMANDPROCESSORID='extend time mcr'
    COMMAND='QUERY.NUMTIMESTEPS NUMTIMESTEPS'

# Loop over time steps
$!LOOP |NUMTIMESTEPS|
    # Set the time to the current step
    $!EXTENDEDCOMMAND COMMANDPROCESSORID='extend time mcr'
        COMMAND='SET.CURTIMESTEP |LOOP|'

    # Extract the vortex cores
    $!EXTENDEDCOMMAND
        COMMANDPROCESSORID = 'CFDAnalyzer4'
        COMMAND = 'ExtractFlowFeature Feature=\'VortexCores\' VCoreMethod=\'Eigenmodes\' ResidenceTime=1 SolutionTime=|LOOP| ExcludeBlanked=\'F\''
$!ENDLOOP