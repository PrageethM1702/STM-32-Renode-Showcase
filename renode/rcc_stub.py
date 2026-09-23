CR_OFFSET = 0x00
CFGR_OFFSET = 0x08

HSEON_BIT = 1 << 16
HSERDY_BIT = 1 << 17

SW_MASK = 0x3
SWS_SHIFT = 2
SWS_MASK = 0x3 << SWS_SHIFT

state = {"cr": 0, "cfgr": 0}


def reset():
    state["cr"] = 0
    state["cfgr"] = 0


def readDoubleWord(offset):
    if offset == CR_OFFSET:
        return state["cr"]
    if offset == CFGR_OFFSET:
        return state["cfgr"]
    return 0


def writeDoubleWord(offset, value):
    if offset == CR_OFFSET:
        state["cr"] = value
        if value & HSEON_BIT:
            state["cr"] |= HSERDY_BIT
        else:
            state["cr"] &= ~HSERDY_BIT
    elif offset == CFGR_OFFSET:
        sw = value & SW_MASK
        state["cfgr"] = (value & ~SWS_MASK) | (sw << SWS_SHIFT)