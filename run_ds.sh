#!/bin/bash

# Params: $0 <dataset> <max_cores=4> <runs=5> <min_cores=4>

if [ -z "$1" ]; then
    dataset="1B"
else
    dataset="$1"
fi

if [ -n "$2" ]; then
    max_cores="$2"
else
    max_cores=4
fi

if [ -n "$3" ]; then
    runs="$3"
else
    runs=5
fi

if [ -n "$4" ]; then
    min_cores="$4"
else
    min_cores=4
fi

if [[ $dataset != *"10K" ]]; then
    user_list=("buybackoff" "noahfalk" "nietras" "xoofx" "kpocza" "austindonisan" "dzaima" "lehuyduc" "mtopolnik-rs" "abeobk" "artsiomkorzun" "jerrinot" "mtopolnik" "thomaswue" "royvanrijn" "pedrosakuma")
else
    user_list=("buybackoff" "noahfalk" "nietras" "xoofx" "kpocza" "dzaima" "lehuyduc" "mtopolnik-rs" "abeobk" "artsiomkorzun" "jerrinot" "mtopolnik" "thomaswue" "royvanrijn" "pedrosakuma")
fi

for username in "${user_list[@]}"; do

    counter=$min_cores
    last_counter=$counter
    while [ "$counter" -le "$max_cores" ]; do
        # Non hyper-threaded
        source run.sh $username $counter $counter $dataset $runs
        # Hyper-threaded
        source run.sh $username $counter $((counter * 2)) $dataset $runs

        last_counter=$counter
        counter=$((counter * 2))
    done

    if [ "$last_counter" -lt "$max_cores" ]; then
        counter=$max_cores
        # Non hyper-threaded
        source run.sh $username $counter $counter $dataset $runs
        # Hyper-threaded
        source run.sh $username $counter $((counter * 2)) $dataset $runs
    fi

done