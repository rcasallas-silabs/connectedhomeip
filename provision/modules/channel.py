from enum import Enum
from abc import ABC, abstractmethod
import modules.util as _util


class Channel(ABC):
    NONE = 0x00
    RTT = 0x01
    BLE = 0x02

    def __init__(self, type) -> None:
        self.type = type

    @abstractmethod
    def open(self):
        pass

    @abstractmethod
    def close(self):
        pass

    @abstractmethod
    def write(self, data):
        pass

    @abstractmethod
    def read(self):
        pass

    @staticmethod
    def create(paths, args, conn):
        return JLinkChannel(paths, args, conn)

    @staticmethod
    def flush(chan, size):
        data_len = 0
        print("*** FLUSHIG {} ***".format(size))
        while(0 == data_len):
            data = chan.read()
            data_len = len(data)
            print("FLUSH({}) {}".format(data_len, data))
        print("*** FLUSHED ***")
