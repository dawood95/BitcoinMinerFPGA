BitcoinMinerFPGA
================

ECE 337  Bitcoin Miner

To Do:
------
- [ ] Finish SHA block 
- [ ] Finish Mem Manager
- [ ] Figure out FPGA
- [ ] Presentation

How SHA cycle works:
--------------------
    - counts = 0 1 2 3 ... 30 31 32 33 34 35 .. 60 61 62 63 
    - if count == 0 : 
      clk -> load data, count = 1 ; 1 sha cycle will be done
    - if count == 1 : 
      clk -> count= 2 ; 2 sha cycle
    - if count == 31 : 
      clk -> count= 32; 32 shacycles
    - if count == 32 : 
      clk ->load data, count = 33 ; 1 sha cycle
    - if count == 63 : 
      clk -> count = 0; 32 sha cycle
