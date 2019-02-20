#!/bin/bash
threads=$(nproc)

prodigal_exe='prodigal'
diamond_exe='diamond'
LM_scripts=''
mcl_bin=''

fasta="$2"

#Predicting ORFs, diamond all-vs-all
"$prodigal_exe" -i "$fasta" -a predicted_prot.faa -o orfs.gff -p meta -q -f gff
"$diamond_exe" makedb --in predicted_prot.faa -d proteins_database.dmnd
"$diamond_exe" blastp --db proteins_database.dmnd -q predicted_prot.faa -o diamond_result.txt --quiet

#Filtering of an alignment result, proteins with hits with bitscore > 50 considered as related
awk -F'\t' -v OFS='\t' '($1 != $2) && $12 > 50 {print $1, $2, $11}' diamond_result.txt > protein_graphs.txt

#Generation of protein families
"$mcl_bin"mcxload -abc protein_graphs.txt --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)' -o protein_graphs.mci -write-tab protein_graphs.tab
"$mcl_bin"mcl protein_graphs.mci -I 2
"$mcl_bin"mcxdump -icl out.protein_graphs.mci.I20 -tabr protein_graphs.tab -o clusters.protein_graphs.mci.I20

#Pairwise comparison of contigs and assessment of shared gene content
"$LM_scripts"hypergeom.py clusters.protein_graphs.mci.I20


#Building clusters of genomes
"$mcl_bin"mcxload -abc genome_graphs.txt --stream-mirror -o genome_graphs.mci -write-tab genome_graphs.tab

"$mcl_bin"mcl genome_graphs.mci -I 1.2
"$mcl_bin"mcl genome_graphs.mci -I 2
"$mcl_bin"mcl genome_graphs.mci -I 4
"$mcl_bin"mcl genome_graphs.mci -I 6
"$mcl_bin"mcxdump -icl out.genome_graphs.mci.I12 -tabr genome_graphs.tab -o clusters.genome.mci.I12
"$mcl_bin"mcxdump -icl out.genome_graphs.mci.I20 -tabr genome_graphs.tab -o clusters.genome.mci.I20
"$mcl_bin"mcxdump -icl out.genome_graphs.mci.I40 -tabr genome_graphs.tab -o clusters.genome.mci.I40
"$mcl_bin"mcxdump -icl out.genome_graphs.mci.I60 -tabr genome_graphs.tab -o clusters.genome.mci.I60
