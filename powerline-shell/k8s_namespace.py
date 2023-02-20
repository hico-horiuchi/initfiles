import json
import re
import subprocess
from ..utils import BasicSegment


class Segment(BasicSegment):
    def add_to_powerline(self):
        powerline = self.powerline
        try:
            p = subprocess.Popen(["kubectl", "config", "view", "-o", "json"],
                                  stdout=subprocess.PIPE)
        except OSError:
            return
        pdata = p.communicate()
        if p.returncode != 0:
            return
        config = json.loads(pdata[0].decode("utf-8"))
        if config["contexts"] is None or len(config["contexts"]) == 0:
            return
        namespace = config["contexts"][0]["context"].get("namespace")
        if namespace is None:
            return
        powerline.append(' %s ' % namespace,
                         powerline.theme.AWS_PROFILE_FG,
                         powerline.theme.AWS_PROFILE_BG)
