#!/bin/bash

# run this from the root of the data_bags folder in chef-policy

for databag in $(chef exec knife data bag list); do
  for item in $(chef exec knife data bag show $databag); do
    mkdir -p $databag/
    knife raw /data/$databag/$item > $databag/$item.json
  done;
done
