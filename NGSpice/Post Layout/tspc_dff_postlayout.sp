* Basic TSPC DFF Functionality Check (Resized & Fixed)

.include TSMC_180nm.txt

* --- Parameters ---
.param VDD_VAL = 1.8V
.param CLOAD = 10f

* --- Options ---
.options method=gear
.options gmin=1e-10

* --- Power ---
Vdd vdd 0 {VDD_VAL}

* --- Inputs ---
* Clock: 500MHz
Vclk_raw clk_in 0 PULSE(0 {VDD_VAL} 1n 50p 50p 1n 2n)
Rclk clk_in clk 10

* Data Pattern: Low -> High -> Low
Vdata_raw d_in 0 PWL(0 0 2.5n 0 2.6n {VDD_VAL} 4.5n {VDD_VAL} 4.6n 0)
Rd d_in d 10

* -------------------------------------------------------------------------
* EXTRACTED SUBCIRCUIT (Resized & Cleaned)
* -------------------------------------------------------------------------
.subckt tspc_dff_post clk d dffout vdd gnd

* -- Transistors (Resized w=80->12, w=40->6) --
* Mapped w_...# -> vdd, Gnd -> gnd, a_...# -> vdd/internal

M1000 a_25_59# d vdd vdd CMOSP w=12 l=2 ad=480 pd=172 as=1250 ps=540
M1001 vdd clk a_56_3# vdd CMOSP w=12 l=2 ad=0 pd=0 as=480 ps=172
M1002 gnd clk a_63_3# gnd CMOSN w=6 l=2 ad=600 pd=280 as=240 ps=92
M1003 a_101_33# a_56_3# gnd gnd CMOSN w=6 l=2 ad=240 pd=92 as=0 ps=0
M1004 gnd d a_18_23# gnd CMOSN w=6 l=2 ad=0 pd=0 as=100 ps=50
M1005 a_101_89# a_56_3# vdd vdd CMOSP w=12 l=2 ad=300 pd=112 as=0 ps=0
M1006 a_63_3# a_18_23# a_56_3# gnd CMOSN w=6 l=2 ad=0 pd=0 as=200 ps=90
M1007 a_101_89# clk a_101_33# gnd CMOSN w=6 l=2 ad=200 pd=90 as=0 ps=0
M1008 a_18_23# clk a_25_59# vdd CMOSP w=12 l=2 ad=400 pd=170 as=0 ps=0
M1009 dffout a_101_89# vdd vdd CMOSP w=12 l=2 ad=200 pd=90 as=0 ps=0
M1010 a_56_3# a_18_23# a_56_59# vdd CMOSP w=12 l=2 ad=0 pd=0 as=400 ps=170
M1011 a_109_89# clk a_101_89# vdd CMOSP w=12 l=2 ad=250 pd=110 as=0 ps=0
M1012 dffout a_101_89# gnd gnd CMOSN w=6 l=2 ad=100 pd=50 as=0 ps=0

* -- Parasitics (Floating wells fixed to vdd) --
C0 vdd clk 0.08fF
C1 a_101_89# vdd 0.52fF
C2 a_101_89# vdd 0.07fF
C3 gnd a_63_3# 0.44fF
C4 a_18_23# vdd 0.10fF
C5 vdd clk 0.08fF
C6 a_18_23# clk 0.47fF
C7 clk a_56_3# 0.17fF
C8 vdd vdd 0.06fF
C9 a_25_59# vdd 0.82fF
C10 a_101_89# dffout 0.05fF
C11 gnd dffout 0.21fF
C12 d vdd 0.08fF
C13 vdd a_18_23# 0.08fF
C14 vdd a_56_3# 0.02fF
C15 a_18_23# a_56_3# 0.10fF
C16 d clk 0.15fF
C17 clk vdd 0.08fF
C18 a_101_89# clk 0.06fF
C19 dffout vdd 0.41fF
C20 vdd dffout 0.07fF
C21 d a_18_23# 0.08fF
C22 a_101_89# a_101_33# 0.41fF
C23 a_101_33# gnd 0.41fF
C24 vdd vdd 0.12fF
C25 a_56_3# vdd 0.07fF
C26 gnd a_18_23# 0.26fF
C27 clk vdd 1.20fF
C28 gnd a_56_3# 0.30fF
C29 a_25_59# vdd 0.01fF
C30 a_109_89# vdd 0.06fF
C31 vdd vdd 0.11fF
C32 a_101_89# a_109_89# 0.58fF
C33 a_56_3# vdd 0.95fF
C34 a_101_89# vdd 0.04fF
C35 a_18_23# a_25_59# 0.82fF
C36 a_63_3# a_56_3# 0.47fF
C37 a_101_89# gnd 0.10fF
C38 vdd a_56_59# 0.09fF
C39 a_18_23# a_56_59# 0.47fF
C40 a_56_59# a_56_3# 0.82fF
C41 d vdd 0.05fF
C42 vdd vdd 0.08fF
C43 a_101_33# gnd 0.01fF
C44 a_63_3# gnd 0.01fF
C45 gnd gnd 0.93fF
C46 dffout gnd 0.08fF
C47 a_109_89# gnd 0.00fF
C48 vdd gnd 1.10fF
C49 a_101_89# gnd 0.30fF
C50 a_56_3# gnd 0.40fF
C51 a_18_23# gnd 0.70fF
C52 clk gnd 0.27fF
C53 d gnd 0.06fF
C54 vdd gnd 1.25fF
C55 vdd gnd 2.02fF
C56 vdd gnd 2.99fF
C57 vdd gnd 2.99fF

.ends tspc_dff_post

* --- Instantiation ---
X1 clk d q vdd 0 tspc_dff_post
Cload q 0 {CLOAD}

* --- Analysis ---
.ic v(q)=0
.tran 10p 6n uic

.control
    run
    set curplottitle = "Basic TSPC Resized Check"
    plot V(clk)+2 V(d) V(q)
.endc

.end