#!/bin/bash

# Get input file name from user
echo "Please enter the name of the input fasta file:"
read filename

#Will align the fasta file
mafft --auto "$filename" --reorder > "$filename"_Alg.fasta

# Run modeltest-ng with input fasta file
modeltest-ng -i "$filename" -d nt -p 1 -T raxml -o "${filename%.*}_output.txt"

# Get model name from user
echo "Please enter the name of the model you want to use:"
read modelname

# Run raxml-ng with input fasta file and user-specified model
raxml-ng --msa "$filename" --model "$modelname" --prefix TP1k --tree parsimony --bs-trees 1000 --threads 1
raxml-ng --msa "$filename" --model "$modelname" --prefix TP10k --tree parsimony --bs-trees 10000 --threads 1