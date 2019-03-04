---
title: 'PFHub: The Phase Field Community Hub'
tags:
  - phase-field
  - materials-science
  - jekyll-website
  - reproducible-science
authors:
  - name: Daniel Wheeler
    orcid: 0000-0002-2653-7418
    affiliation: 1
  - name: Trevor Keller
    orcid: 0000-0002-2920-8302
    affiliation: 1
affiliations:
 - name: >
     Materials Science and Engineering Division,
     National Institute of Standards and Technology,
     Gaithersburg MD
   index: 1
date: 1 March 2019
bibliography: paper.bib
---

# Summary

Small scientific communities often require web infrastructure for
sharing and displaying data tailored to specific needs. The approach
used by the PFHub framework uses existing tools to provide a workflow
for uploading and viewing data requiring only a limited outlay on
custom development and configuration. The PFHub framework currently
supports phase field practitioners and code developers participating
in an effort to improve quality assurance for phase field codes. The
main thrust of this effort is the generation of a set of standardized
benchmark problems [@bm1, @bm2] along with a
web framework for uploading and comparing benchmark results.

# Context

The phase field method (PFM) describes material interfaces at the
mesoscopic scale between atomic scale models and macroscale
models. The PFM is well established and there are an assortment of
code frameworks (e.g. Moose [@moose], PRISMS-PF [@prisms-pf], FiPy
[@fipy], MMSP [@mmsp]) available for solving the wide variety of
phenomena associated with phase field (e.g. dendritic growth, spinodal
decomposition, grain growth). However, phase field research groups
often develop codes in isolation and do not publish the code bases or
do not support or distribute the code bases to the wider
community. PFHub is a community effort spearheaded by the Center for
Hierarchical Materials Design and the National Institute of Standards
and Technology to support the development of phase field codes. The
goal of PFHub is to improve cross-collaboration between phase field
code developers and practioners by providing a site to compare results
from different codes on a standardized set of benchmark problems.

# Website

The PFHub website provides a facility for uploading, displaying and
comparing results from the benchmarks problems. The website uses the
Jekyll static website generator along with automated frontend
processing to host all the content avoiding the use of a content
management system (CMS-free). CMS's are generally costly to maintain
especially for small scientific communities with limited funding and
manpower [@csmfree].

The workflow for uploading benchmark resuls relies on third party tools
and constist of four steps:

 - The users are first required to archive simuolatioon results at a
   recommended archival resource such as figshare.

 - filling in a metadata web form on the website with links to the
   achieved data

 - the submitted data is automatically added as a pull request in a
   new directory with a meta.yaml file describing the new upload using
   Staticman

 - Travis CI checks the data and launches a new version of the website
   using Surge to review using a pull request.

The frontend of the website is programmed in Coffeescript using in a
functional manner. The A combination of Jekyll templates and
Coffeescript is used to access the data from the meta.yaml completely
avoiding any back-end storage requirements and making the data records
more transparent in the long run when interest in the project and
development has ceased. Third partly storage services, such as
Figshare, will likely have a longer time horizon than most funding
cycles for typical scientific projects. The PFHub infrastructure
provides a template for other small scientific communities to host
custom content and integrate data from members of the community.

# Acknowledgements

Acknowlege MGI funding???

# References
