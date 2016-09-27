#!/bin/bash
# macbattpercentage

# found on: http://hints.macworld.com/article.php?story=20100130123935998
ioreg -l | grep -i capacity | tr '\n' ' | ' | awk '{printf("%.2f%%\n", $10/$5 * 100)}'
