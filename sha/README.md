
Top Level : SHA Block
---------------------
|Signal Name|Description|
|-----|-------|  
| clk | Clock |
| midState | 256 bits after the partial hash of the header data 
| headData | 512 remaining bits of the header data after partial hashing
| solveEn | Signal that tells the SHA block to start solving
| loadState | Signal that tells the SHA block that the controller is in the load state
| flag | Asserted if a nonce has been found
| goldenNonce | Correct nonce when the flag is asserted

Stuff that don't work : 
  - SHA Block mapped test bench (source test bench works, mapped syntesis of SHA block works) 


Structure
---------
    -sha_block
      -sha_core
        -sha256
          -sha_math
            -s0
            -s1
            -S0
            -S1
            -Maj
            -Ch
          -sha_datashift
        -hash_check
      -cycleCounter
        -counter
      -nonceCounter
        -counter
      -outputManager
