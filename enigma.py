import hashlib
import struct
import os

class Vessel:
    def __init__(self, seed: bytes):
        self.state = bytearray(seed)
        self.entropy = 0

    def mutate(self, cycle: int):
        for _ in range(cycle):
            mask = os.urandom(16)
            for i in range(16):
                self.state[i] ^= mask[i]
            self.state = bytearray(hashlib.sha3_256(self.state).digest()[:16])
            self.entropy += 1

    def extract(self) -> int:
        return struct.unpack('<Q', self.state[:8])[0] ^ struct.unpack('<Q', self.state[8:16])[0]

def synthesize(vectors: list) -> bytes:
    v = Vessel(b'\x00' * 16)
    for vec in vectors:
        v.mutate(vec % 64)
    return v.state