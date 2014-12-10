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
    nonce = 990370605;
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


print checkHash(2,"0000000000000000098ed12e54156f30b2fae4c8cc0da5389cf8f1c6f42d3751","8e192530f5a7e4a4e5b9dd1d2f029cb92c03d8e4eccfeeb40ebc9e524fe57317",1418212969,404454260);
