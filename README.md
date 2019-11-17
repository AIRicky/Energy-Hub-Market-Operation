# Participation of an Energy Hub in Electricity and Heat Distribution Markets: An MPEC Approach

## Introduction

This repository is related to our research on the market participation of the energy hub in integrated energy markets, and more details can be found in the paper, Rui Li, Wei Wei, Shengwei Mei, Qinran Hu, Qiuwei Wu. [Participation of an Energy Hub in Electricity and Heat Distribution Markets: An MPEC Approach](https://ieeexplore.ieee.org/document/8354834/). IEEE Transactions on Smart Grid, vol. 10, no. 4, pp. 3641-3653, July 2019. doi: 10.1109/TSG.2018.2833279. 

## Abstract
Integration of electricity and heat distribution networks offers extra flexibility to system operation and improves energy efficiency. The energy hub (EH) plays an important role in energy production, conversion and storage in such coupled infrastructures. This paper provides a new outlook and thorough mathematical tool for studying the integrated energy system from a deregulated market perspective. A mathematic program with equilibrium constraints (MPEC) model is proposed to study the strategic behaviors of a profit-driven energy hub in the electricity market and heating market under the background of energy system integration. In the upper level, the EH submits bids of prices and quantities to a distribution power market and a heating market; in the lower level, the two markets are cleared and energy contracts between the EH and two energy markets are determined. Network constraints of physical systems are explicitly represented by an optimal power flow problem and an optimal thermal flow problem. The proposed MPEC formulation is approximated by a mixed-integer linear program via performing integer disjunctions on the complementarity and slackness conditions and binary expansion technique on the bilinear product terms. Case studies demonstrate the effectiveness of the proposed model and method.

## Implementation
**MainPAB.m** is the main function, and associated sources such as *data*, *constraints*, *variables*, and *functions* are refactored in the corresponding folders.
