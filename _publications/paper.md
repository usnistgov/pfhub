---
title: 'PFHub: The Phase-Field Community Hub'
tags:
  - phase-field
  - materials-science
  - jekyll-website
  - benchmarks
authors:
  - name: Daniel Wheeler
    orcid: 0000-0002-2653-7418
    affiliation: 1
  - name: Trevor Keller
    orcid: 0000-0002-2920-8302
    affiliation: 1
  - name: Stephen J. DeWitt
    orcid: 0000-0002-9550-293X
    affiliation: 6
  - name: Andrea M. Jokisaari
    orcid: 0000-0002-4945-5714
    affiliation: 5
  - name: Daniel Schwen
    orcid: 0000-0002-8958-4748
    affiliation: 5
  - name: Jonathan E. Guyer
    orcid: 0000-0002-1407-6589
    affiliation: 1
  - name: Larry Aagesen
    affiliation: 5
  - name: Olle G. Heinonen
    orcid: 0000-0002-3618-6092
    affiliation: 2
  - name: Peter W. Voorhees
    affiliation: 4
  - name: James A. Warren
    orcid: 0000-0001-6887-1206
    affiliation: 3
affiliations:
  - name: >
      Materials Science and Engineering Division,
      Material Measurement Laboratory,
      National Institute of Standards and Technology,
      Gaithersburg, MD 20899 USA
    index: 1
  - name: >
      Argonne National Laboratory,
      Lemont, IL 60439 USA
    index: 2
  - name: >
      Laboratory Office,
      Material Measurement Laboratory,
      National Institute of Standards and Technology,
      Gaithersburg, MD 20899 USA
    index: 3
  - name: >
      Department of Materials Science and Engineering,
      Northwestern University,
      Evanston, IL 60208 USA
    index: 4
  - name: >
      Fuel Modeling and Simulation Department,
      Idaho National Laboratory,
      Idaho Falls, ID 83415 USA
    index: 5
  - name: >
      Materials Science and Engineering Department,
      University of Michigan,
      Ann Arbor, MI 48109 USA
    index: 6
  - name: >
      Materials Science and Engineering Department,
      University of Michigan,
      Ann Arbor, MI 48109 USA
    index: 7
date: 1 March 2019
bibliography: paper.bib
---

# PFHub: The Phase-Field Community Hub

## Summary

Scientific research communities often require an online portal to
summarize a shared challenge, collect attempts at a solution, and
present a quantitative comparison of past attempts in a compelling
way. An examplar of such a portal is $\mu$MAG [@mumag]. The reusable
PFHub framework leverages existing online services to build a static
portal website that is considerably easier to deploy and maintain
without sacrificing content or scope. The first deployment of the
PFHub framework supports phase-field practitioners and code developers
participating in an effort to improve quality assurance for
phase-field codes.

## Context

The phase-field method (PFM) describes material interfaces at the
mesoscopic scale between atomic scale models and macroscale models.
The PFM is well established and there are an assortment of code
frameworks (*e.g.*, Moose [@moose], PRISMS-PF [@prisms-pf], FiPy
[@fipy], MMSP [@mmsp]) available for solving the wide variety of
phenomena associated with phase-field (*e.g.*, dendritic growth,
spinodal decomposition, grain growth). However, phase-field research
groups often develop codes in isolation and do not publish the code
bases or do not support or distribute the code bases to the wider
community. PFHub is a community effort spearheaded by the Center for
Hierarchical Materials Design at Northwestern University and the
National Institute of Standards and Technology to support the
development of phase-field codes. The goal of PFHub is to improve
cross-collaboration between phase-field code developers and
practitioners by providing a standardized set of benchmark problems
[@bm1, @bm2] along with a web framework for uploading and comparing
benchmark results from different codes.

## Website

The PFHub website provides a facility for uploading, displaying and
comparing results from the benchmark problems. The website uses the
Jekyll static website generator along with automated frontend
processing to eliminate the need for content management systems
[@cmsfree], which are generally costly to maintain especially for
small scientific communities with limited funding and manpower.

The workflow for uploading benchmark results relies on third party
tools using the following steps, illustrated in Fig. 1.

- The users are first required to archive simulation outputs at an
  archival resource (*e.g.*, Figshare) configured with permissive
  cross-origin resource sharing (CORS).
- The metadata summarizing each simulation is entered into a form on
  the website, including relevant details such as memory usage, run
  time and links to the data archived in the first step.
- Upon submission, the Staticman app [@staticman] submits the entered
  metadata as a GitHub pull request to the PFHub GitHub repository.
  The metadata is stored in a YAML file with a unique path in the
  repository.
- Travis CI [@travis] performs linting on the submission and then
  launches a new version of the website using Surge [@surge.sh]. The
  PFHub admins can then examine the new submission and further changes
  can be made if necessary.
- Once review has been completed to the satisfaction of both the 
  uploading scientist and the website maintainers, the pull request
  is merged and served to the World Wide Web using a hosting service
  compatible with GitHub Pages.

A combination of Jekyll templates and Coffeescript is used to access
and download the data links in the submitted YAML files and then
display the data in interactive figures on the website. The
combination of a central repository on GitHub for website source code
and metadata with distributed data records on third-party archives
avoids the complexity and administrative overhead of maintaining a
live database and associated backend app. The PFHub infrastructure
provides a template for other small scientific communities to host
custom content and integrate data from members of their community.

![PFHub schematic](./pfhub_website.svg)
**Figure 1:** Schematic overview of the PFHub framework for building
scientific research portals, simply.

## Acknowledgments

Acknowledge MGI funding???

## References
