# PhyloPipeline: Automated Phylogenetic Inference

This pipeline uses a combination of well-established software tools to streamline the process of generating a multiple sequence alignment, selecting an appropriate nucleotide substitution model, conducting bootstrap analyses, and estimating a maximum likelihood/parsimony tree.

This work was proposed in the Curricular Unit of Biology Analysis and Sequences of the bioinformatics course 
https://stuntspt.gitlab.io/asb2023/assignments/Assignment01.html

## Requirements
Before running PhyloPipeline, make sure you have the following software installed:

MAFFT (version 7 or later)
ModelTest-NG (version 0.1.6 or later)
RAxML-NG (version 1.0.2 or later)

## Usage
To run PhyloPipeline, simply execute the PhyloPipeline.sh script and follow the prompts:

`bash PhyloPipeline.sh`

The script will ask you to provide the name of a fasta file containing nucleotide sequences, and then guide you through the process of selecting a nucleotide substitution model and conducting bootstrap analyses. The final output will be a maximum likelihood tree based on the input sequences, as well as various log files and bootstrap files generated during the analysis.

## Disclaimer
PhyloPipeline is provided as-is and may not work for all use cases. Please consult the documentation for each individual software tool used in the pipeline for more information on their capabilities and limitations.

