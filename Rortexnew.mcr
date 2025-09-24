#!MC 1410
# Rortex Calculation Macro (Physics of Fluids 2018, 2019, Liu et al.)
# This macro assumes you have already loaded your dataset with velocity components U, V, W.

# 1. Calculate velocity gradients at nodal points
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'VELOCITYGRADIENT\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''

# 2. Compute the velocity gradient tensor invariants (P, Q, R)
$!ALTERDATA EQUATION = '{P} = -({dUdX} + {dVdY} + {dWdZ})'
$!ALTERDATA EQUATION = '{Q} = {dUdX}*{dVdY} + {dUdX}*{dWdZ} + {dVdY}*{dWdZ} - {dUdY}*{dVdX} - {dUdZ}*{dWdX} - {dVdZ}*{dWdY}'
$!ALTERDATA EQUATION = '{R} = {dUdX}*({dVdY}*{dWdZ} - {dVdZ}*{dWdY}) - {dUdY}*({dVdX}*{dWdZ} - {dVdZ}*{dWdX}) + {dUdZ}*({dVdX}*{dWdY} - {dVdY}*{dWdX})'

# 3. Compute the discriminant of the characteristic polynomial (to check for complex eigenvalues)
$!ALTERDATA EQUATION = '{Delta} = (1/27)*({R}**2) + (1/4)*({Q}**3)'

# 4. Calculate the imaginary and real parts of the complex eigenvalues (λ_cr ± i λ_ci)
# λ_ci = sqrt(max(0, -4*Q^3 - 27*R^2))/(2*sqrt(3))
$!ALTERDATA EQUATION = '{lambda_ci} = 0.5*SQRT(MAX(0, -4*{Q}**3 - 27*{R}**2))/SQRT(3)'
# λ_cr = -P/3 (for incompressible flow, P=0, so λ_cr = 0)
$!ALTERDATA EQUATION = '{lambda_cr} = -{P}/3'

# 5. Find the real eigenvector (rotation axis direction)
# This step cannot be fully automated in Tecplot macro language,
# but for most practical cases, the vorticity direction is a good approximation.
$!ALTERDATA EQUATION = '{omega_x} = {dWdY} - {dVdZ}'
$!ALTERDATA EQUATION = '{omega_y} = {dUdZ} - {dWdX}'
$!ALTERDATA EQUATION = '{omega_z} = {dVdX} - {dUdY}'
$!ALTERDATA EQUATION = '{omega_mag} = SQRT({omega_x}**2 + {omega_y}**2 + {omega_z}**2)'
$!ALTERDATA EQUATION = '{xi_x} = {omega_x}/({omega_mag} + 1e-12)'
$!ALTERDATA EQUATION = '{xi_y} = {omega_y}/({omega_mag} + 1e-12)'
$!ALTERDATA EQUATION = '{xi_z} = {omega_z}/({omega_mag} + 1e-12)'

# 6. Compute Rortex magnitude (rigid rotation strength)
# Rortex = 2 * lambda_ci (Physics of Fluids 2018, Eq. 31)
$!ALTERDATA EQUATION = '{Rortex_mag} = 2*{lambda_ci}'

# 7. Compose the Rortex vector (direction × magnitude)
$!ALTERDATA EQUATION = '{Rortex_x} = {Rortex_mag}*{xi_x}'
$!ALTERDATA EQUATION = '{Rortex_y} = {Rortex_mag}*{xi_y}'
$!ALTERDATA EQUATION = '{Rortex_z} = {Rortex_mag}*{xi_z}'

# 8. Optional: Visualize Rortex magnitude or vector field
$!GLOBALCONTOUR 1 VAR = 'Rortex_mag'
$!REDRAWALL
