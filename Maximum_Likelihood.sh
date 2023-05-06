#!/bin/bash

# PhyloBuilder - A tool for building phylogenetic trees

# Ask the user for the name of the FASTA file
read -p "Enter the name of the FASTA file: " fasta_file

# Run ModelTest-NG to determine the best-fit model of evolution
model=$(modeltest-ng -i "$fasta_file" -d nt -p 2 -T raxml -o "${fasta_file}_modeltest_output.txt" | grep "Best model:" | cut -d ' ' -f 3)

# Display the recommended model to the user
echo "The recommended model of evolution is: $model"

# Ask the user if they want to use the recommended model or specify their own
read -p "Do you want to use the recommended model (Y/n)? " use_recommended_model

if [[ $use_recommended_model == "n" || $use_recommended_model == "N" ]]; then
  # Ask the user for the name of the model they want to use
  read -p "Enter the name of the model you want to use: " model
fi

# Run RAxML-NG to build the phylogenetic tree
for i in {1..4}; do
  raxml-ng --msa "$fasta_file" --model "$model" --prefix T${i} --threads 1 --seed $((1234+$i*1111)) --tree pars{$((25*i))},rand{$((25*i))} 
done

# Combine the final log likelihood values from the previous step
grep "Final LogLikelihood:" T{1,2,3,4}.raxml.log > Final_LogLikelihood_"$fasta_file".txt

# Run RAxML-NG with bootstrap option
for i in {5..6}; do
  raxml-ng --bootstrap --msa "$fasta_file" --model "$model" --prefix T${i} --seed $((111111*$i)) --threads 1 --bs-trees 5000
done

# Combine all bootstraps
cat T5.raxml.bootstraps T6.raxml.bootstraps > allbootstraps

# Run RAxML-NG with bsconverge option
raxml-ng --bsconverge --bs-trees allbootstraps --prefix T7 --seed 2023 --threads 1 --bs-cutoff 0.03

# Run RAxML-NG to build the final tree with bootstrapping
raxml-ng --all --msa "$fasta_file" --model "$model" --prefix T8 --seed 27 --threads 1 --bs-metric fbp,tbe
