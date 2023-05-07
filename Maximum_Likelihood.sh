#!/bin/bash

# Ask user for the name of the fasta file
read -p "Enter the name of the fasta file: " fasta_file

#Will align the fasta file
mafft --auto "$fasta_file" --reorder > "$fasta_file"_Alg.fasta

# Run modeltest-ng with default settings
modeltest-ng -i "$fasta_file"_Alg -d nt -p 2 -T raxml -o "$fasta_file"_modeltest_output.txt

# Ask user for the model name
read -p "Enter the name of the model you want to use: " model_name

# Run raxml-ng with the specified model and parameters
raxml-ng --msa "$fasta_file"_Alg --model "$model_name" --prefix T1 --threads 1 --seed 1234 --tree pars{25},rand{25}
raxml-ng --msa "$fasta_file"_Alg --model "$model_name" --prefix T2 --threads 1 --seed 5678 --tree pars{50},rand{50}
raxml-ng --msa "$fasta_file"_Alg --model "$model_name" --prefix T3 --threads 1 --seed 9999 --tree pars{75},rand{75}
raxml-ng --msa "$fasta_file"_Alg --model "$model_name" --prefix T4 --threads 1 --seed 24680 --tree pars{100},rand{100}

# Combine the final log likelihood values from the previous step
grep "Final LogLikelihood:" T{1,2,3,4}.raxml.log > Final_LogLikelihood_"$fasta_file".txt

# Run raxml-ng with bootstrap option
raxml-ng --bootstrap --msa "$fasta_file"_Alg --model "$model_name" --prefix T5 --seed 314159 --threads 1 --bs-trees 5000
raxml-ng --bootstrap --msa "$fasta_file"_Alg --model "$model_name" --prefix T6 --seed 777777 --threads 1 --bs-trees 5000

# Combine all bootstraps
cat T5.raxml.bootstraps T6.raxml.bootstraps > allbootstraps

# Run raxml-ng with bsconverge option
raxml-ng --bsconverge --bs-trees allbootstraps --prefix T7 --seed 2023 --threads 1 --bs-cutoff 0.03

# Run raxml-ng 
raxml-ng --all --msa "$fasta_file"_Alg --model "$model_name" --prefix T8 --seed 27 --threads 1 --bs-metric fbp,tbe