# LMCLUST

This is an implementation of Lima-Mendez *et al.* (DOI: 10.1093/molbev/msn023) method of clustering of bacteriophages based on gene shared content.

## Dependencies

* Prodigal  - ORFs caller (DOI: 10.1186/1471-2105-11-119)
* Diamond  - homology search engine (DOI: https://doi.org/10.1038/nmeth.3176)
* MCL  - clustering algorithm (DOI: https://doi.org/10.1137/040608635)

## How to run

If everithing in PATH and executable:

```
LMCLUST phages_genomes.fasta 

```

Otherwise, add paths inside the LMCLUST script
