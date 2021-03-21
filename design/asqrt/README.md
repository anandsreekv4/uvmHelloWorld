SQRT block
- No need for handshake, as async is handled with the register.
- Output of sqrt is fed only to the register.
- The SQRT should send out a data rdy signal
- Once the valid comes in, the data should be written into the FIFO.

SQRT concept

