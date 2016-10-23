#!/bin/bash

ansible slows -i hosts -B 86400 -P 60 -a "stress-ng --cpu 4" -f 1
