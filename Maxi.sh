#!/bin/bash

# Ask user for the name of the fasta file
read -p "Enter the name of the fasta file: " fasta_file

# Run modeltest-ng with default settings
modeltest-ng -i "$fasta_file" -d nt -p 4 -T raxml -o ASF-Like_Alg_output.txt

# Ask user for the model name
read -p "Enter the name of the model you want to use: " model_name

# Run raxml-ng with the specified model and parameters
raxml-ng --msa "$fasta_file" --model "$model_name" --prefix T1 --threads 2 --seed 1234 --tree pars{25},rand{25}
raxml-ng --msa "$fasta_file" --model "$model_name" --prefix T2 --threads 2 --seed 5678 --tree pars{50},rand{50}
raxml-ng --msa "$fasta_file" --model "$model_name" --prefix T3 --threads 2 --seed 9999 --tree pars{75},rand{75}
raxml-ng --msa "$fasta_file" --model "$model_name" --prefix T4 --threads 2 --seed 24680 --tree pars{100},rand{100}

# Combine the final log likelihood values from the previous step
grep "Final LogLikelihood:" T{1,2,3,4}.raxml.log > Final_LogLikelihood_"$fasta_file".txt

# Run raxml-ng with bootstrap option
raxml-ng --bootstrap --msa "$fasta_file" --model "$model_name" --prefix T5 --seed 314159 --threads 2 --bs-trees 2000
raxml-ng --bootstrap --msa "$fasta_file" --model "$model_name" --prefix T6 --seed 777777 --threads 2 --bs-trees 2000

# Combine all bootstraps
cat T5.raxml.bootstraps T6.raxml.bootstraps > allbootstraps

# Run raxml-ng with bsconverge option
raxml-ng --bsconverge --bs-trees allbootstraps --prefix T7 --seed 2023 --threads 1 --bs-cutoff 0.03

# Ask user for the name of the best tree file to use
read -p "Enter the name of the best tree file you want to use: " best_tree_file

# Run raxml-ng with the specified best tree file
raxml-ng --support --tree "$best_tree_file" --bs-trees allbootstraps --prefix T8 --threads 2
