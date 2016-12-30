---
title: 'tmlelimma: Targeted Learning in high dimensions with the moderated
        t-statistic'
tags:
  - R language
  - targeted learning
  - multiple testing
  - bioinformatics
  - genomics
authors:
  - name: Nima Hejazi
    orcid: 0000-0002-7127-2789
    affiliation: 1
 - name: Wilson (Weixin) Cai
   orcid: 0000-0003-2680-3066
   affiliation: 1
 - name: Alan Hubbard
   orcid: 0000-0002-3769-0127
   affiliation: 1
affiliations:
 - name: Division of Biostatistics, University of California, Berkeley
   index: 1
date: 11 January 2017
bibliography: manuscript.bib
---

# Summary

we introduce and implement a method to identify genes
differentially expressed (based on the ATE) across subjects with varying levels of
benzene exposure.
\item We use targeted maximum likelihood estimation (TMLE), relying on the influence
curve of the proposed estimator, with the moderated t-statistic for gene expression.

Let $O=(W,A,Y)\sim{P_0}$, where W represents confounders, A the exposure of
interest, and $Y=({Y_b}, b=1,\dots,B)$ a vector of potential biomarkers. The
proposed target parameter is $\Psi_b(P_0)= E_W[E_0(Y_b|A=1,W) - E_0(Y_b|A=0,W)]$.

The moderated t-statistic \cite{smyth2005limma} for an asymptotically linear 
parameter estimate:
$\tilde{t}_j=\frac{\sqrt[]{n}(\Psi_j(P_n)-\psi_0)}{S_j(IC_{j,n})}$.

Our goal is to define $\Psi$ as the difference (per gene) in outcome between
receiving the maximum and minimum levels of treatment. Let: $\Psi_j$*=$E [ E[Y_j \mid
A = max(A), W]- E[Y_j \mid A = min(A), W]]$.

The heatmap visualizes the ATE difference induced by benzene exposure.

\newpage

# References
