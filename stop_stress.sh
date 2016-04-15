#!/bin/bash

ansible all -i hosts -a "pkill stress-ng"
