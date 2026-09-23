import random

SR_OFFSET = 0x00
CR1_OFFSET = 0x04
CR2_OFFSET = 0x08
SQR3_OFFSET = 0x34
DR_OFFSET = 0x4C

EOC_BIT = 1 << 1
SWSTART_BIT = 1 << 30

state = {"sr": 0, "cr1": 0, "cr2": 0, "sqr3": 0, "dr": 0}


def reset():
    state["sr"] = 0
    state["cr1"] = 0
    state["cr2"] = 0
    state["sqr3"] = 0
    state["dr"] = 0


def readDoubleWord(offset):
    if offset == SR_OFFSET:
        return state["sr"]
    if offset == CR1_OFFSET:
        return state["cr1"]
    if offset == CR2_OFFSET:
        return state["cr2"]
    if offset == SQR3_OFFSET:
        return state["sqr3"]
    if offset == DR_OFFSET:
        state["sr"] &= ~EOC_BIT
        return state["dr"]
    return 0


def writeDoubleWord(offset, value):
    if offset == SR_OFFSET:
        state["sr"] = value
    elif offset == CR1_OFFSET:
        state["cr1"] = value
    elif offset == CR2_OFFSET:
        state["cr2"] = value
        if value & SWSTART_BIT:
            state["dr"] = random.randint(1800, 2300)
            state["sr"] |= EOC_BIT
    elif offset == SQR3_OFFSET:
        state["sqr3"] = value