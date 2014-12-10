#! /usr/bin/env python

import sys
import struct
import binascii
import math
import hashlib

def checkHash(ver,prev_block,mrkl_root,time,bits):
    f = open('hash.txt','r');
    nonce = f.readline();
    nonce.strip();
    nonce = int(nonce);
    header = (struct.pack("<L", int(ver)) + prev_block.decode('hex')[::-1] + mrkl_root.decode('hex')[::-1] + struct.pack("<LLL", int(time), int(bits), int(nonce)));
    header_bin = header;
    #header_bin = header.decode('hex');
    for i in range(0,32):
     print "Chunk %d : 32'h%s;" % (i,header_bin[i*8:(i+1)*8]);
    hash = hashlib.sha256(hashlib.sha256(header_bin).digest()).digest()
    hash = hash[::-1].encode('hex');
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


checkHash(2,"00000000000000001af51dcc599ca5c8ca80f823a7ab2400e301e7bfc129e940","c400ab7d5b0b274bcc8275945f82a3f807cf5d271350fe4b777fc5a4feea6ec1",1417549430,404441185);
