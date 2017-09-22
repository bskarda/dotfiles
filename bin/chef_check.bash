#!/bin/bash

set -xeuo pipefail
IFS=$'\n\t'

chef exec foodcritic . && \
chef exec cookstyle . && \
chef exec rspec && \
chef exec kitchen test all --destroy=always
