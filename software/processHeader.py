#!/usr/bin/env python

import sys
import struct

def mask(n):
   if n >= 0:
      return 2**n - 1
   else:
      return 0

def rr(n, rotations=1, width=32):
   rotations %= width
   n &= mask(width)
   return (n >> rotations) | ((n << (width - rotations)) & mask(width))

def rs(n, shift):
   return n>>shift & 0xffffffff

def process(ver,prev_block,mrkl_root,time,bits,nonce = 0):

   header = (struct.pack("<L", int(ver)) + prev_block.decode('hex')[::-1] + mrkl_root.decode('hex')[::-1] + struct.pack("<LLL", int(time), int(bits), int(nonce)) + struct.pack(">LLLLLLLLLLLL",int(2147483648),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(640)));
   
   hexh = header.encode('hex')
   print hexh;
   for i in range(0,32):
      print "Chunk %d : 32'h%s;" % (i,hexh[i*8:(i+1)*8]);
      
   k = [
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2 
   ];
   
   h0 = 0x6a09e667;
   h1 = 0xbb67ae85;
   h2 = 0x3c6ef372;
   h3 = 0xa54ff53a;
   h4 = 0x510e527f;
   h5 = 0x9b05688c;
   h6 = 0x1f83d9ab;
   h7 = 0x5be0cd19;
    
   W = [];
   midState = [];
   remainingHeader = [];
   
   for i in range(16,32):
      remainingHeader.append(int(hexh[i*8:(i+1)*8],16));
   for i in range(0,16):
      W.append(int(hexh[i*8:(i+1)*8],16));
      
   for i in range(16,64):
      s0 = rr(W[i-15], 7) ^ rr(W[i-15], 18) ^ rs(W[i-15], 3);
      s1 = rr(W[i-2], 17) ^ rr(W[i-2], 19) ^ rs(W[i-2], 10);
      W.append(W[i-16] + s0 + W[i-7] + s1);

   a = h0
   b = h1
   c = h2
   d = h3
   e = h4
   f = h5
   g = h6
   h = h7
     
   for i in range(0,64):
      S1 = rr(e,6) ^ rr(e,11) ^ rr(e,25);
      ch = (e & f) ^ ((~e) & g);
      temp1 = h + S1 + ch + k[i] + W[i]
      S0 = rr(a,2) ^ rr(a,13) ^ rr(a,22);
      maj = (a & b) ^ (a & c) ^ (b & c);
      temp2 = S0 + maj
      h = g
      g = f
      f = e
      e = d + temp1
      d = c
      c = b
      b = a
      a = temp1 + temp2
      
   h0 = h0 + a
   h1 = h1 + b
   h2 = h2 + c
   h3 = h3 + d
   h4 = h4 + e
   h5 = h5 + f
   h6 = h6 + g
   h7 = h7 + h   
   
   midState.append(h0);
   midState.append(h1);
   midState.append(h2);
   midState.append(h3);
   midState.append(h4);
   midState.append(h5);
   midState.append(h6);
   midState.append(h7);

   print "\nMid State: \n \n"
   for i in range(0,8):
      print struct.pack('L',int(midState[i]));
   print "\nRemaining Header: \n \n"
   print remainingHeader

process(2,"00000000000000000460014ddf050359a44c5e7ca1ba33c2ec509abce58a1a80","0e7e4505929fc0678ae2f6cd7a3441484f6935fa2ca36d584c5048ae2436b81d",1418002670,404454260);

