#!/bin/bash
ROOT=$(dirname $(readlink -f $0) | rev | cut -c5- | rev) # Remove the bin directory
