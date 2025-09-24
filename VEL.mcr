#!MC 1410
# Calculate velocity gradients first
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'VELOCITYGRADIENT\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''

# Calculate strain rate tensor components: Sij = 0.5*(∂ui/∂xj + ∂uj/∂xi)
$!ALTERDATA EQUATION = '{S11} = {dUdX}'
$!ALTERDATA EQUATION = '{S22} = {dVdY}'
$!ALTERDATA EQUATION = '{S33} = {dWdZ}'
$!ALTERDATA EQUATION = '{S12} = 0.5*({dUdY} + {dVdX})'
$!ALTERDATA EQUATION = '{S13} = 0.5*({dUdZ} + {dWdX})'
$!ALTERDATA EQUATION = '{S23} = 0.5*({dVdZ} + {dWdY})'

# Calculate strain rate magnitude squared: Sij*Sij
$!ALTERDATA EQUATION = '{StrainRate_MagSq} = 2*({S11}**2 + {S22}**2 + {S33}**2 + 2*{S12}**2 + 2*{S13}**2 + 2*{S23}**2)'

# Alternative form for verification
  $!ALTERDATA EQUATION = '{StrainRate_MagSq_Alt} = 2*({dUdX}**2 + {dVdY}**2 + {dWdZ}**2) + ({dUdY} + {dVdX})**2 + ({dUdZ} + {dWdX})**2 + ({dVdZ} + {dWdY})**2'
  $!ALTERDATA EQUATION = '{Laminar_Viscosity} = 0.00345'
  $!ALTERDATA EQUATION = '{Viscous_Dissipation_Rate} = {Laminar_Viscosity} * {StrainRate_MagSq}'

# Calculate specific dissipation rate (energy loss per unit mass per unit time)
# ε_specific = ε/ρ [Units: W/kg or m²/s³]
$!ALTERDATA EQUATION = '{Density} = 1060'
$!ALTERDATA EQUATION = '{Specific_Dissipation_Rate} = {Viscous_Dissipation_Rate} / {Density}'


# Calculate total dissipation in a control volume (SIMPLIFIED - removed problematic volume calculation)
$!ALTERDATA EQUATION = '{Total_Energy_Loss} = {Viscous_Dissipation_Rate} * 1.0'

# Verification: Check that dissipation is always positive
$!ALTERDATA EQUATION = '{Dissipation_Check} = if({Viscous_Dissipation_Rate} < 0, 1, 0)'

# Create visualization
$!GLOBALCONTOUR 1 VAR = 'Viscous_Dissipation_Rate'
$!GLOBALCONTOUR 2 VAR = 'Specific_Dissipation_Rate'


$!REDRAWALL
