---
layout: essay
title: "Phase Field Benchmark Problems Overview"
author: "Olle Heinonen"
author_url: http://www.msd.anl.gov/heinonen
comment: >-
  Extended essay outlining the motivation for phase field benchmark
  problems
---

Many important processes in materials microstructural evolution, such
as coarsening, solidification, polycrystalline grain evolution,
magnetic and ferroelectric domain formation and motion, occur on
mesoscale length and time scales. The mesoscale is “in between,” in this
case in between atomistic and macroscopic length and time
scales. There are important conceptual distinctions, as well as
modeling approaches, between atomistic, meso-, and macroscale
processes. Atomistic scale modeling uses atoms and electrons as
central entities, and the structure and dynamics are governed either
by quantum mechanics, classical mechanics, or hybrid semiclassical
approaches. The relevant length and time scales are typically
Ångströms and femtoseconds (for electrons) or picoseconds (for atoms).
At the macroscale, on the other hand, materials properties are
averaged over many domains (*e.g.*, compositional, structural, magnetic,
or ferroelectric domains). Central entities at the macroscale are
usually materials properties that describe a response to some
macroscopic external forces, e.g., conductivity, elastic
properties, or susceptibilities. The responses are given in terms of
macroscopic constitutive equations. The relevant length and time
scales range from micrometers and milli- or microseconds and up.

The mesoscale, our area of concern, comprises length scales larger
than several unit cells but small enough to resolve microstructural
entities such as crystalline grains or ferromagnetic/ferroelectric
domains that are usually averaged over in macroscale modeling. The
length scales typically span nanometers to micrometers (or larger),
and time-scales span nanoseconds to milliseconds or microseconds (or
longer). Conceptually, there is a key distinction between
time evolution in mesoscale modeling compared to atomistic
modeling. Mesoscale dynamics is dissipative, so that forces give rise
to velocities, as opposed to acceleration in atomistic modeling
(although hydrodynamic and dissipative dynamics can be coupled).

There are two general approaches to mesoscale modeling. One approach
models interfaces as sharp boundaries of one lower dimension than the
structural domains they separate, such as crystalline grains or
domains. This approach can be very efficient when simple
microstructural geometries are simulated. However, tracking interfaces
with complex geometries (e.g., dendritic growth) and topology changes,
such as the merging and splitting of particles, is challenging. The other
mesoscale modeling approach uses diffuse (finite width)
interfaces. This method can easily track complex interface geometries
and topological changes. This benefit is not without cost, as the 
interface, typically of the order of a nanometer, has to be resolved, 
yielding considerably more computationally intense calculations.

One way to implement diffuse interfaces is using phase fields. These
are smooth and continuous fields that describe local
microstructure. For example, a two-phase system can be described by a
single phase field that takes the value 0 in one phase and 1 in the
other and that smoothly interpolates between these values at a phase
boundary (the actual values of the phase field are essentially
irrelevant as long as they are different in different phases). If
there are many variants in a system, for example crystalline
orientations in crystalline grains, there can be a number of phase
fields, each one representing a particular variant.  The phase field
method (and other, associated, order parameter-based approaches) has
been used to study dendritic growth, spinodal decomposition, grain
growth, and ferroelectric domain formation, to name a few phenomena.

As phase field modeling has gained popularity, a variety of codes have
emerged. Some of them are community-based codes, such as MOOSE,
FEnICs, or DUNE, and some are proprietary or in-house. With this
variety of codes and numerical implementations, there is a concomitant
need for benchmark problems that can be used to assess, validate, and
verify codes. In that respect, phase field modeling is at a point
similar to micromagnetic modeling in the late 1990s and early
2000s. With the emergence of a number of micromagnetic codes, the
community self-organized and developed a number of Micromagnetic
Standard Problems. These problems are non-trivial to solve
analytically and test different aspects of both the physics being
modeled as well as numerical methods implemented in micromagnetic
codes, but were still designed to be not too computationally
demanding. The National Institute of Standards and Technology has
played a coordinating role in the development and management of these
problems, and also hosts a [website for the Micromagnetic Standard
Problems](http://www.ctcms.nist.gov/~rdm/mumag.org){:target="_blank"},
as well as solutions submitted by the community. The Micromagnetic
Standard Problems were extremely useful to the community in the
development of codes such as OOMMF, Mumax, and Magpar. It should be
noted that the Micromagnetic Standard Problems continue to evolve as
new physics, such as spin torque and Dzyaloshinksii-Moriya
interactions, is added to the micromagnetic canon.

Inspired by the Micromagnetic Standard Problems, the Center for
Hierarchical Materials Design (CHiMaD) is partnering with NIST and the
phase field community to develop a set of benchmark problems for the
phase field modeling and development community. These problems are
vetted by the community in workshops and Hackathons, and then posted
on this open-access website.

These phase field benchmark problems are designed to exhibit several
key features. The problems are nontrivial and exhibit differing
degrees of computational complexity but are not prohibitively
computationally demanding. The outputs are defined to be easily
comparable between different codes. The problems are also constructed
to test a simple, targeted aspect of either the numerical implementation
or the physics.

The first set of benchmark problems, [BM1]({{ site.baseurl
}}/benchmarks/benchmark1.ipynb/){:target="_blank"} and [BM2]({{
site.baseurl }}/benchmarks/benchmark2.ipynb/){:target="_blank"},
involve diffusion of a solute and grain growth. Technically, they use
the Cahn-Hilliard equation for a conserved order parameter, and
coupled Cahn-Hilliard and Allen-Cahn equations for conserved and
non-conserved order parameters. Successfully solving the models
demonstrates that the fundamentals of a modeling framework are sound.

The second set of benchmark problems, [BM3]({{ site.baseurl
}}/benchmarks/benchmark3.ipynb/){:target="_blank"} and [BM4]({{
site.baseurl }}/benchmarks/benchmark4.ipynb/){:target="_blank"},
involve coupling phase transformations with additional physics,
namely, Fourier's heat equation and Hooke's Law. BM3, which is
dendritic growth in solidification from an undercooled liquid, also
focuses on how a solver can address the very different length scales
that arise in the problem. 

The third set of benchmark problems, [BM5]({{ site.baseurl
}}/benchmarks/benchmark5-hackathon.ipynb/){:target="_blank"} and
[BM6]({{ site.baseurl
}}/benchmarks/benchmark6-hackathon.ipynb/){:target="_blank"}, extend to
additional physics less commonly seen in phase field problems.
Specifically, BM5 involves modeling Stokes' flow equations and BM6
couples diffusion to the Poisson equation for electrostatic charge.

The fourth set of benchmark problems, [BM7]({{ site.baseurl
}}/benchmarks/benchmark7.ipynb/){:target="_blank"}, directly tests the
implemented discretizations of space and time using the Method of
Manufactured Solutions applied to the Allen-Cahn equation.

For details of any or all of these benchmark problems, please refer to
the [list of benchmarks 
problems]({{ site.baseurl }}/#benchmarks){:target="_blank"}.
