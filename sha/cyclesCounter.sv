// $Id: $
// File name:   counter.sv
// Created:     11/29/2014
// Author:      Sheik Dawood
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: counter


module counter
  #(
    parameter BITS = 6;
    )
   (
    input wire clk,
    input wire n_rst,
    
    );
   
