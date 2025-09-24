# Vortex Metric Calculator

This repository contains a collection of Tecplot macros for calculating various vortex-related metrics in CFD simulations. These macros are designed to help you analyze and visualize the rotational structures in your flow fields.

## Included Macros

* **PVSnew.mcr:** A comprehensive script for primary vortex core identification using Lambda-2 and Q-criterion, with time-based extraction.
* **SimplifiedRortex.mcr:** A simplified macro for a quick calculation of the Rortex magnitude.
* **Vortec core extraction.mcr:** A script for extracting vortex cores over time.
* **Lamda 2.mcr:** A macro for calculating the Lambda-2 criterion.
* **Rortexnew.mcr:** A detailed script for calculating the Rortex vector based on the work of Liu et al.
* **Lambda_CiCalculation.mcr:** A specialized macro for calculating the imaginary part of the complex eigenvalues of the velocity gradient tensor.
* **VEL.mcr:** A macro for calculating and visualizing the viscous dissipation rate.

## How to Use

To use these macros in Tecplot, follow these steps:

1.  **Load your data:** Open Tecplot and load your CFD simulation data. Make sure your dataset contains the velocity components (U, V, W).
2.  **Open the macro:** Go to **Scripting -> Play Macro/Script...**
3.  **Select the macro file:** Browse to the location where you have saved the macro files and select the one you want to run.
4.  **Run the macro:** Click "Open" to run the macro. The macro will perform the calculations and create new variables in your dataset.
5.  **Visualize the results:** You can then use Tecplot's plotting tools to visualize the newly created variables (e.g., Q-criterion, Lambda-2, Rortex) and analyze the vortex structures in your flow.

## License

This project is licensed under the GNU General Public License v2.0 - see the [LICENSE](LICENSE) file for details.

## Cite(While Using)
Bhattacharyya, Abhra. Vortex Metric Calculator. 2025. Biomechanics Lab, School of Biomedical Engineering, Indian Institute of Technology (BHU) Varanasi

## References
1. Liu, C., Gao, Ys., Dong, Xr. et al. Third generation of vortex identification methods: Omega and Liutex/Rortex based systems. J Hydrodyn 31, 205–223 (2019). https://doi.org/10.1007/s42241-019-0022-4
2. Zhang, Yn., Qiu, X., Chen, Fp. et al. A selected review of vortex identification methods with applications. J Hydrodyn 30, 767–779 (2018). https://doi.org/10.1007/s42241-018-0112-8
