#! /usr/bin/env python

import sys
import struct
import binascii
import math
import hashlib

def checkHash(ver,prev_block,mrkl_root,time,bits):
  #  f = open('hash.txt','r');
  #  nonce = f.readline();
  #  nonce.strip();
  #  nonce = int(nonce);
    nonce = 3659389909;
    header = (struct.pack("<L", int(ver)) + prev_block.decode('hex')[::-1] + mrkl_root.decode('hex')[::-1] + struct.pack("<LLL", int(time), int(bits), int(nonce)));
    header_bin = header;
    #header_bin = header.decode('hex');
    for i in range(0,32):
     print "Chunk %d : 32'h%s;" % (i,header_bin[i*8:(i+1)*8]);
    hash = hashlib.sha256(hashlib.sha256(header_bin).digest()).digest()
    hash = hash[::-1].encode('hex');
    print hash
    if(int(hash,16) < findTarget(bits)):
        return True
    else:
        return False
  

def findTarget(bits):
    target = struct.pack(">L",bits);
    target = target.encode('hex');
    power = target[0:2];
    rem = target[2:];
    power = int(power, 16)
    rem = int(rem, 16)
    targetVal = rem * math.pow(2,(8*(power-3)));
    print targetVal
    #print hex(targetVal);


print checkHash(2,"00000000000000001b24f1e2ed553f5b1ea1e57391b6166be523dcff4fadd500","7405ef070b843244c9b7b11cb4137403a9ede4162b91661de94d3a403c9a397d",1418304289,404454260); #31451953602
