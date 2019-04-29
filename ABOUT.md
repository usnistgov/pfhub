---
title: "About PFHub"
layout: essay
comment:
---

<h4> Primary {{ site.title }} Goals </h4>

1. Provide a set of benchmark problems to compare and contrast codes for
   solving phase field equations.

2. Provide quality assurance for phase field codes based on
   performance and accuracy.

3. Increase the adoption of phase field methods in engineering and
   academic applications with the development of practical
   documentation.

4. Foster an engaged and integrated phase field community.

<h4> Details and Mentions </h4>

- Olle Heinonen wrote a philosophical introduction to the {{ site.title }}
  benchmarking effort, available as an [extended essay]({{ site.baseurl }}/benchmarks){:target="_blank"}.
- [Andrea Jokisaari][aj], [Peter Voorhees][pv], [Jon Guyer][jg], and [Olle Heinonen][oh]
  published a peer-reviewed journal article in
  *Computational Materials Science* entitled ["Benchmark problems for numerical
  implementations of phase field models"](http://dx.doi.org/10.1016/j.commatsci.2016.09.022){:target="_blank"}.
  - CHiMaD News posted an overview of the article entitled
    ["Benchmark Problems for Phase Field Methods"](
    http://chimad.northwestern.edu/news-events/articles/2016/PhaseField_BenchMark.html).
- Aashutosh Mistry wrote an overview of the presentation delivered by
  [Jon Guyer][jg] at MRS 2017 entitled ["Benchmarking Problems for Phase Field Codes"](
  http://materials.typepad.com/mrs_meeting_scene/2017/11/tc05-uncertainty-quantification-in-multiscale-materials-simulation-1.html).

<h4> Get Involved </h4>

We are an inclusive and expanding community and welcome new
participants.  All those interested in phase field modeling are
welcome to participate in a variety of different ways. See the
[involvement guide]({{ site.baseurl }}/INVOLVEMENT) for more details
about how you can get involved with the community.

<h4> Community </h4>

Please see the [community page]({{ site.baseurl }}/community) for
details of individuals involved in this project and their
affiliations.

<h4> Code of Conduct </h4>

We have a code of conduct and enforce it in our online interactions
and codebase. Please see the [code of conduct page]({{
site.baseurl}}/CODE_OF_CONDUCT) for further details.

<h4> Suggested Phase Field Codes </h4>

The goal of this site is to not only generate benchmarks, but to also
evaluate codes that solve phase field problems. We have a list of
[suggested codes]({{ site.baseurl}}/codes) that have been used to
solve some of the benchmark problems.

<h4> FAQ </h4>

<h5> Which code should I use to solve my phase field problem? </h5>

The right code for you depends on your familiarity with phase field
methods and relevant software, hardware available and complexity of
the phase field problem under consideration. We have a [list of phase
field codes]({{ site.baseurl}}/codes) and also a [list of benchmark
results]({{ site.baseurl}}/simulations/#simulations) that might help
you evaluate which code might work best for you. Our objective is that
the benchmarks will support users of the site in evaluating the
suitability of codes for particular classes of phase field problems,
but the user is the final arbiter in this process.

<h5> I don't like one of the benchmark problems. Can I help fix it? </h5>

Yes. Your feedback on the benchmark problems is highly valued. The
benchmarks are a moving target that you can contribute to. If you
would like to propose a change or improvement then please raise it via
[chat]({{ site.links.chat }}) or as an [issue]({{ site.links.github
}}/issues/new). The community will discuss the change and act on it if
we can reach a consensus

<h5> Who is {{ site.title }} Intended For? </h5>

The Phase Field Community Hub is relevant to the diverse spectrum of
phase-field community members, from absolute newcomers to established
experts in the theory, practice, and implementation of mesoscale
models. The following "user stories" roughly sketch out how we intend
this website to be of use to a few representative visitors.

<h6> Novice Users (<i>e.g.</i>, graduate students) </h6>

A novice may have been directed to choose a code and start modeling by
an advisor or teacher, with no knowledge of phase field methods or our
jargon. This user will not know exactly what they're looking for, and
would rely on us to present information in a clear manner with an
emphasis that we provide. The focus will be ease of adoption, rather
than absolute speed. They may reasonably want to have the following
questions addressed.

- <b>What is Phase Field?</b> To help this new user come up to speed, the
  website should provide the following:
    - Background material defining what phase field methods are.
    - Books, online courses, resources to learn more (include links to
      Software Carpentry lessons for very basic computational skills).
    - Glossary defining our domain vocabulary: HPC, parallelism,
      coarse graining, field variables, scalar and vector fields,
      multiscale, multiphysics, quantitative vs. qualitative, UQ,
      error, accuracy, precision, explicit, implicit, FEM, FVM, FDM,
      discretization, truncation error, roundoff.
    - Examples of what the methods can do, and can't.
    - Suggested hardware setups to get started, and to get real work
      done: laptop, GPGPU, cluster, supercomputer.
    - Codes, languages, complexity.
    - What running a phase field simulation "looks like": graphical
      *vs.* command line interfaces, visualization tools,
      post-processing workflows.
- <b>How do I do it?</b> To help this new user launching simulations, the
  website should provide the following:
    - List of available codes, with links to documentation and tutorials.
    - Whether the codes are open source, licensing terms, and have
      supportive community involvement
    - Overview of which code can do what (strengths and limitations).
    - At-a-glance summary of which code is fastest and most accurate,
      allowing for subjective evaluation of "bang for the buck":
      error, speed, hardware utilization, memory/disk footprint,
      scalability.
    - Sense of whether the code is actively used, maintained, and trending
      toward better results (faster, more accurate, less memory).

<h6> Advanced Users (<i>e.g.</i>, early-career researchers) </h6>

A researcher with experience in phase-field modeling might change
positions or focus, and take a moment to survey the software
landscape. This user will have some idea what they're looking for, or
specifically guarding against. Focus may be suitability to a specific
task, or flexibility to address a wide variety of tasks. The
researcher might be wondering...

- <b>Is Something Better Out There?</b> To help the experienced user
  drill down on options, the website should provide the following:
    - List of available codes, filterable by language, parallelization
      models, numerical methods, license, up-front and ongoing costs,
      mesh generation.
    - Summary of codes by common application area, with lists of
      dependent publications if available.
    - Summary of codes by common application area, with lists of
      dependent publications if available.
    - Dashboard showing how many results have been submitted by each
      code for each benchmark problem, to evaluate capability and
      popularity/activity.
    - Details of each code's major dependencies and installation
      options (source, binary, container).
    - Easy ways to contact users and developers to discuss specific
      results.
- <b>Does My Usage Comply With Best Practices?</b> To help the
  experienced user compare their code and performance against other
  users and experts, the website should provide the following:
    - A simple process for uploading simulation results with immediate
      feedback: new work should appear in the graphs and tables on the
      live website, or indicate something went wrong and suggest a
      point of contact.
    - Access to the source code for prior uploads (devs and other
      users).
    - Resources describing tools for archiving and persistently sharing data,
      preferably using tools that can be reused in other contexts.
    - Shiny stickers for the "best" result in each class, and the cleanest
      coding style and documentation.

<h6> Expert Users (<i>e.g.</i>, software developers) </h6>

A software developer experienced with phase-field models and numerical
methods will be interested in upgrading their code, making it easier
to use, more powerful, or able to run on evolving hardware and
software platforms. The developer might be wondering...

- <b>Is my code competitive?</b> To help the developer compare apples to
  apples, the website should provide the following:
    - List of available simulation results, with visualizations and
      ability to filter by code, platform, and author (fellow dev or
      user).
    - Resources to help evaluate whether the code is correct, using
      the method of manufactured solutions and by quantitative
      comparison between uploaded datasets.
    - A responsive process for uploading simulation results when new
      benchmarks come out, and for new features that might earn a
      trophy (or secure its place)
- <b>Is My Community Actively Engaged?</b> To help the developer shepherd
  the flock, the website should provide the following:
    - Persistent links to benchmark implementations and datasets,
      for use in marketing materials and documentation.
    - Quantitative comparisons of "official" simulation results to
      "contributed" results from users, with contact info available
      for follow-up (good or bad).
    - Resources to spread the word about this Working Group, drum up
      contributions.

<h6> Advisors (<i>e.g.</i>, faculty) </h6>

A faculty adviser who is continually having new researchers join their
research group that are unfamiliar with the phase field method will be
interested in having a collection of example problems with known,
recorded solutions that their students can implement while learning.

- <b>Are New Researchers Solving Problems Correctly?</b> To best instruct
  new researchers, the website should provide:
    - Problems with all parameters, initial conditions, and boundary
      conditions defined.
    - Well established solutions using a range of different solution
      methods that new researchers can use for comparison.
    - Metrics from other codes showing computation times that new
      researchers can use to evaluate the efficiency of their
      solution.
- <b>Are They Learning A Range of Phase Field Problems?</b> To provide
  new researchers with a breadth of knowledge, rather than in just one
  area, the website should provide
    - Problems covering a range of different materials phenomena.
    - Problems with increasing complexity.
    - Problems with unique aspects such as coupled mechanics or
      anisotropic surface energy.

[aj]: {{ site.baseurl }}/community/#andrea-jokisaari
[jg]: {{ site.baseurl }}/community/#jon-guyer
[oh]: {{ site.baseurl }}/community/#olle-heinonen
[pv]: {{ site.baseurl }}/community/#peter-voorhees
