#!/bin/bash

# Ask user for the name of the input fasta file
read -p "Enter the name of the input fasta file: " input_file

# Run modeltest-ng with default settings
modeltest-ng -i "$input_file" -d nt -p 1 -T raxml -o "${input_file%.*}_output.txt"

# Ask user for the model name
read -p "Enter the name of the model you want to use: " model_name

# Run raxml-ng with the specified model and parameters
raxml-ng --msa "$input_file" --model "$model_name" --prefix TP1k --tree pars{25},rand{25} --bs-trees 1000 --threads 1 --seed 1234
raxml-ng --msa "$input_file" --model "$model_name" --prefix TP10k --tree pars{50},rand{50} --bs-trees 10000 --threads 1 --seed 5678

# Combine the final log likelihood values from the previous step
grep "Final LogLikelihood:" TP1k.raxml.log TP10k.raxml.log > Final_LogLikelihood_"${input_file%.*}".txt

# Run raxml-ng with bootstrap option and bsconverge option
raxml-ng --bootstrap --msa "$input_file" --model "$model_name" --prefix TP_bs --seed 9999 --threads 1 --bs-trees 1000 --bs-cutoff 0.03
raxml-ng --bsconverge --bs-trees TP_bs.raxml.bootstraps --prefix TP_converge --seed 2023 --threads 1 --bs-cutoff 0.03

# Run raxml-ng with all options
raxml-ng --all --msa "$input_file" --model "$model_name" --prefix TP_all --seed 27 --threads 1 --bs-metric fbp,tbe --bs-trees 1000 --bs-cutoff 0.03 --tree pars{100},rand{100}
