from datetime import datetime


class StopWatch:
    """Stop watch for execution time analysis"""
    def __init__(self):
        self.start = datetime.now()

    def reset(self):
        self.start = datetime.now()
        
    def elapsed_seconds(self):
        e = datetime.now() - self.start
        return  e.seconds
    def elapsed_microseconds(self):
        e = datetime.now() - self.start
        return  e.microseconds
    def elapsed_milliseconds(self):
        e = datetime.now() - self.start
        return  e.microseconds/1000.0

