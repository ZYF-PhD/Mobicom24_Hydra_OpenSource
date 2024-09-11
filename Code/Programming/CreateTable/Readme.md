# CreateTable

## Introduction

CreateTable is a MATLAB documentation, It is used to create and save a state transition sequence list under certain constraints, and at the same time save the amplitude and phase of the -1 and +1 order harmonics under the corresponding sequence.

This project aims to save the required data in advance in an offline manner to facilitate subsequent search and calculation.

## Instructions for use

- **Main script: main.m** 
  
  Description: main.m is the main script of the project, responsible for Creating the code table and  amplitude-phase table. 
  
  The script performs the following operations:
  
  Parameter setting: Calculate the relevant parameters in the process of -1, +1 order harmonic amplitude and phase corresponding to the state transition sequence.
  
  Calculation: Traverse the state transition sequence and calculate the corresponding amplitude and phase. Filter the state transition sequence that meets the constraints.
  
  Save results: Save the calculation results to a file.
  
- **Function: EliminateErrors.m**
  
  Description: EliminateErrors.m is used to eliminate system errors.
  
  ```matlab
  function result  = EliminateErrors (input)
   % Input parameters:
   %   input  - A plural
   % Output parameters:
   %   result - After eliminating the error caused by the system,  the return value is still a complex number
  ```
## Additional Notes

The code takes the state transition sequence with the number of states M = 6 as an example. There are 4096 possibilities in total. The total time to build the table is less than 1 second. As M increases, more precise control of phase and amplitude can be achieved. However, the larger the value of 𝑀, the search space of the state transition sequence increases exponentially.

Offline table creation provides a solution for real-time situations and when M is relatively large.

