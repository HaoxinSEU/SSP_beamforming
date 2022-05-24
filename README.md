# SSP_beamforming

This is a repo for EPFL COM-500 SSP mini-project: Beamforming for Throughput Optimization in 5G.

We use two different ways to do beamforming for a MISO downlink communication system: matched beamforming (assignment1) and flexibeam (assignment2).

### Author: [Sun Haoxin](https://github.com/HaoxinSEU), [Xu Zewei](https://github.com/xuzewei28) and [Wu Yujie](https://github.com/YuJieWU99)

## Project Structure
```
- data
  - data1.mat         % DOA estimation results of dataset 1
  - data2.mat         % DOA estimation results of dataset 2
  - original_data     % real signal received by a base station
    - data_1.npz      % dataset 1
    - data_2.npz      % dataset 2
    - README.txt
- MATLAB              % matlab source code
  - matched_beamforming.m
  - flexibeam.m
- Python
- report              % report for this project
  - assignment1.pdf   % report for matched beamforming
  - assignment2.pdf   % report for flexibeam
  - assignment3.pdf   % summary
```


## References
1. P. Hurley and M. Simeoni, "Flexibeam: Analytic spatial filtering by beamforming," 2016 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP), 2016, pp. 2877-2880, doi: 10.1109/ICASSP.2016.7472203.
2. Simeoni, Matthieu & Hurley, Paul. (2016). Beamforming towards regions of interest for multi-site mobile networks. 
