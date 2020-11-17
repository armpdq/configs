#!/usr/bin/env python
import plugins
#import glob
#import os

class Plugin(plugins.BasePlugin):
    __name__ = 'open-files'

    def run(self, *unused):
        total = open('/etc/nixstats/open-files.txt', 'r').read().replace('\n', '')
        #total = 0
        #procs = glob.glob("/proc/*[0-9]*")
        #for p in procs:
        #    try: 
        #        c = len(os.listdir(p + '/fd'))
        #        total = total + c
        #    except Exception:
        #        # here error due permission
        #        pass

        results = {'open_files': total}
        return results

if __name__ == '__main__':
    Plugin().execute()
