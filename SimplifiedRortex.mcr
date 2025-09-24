#!MC 1410

$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'VELOCITYGRADIENT\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''

$!ALTERDATA EQUATION = '{s11} = {dUdX}'
$!ALTERDATA EQUATION = '{s12} = 0.5*({dUdY}+{dVdX})'
$!ALTERDATA EQUATION = '{s13} = 0.5*({dUdZ}+{dWdX})'
$!ALTERDATA EQUATION = '{s22} = {dVdY}'
$!ALTERDATA EQUATION = '{s23} = 0.5*({dVdZ}+{dWdY})'
$!ALTERDATA EQUATION = '{s33} = {dWdZ}'
$!ALTERDATA EQUATION = '{Omga12} = 0.5*({dUdY}-{dVdX})'
$!ALTERDATA EQUATION = '{Omga13} = 0.5*({dUdZ}-{dWdX})'
$!ALTERDATA EQUATION = '{Omga23} = 0.5*({dVdZ}-{dWdY})'

$!ALTERDATA EQUATION = '{Rortex} = sqrt(2*({Omga12}**2 + {Omga13}**2 + {Omga23}**2))'

$!REDRAWALL

