# FindCode

## Introduction

FindCode is a MATLAB documentation,use the -1 and +1 order harmonic target compensation phases saved in advance in the CreateOrder document and the state transition sequence list and amplitude phase table saved in advance in the CreateTable document to determine the state transition sequence of each meta-atom of the RIS.

This project aims to determine the state transition sequence and corresponding amplitude and phase of each unit of RIS using the data previously saved offline, and saving the results in text form for subsequent verification.

## Instructions for use

- **Main script: main.m**

  Description: main.m is the main script of the project, responsible for determining the state transition sequence and corresponding amplitude and phase of each unit of RIS, and saving the results in text form for subsequent verification.

  The script performs the following operations:

  Data loading: Load the -1st and +1st harmonic target compensation phases pre-saved in the CreateOrder file and the state transfer sequence list and amplitude phase table pre-saved in the CreateTable file into MATLAB.
  
  Data processing: Unify data formats.
  
  Data search: Find the state transition sequence and corresponding amplitude phase of each unit of RIS.
  
  Data storage: Save the state transition sequence table and the amplitude phase corresponding to the -1 and +1 order harmonics.
  
- **Function: MeijuDouble.m**
  
  Description: MeijuDouble.m is used to search the state transition sequence table to match the target phase.
  
  ```matlab
  function [P2, P1, A2, A1,g_best] = MeijuDouble( context,fi,target_P1,target_P2)
  % Input parameters:
  %   context -  All state transition sequences
  %   fi      -  The amplitude and phase of the corresponding state sequence
  %   target_P1  - Target phase of -1 order harmonic approximation
  %   target_P2  - Target phase of +1 order harmonic approximation
  % Output parameters:
  %   g_best  -  Optimal state transition sequence
  %   A1,P1   -  -1 order harmonic amplitude and phase corresponding to the optimal state transition sequence
  %   A2,P2   -  +1 order harmonic amplitude and phase corresponding to the optimal state transition sequence
  ```
  
## Additional Notes

If you are not satisfied with the harmonic pattern of order -1, +1 after running the Draw document, you can change the weights w1,w2 in MeijuDouble.m to realize the fine tuning of the beamforming.

