#!/usr/bin/env python2
from __future__ import division
import scipy.stats as stats
import re
import math
import sys

clusters = sys.argv[1]

families = {}
names2 = []
with open(clusters) as file2:
    for line in file2:
        dat = line.strip().split('\t')
        for i in dat:
            contig = re.search('(\S+)_\d+', i).group(1)
            families[contig] = set()
            names2.append(contig)

names = list(set(names2))

with open(clusters) as file1:
    count = 1
    for line in file1:
        dat = line.strip().split('\t')
        for i in dat:
            k = re.search('(\S+)_\d+', i).group(1)
            if k in families:
                families[k].add('family_' + str(count))
        count += 1
total = []
file_out = open('genome_graphs.txt', 'w')
for i in range(len(names)):
    for j in range(len(names)):
        if names[i] != names[j]:
            common = len(families[names[i]].intersection(families[names[j]]))
            c = max(len(families[names[i]]), len(families[names[j]]))
            b = min(len(families[names[i]]), len(families[names[j]]))
            p = stats.hypergeom.sf(common - 1, count - 1, c, b)
            if p != 0:
                link_strength = - math.log10(p * (len(names) * (len(names) - 1) / 2))
                if link_strength > 0 and names[i] != names[j]:
                    l = [names[i], names[j], str(link_strength)]
                    file_out.write('\t'.join(l) + '\n')
            else:
                l = [names[i], names[j], "100"]
                file_out.write('\t'.join(l) + '\n')
file_out.close()
