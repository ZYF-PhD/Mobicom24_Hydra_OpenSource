# Mobicom24_Hydra_OpenSource

The artifact evaluation process aims to verify the reproducibility and applicability of the findings outlined in our paper. 

Our artifact includes the derivations and explanations of some formulas from the paper to enhance its readability. We also provide simulation models for 3.5 GHz 2-bit RIS meta-atoms, along with data on phase compensation and reflection coefficients for four different states, to aid in understanding the RIS’s structure and operation. Additionally, we supply all source code for benchmarks and evaluations, outlining the complete workflow for harmonic generation, attack effect assessment, and programming RIS for attack.

- **Formula derivation:** Supplement the derivation process for Eqn.7 and Eqn.11-16 in our paper.

- **Code:** The code is organized into three sub-files: *Harmonic Generation*, *Attack Simulation*, and *Programming*. 
  - *Harmonic Generation* simulates the underlying principles of harmonic generation.
  - *Attack Simulation* assesses the effectiveness and implementation requirements of the attack strategy.
  - *Programming* is responsible for generating the RIS state transition sequences tailored to various attack scenarios.

- **RIS model:** The RIS model includes meta-atom models at 3.5 GHz under four diode states and provides the simulated S11 and phase parameters for frequencies from 3 GHz to 4 GHz, with a 0.01 GHz sweep.
