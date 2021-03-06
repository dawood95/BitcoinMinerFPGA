#!/usr/bin/env python

import sys
import struct
import binascii



def process(ver,prev_block,mrkl_root,time,bits,nonce = 0):

   rrot = lambda x, n: (x >> n) | (x << (32 - n));

   header = (struct.pack("<L", int(ver)) + prev_block.decode('hex')[::-1] + mrkl_root.decode('hex')[::-1] + struct.pack("<LLL", int(time), int(bits), int(nonce)) + struct.pack(">LLLLLLLLLLLL",int(2147483648),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(0),int(640)));
   
   hexh = header.encode('hex')
   #print hexh;
   #for i in range(0,32):
   #   print "Chunk %d : 32'h%s;" % (i,hexh[i*8:(i+1)*8]);
      
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
    
   w = [];
   midState = [];
   remainingHeader = [];
   
   for i in range(16,32):
      remainingHeader.append(int(hexh[i*8:(i+1)*8],16));
   for i in range(0,16):
      w.append(int(hexh[i*8:(i+1)*8],16));
   
   #print w;
   for i in range(16, 64):
      s0 = rrot(w[i - 15], 7) ^ rrot(w[i - 15], 18) ^ (w[i - 15] >> 3)
      s1 = rrot(w[i - 2], 17) ^ rrot(w[i - 2], 19) ^ (w[i - 2] >> 10)
      w.append((w[i - 16] + s0 + w[i - 7] + s1) & 0xffffffff)

   a = h0
   b = h1
   c = h2
   d = h3
   e = h4
   f = h5
   g = h6
   h = h7
     
   for i in range(64):
      s0 = rrot(a, 2) ^ rrot(a, 13) ^ rrot(a, 22)
      maj = (a & b) ^ (a & c) ^ (b & c)
      t2 = s0 + maj
      s1 = rrot(e, 6) ^ rrot(e, 11) ^ rrot(e, 25)
      ch = (e & f) ^ ((~ e) & g)
      t1 = h + s1 + ch + k[i] + w[i]
      
      h = g
      g = f
      f = e
      e = (d + t1) & 0xffffffff
      d = c
      c = b
      b = a
      a = (t1 + t2) & 0xffffffff
      
   h0 = (h0 + a)& 0xffffffff
   h1 = (h1 + b)& 0xffffffff
   h2 = (h2 + c)& 0xffffffff
   h3 = (h3 + d)& 0xffffffff
   h4 = (h4 + e)& 0xffffffff
   h5 = (h5 + f)& 0xffffffff
   h6 = (h6 + g)& 0xffffffff
   h7 = (h7 + h)& 0xffffffff
   
   midState.append(h0);
   midState.append(h1);
   midState.append(h2);
   midState.append(h3);
   midState.append(h4);
   midState.append(h5);
   midState.append(h6);
   midState.append(h7);

   print midState
   print remainingHeader
   return (midState, remainingHeader);
 

(midState,remainingHeader) = process(2,"00000000000000001b24f1e2ed553f5b1ea1e57391b6166be523dcff4fadd500","7405ef070b843244c9b7b11cb4137403a9ede4162b91661de94d3a403c9a397d",1418304289,404454260); #3145195360

f = open('block1.txt','w');

for i in range(8):
   f.write(str(midState[7-i])+'\n');
for i in range(16):
   f.write(str(remainingHeader[15-i])+'\n');

f.close();

(midState,remainingHeader) = process(2,"0000000000000000147d2e037c36758cad7766776f3cda4b410c13ef6940450c","466988bb8d1dd20b8f3191b417205dd0c0fbe0ff65d4df3959503f550467dd71",1418303507,404454260); #3320476258

f = open('block2.txt','w');

for i in range(8):
   f.write(str(midState[7-i])+'\n');
for i in range(16):
   f.write(str(remainingHeader[15-i])+'\n');

f.close();

(midState,remainingHeader) = process(2,"000000000000000013d92aa75332c45216263abb4791a1ffa500937659dea39c","8f7291f943fdc955f95bae43dabb498e6028495ddb32905ee9ae42da75adb588",1418298192,404454260); #1817244012

f = open('block3.txt','w');

for i in range(8):
   f.write(str(midState[7-i])+'\n');
for i in range(16):
   f.write(str(remainingHeader[15-i])+'\n');

f.close();

(midState,remainingHeader) = process(2,"000000000000000018e69a7966bcbb5d90830f1f423c06e91f0926fd5c4fc58a","5f68edbc46ceb6c4c8ad02a0ce75c1a37843d0f9cd1e4c1facb9778cda364c3f",1418292662,404454260); #3410099896

f = open('block4.txt','w');

for i in range(8):
   f.write(str(midState[7-i])+'\n');
for i in range(16):
   f.write(str(remainingHeader[15-i])+'\n');

f.close();

(midState,remainingHeader) = process(2,"00000000000000001b17bf5332fda9558ab0ac3eee7be3a8e9f7b076704570c9","9197defd4afedaa6884765a3072dbdf894539a14d062212646edd7de631a6e1b",1418294221,404454260); #3504277341

f = open('block5.txt','w');

for i in range(8):
   f.write(str(midState[7-i])+'\n');
for i in range(16):
   f.write(str(remainingHeader[15-i])+'\n');

f.close();


