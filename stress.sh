#!/bin/bash

ansible slows -i hosts -B 86400 -P 60 -a "stress-ng -c 4 -l 90" -f 2
