# Systems on Silicon – Lab Reports

This repository contains the supporting code/simulation analysis from three practical lab assignments for the Systems on Silicon course. These labs involve Verilog simulations, logic synthesis, physical design, and optimization techniques using cadance's virtuoso and innovus.

## Lab 1 – Verilog Simulation and Debugging

### Overview:

Lab 1 focuses on understanding and simulating a signed 8-bit multiplier using Verilog and the NC-Sim simulation environment. The lab includes:

* `signed_mult.v`: A signed multiplier module.
* `tb_signed_mult.v`: A testbench to simulate different multiplication scenarios.

### Key Activities:

* Simulation of multiplication logic with varying inputs.
* Visualization and analysis of waveform traces using SimVision.
* Debugging of memory writes, identification of special values like `DEADABBA`, and analysis of RAM content.



## Lab 2 – Logic Synthesis and Optimization

### Overview:

Lab 2 explores power, performance, and area tradeoffs during logic synthesis. Different supply voltages and frequencies are tested to find the optimal configurations.

### Key Assignments:

1. **Max Frequency Determination:**

   * Found max stable frequency: 232 MHz.
   * Linear relationship between power and frequency.

2. **Silicon Efficiency and Dual Voltage Supply:**

   * Minor differences observed using 1.2V vs 1.0V for logic.
   * Memory dominates power usage (\~97%).

3. **Critical Path and Power Analysis:**

   * No major timing difference between 1.0V and 1.2V.
   * Slight power saving at 1.2V due to memory behavior.

4. **Incremental Synthesis:**

   * Applying synthesis optimization twice slightly reduces power.
   * Other optimization attempts (retiming, attribute tuning) were ineffective.



## Lab 3 – Placement, Routing, and Physical Design

### Overview:

Lab 3 deals with the physical layout of the synthesized design across various placement densities and orientations. It involves power domain exploration and analysis of metal usage and timing.

### Key Experiments:

1. **Density Impact (60%, 70%, 80%, 90%):**

   * Internal power dominates total power.
   * 90% density yielded fewer instances and lowest quality score.
   * 80% density had worst delay, 70% had best timing.

2. **Orientation Comparison:**

   * Orientation 2 improves wiring efficiency.
   * Better quality scores at higher densities due to reduced area.

3. **Multi-Power Domain (Part 3):**

   * Implemented dual power domains.
   * Slight increase in power usage; area significantly reduced.
   * Layout suffered from negative slack and timing violations.