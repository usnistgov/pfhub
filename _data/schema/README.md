# Phase-Field Schema Development

> Look into the neuroscience community,
> they might have RDF thingies?

What's important to capture for the meeting?

> Different schemas for PF models, simulations,
> datasets, benchmarks, frameworks?

* Implementation
  * [x] Repository URL
  * [x] Version control branch, commit hash
  * [ ] Method (FDM, FVM, FEM)
  * [ ] Input files, parameters, ...
  * [ ] Mesh size
  * [ ] Solver
  * [ ] License?
  * [ ] Software framework (link to MOOSE, FiPy, ...)
         * [ ] Version or branch & hash
* Benchmark ID
  * [ ] Link to description
  * [ ] Equations?
* Hardware
* Timestamp
* Memory usage

SI units & codes:
<http://wiki.goodrelations-vocabulary.org/Documentation/UN/CEFACT_Common_Codes>

## [RDFLib][rdflib] ([Resource Description Framework][rdf])

> Arrived here based on a StackOverflow thread about
> [capturing units in metadata][temp-schema].

[rdflib][rdflib] enumerates several schemas as "namespaces".
Some of these will be useful in building up a phase-field
[Turtle][turtle] description:

* [CSVW][rdflib-csvw]: Metadata Vocabulary for Tabular Data

* [DOAP][rdflib-doap]: Description of a Project

  Includes _implements_, _repository_, _homepage_, etc.
* [QB][rdflib-qb]: Vocabulary for multi-dimensional data

* [SDO][rdflib-sdo]: [Schema.org][schema-org]

* [VOID][rdflib-void]: Vocabulary of Interlinked Datasets

* [XSD][rdflib-xsd]: W3C XML Schema Definition datatypes

Looks promising, but RDF doesn't accommodate lists (as you might use for
authors), so I'm not sure how to use it?

## [SchemaOrg][schemaorg] (Schema.org)

[schemaorg][schemaorg] is a handy library for defining a "recipe" then
validating a "spec" against it, using only Schema.org types.
The project is relatively immature, and docs could be more extensive, but
the core is useful even as it stands.

<!-- links -->
[rdf]: https://en.wikipedia.org/wiki/Resource_Description_Framework
[rdflib]: https://rdflib.readthedocs.org/
[rdflib-csvw]: https://github.com/RDFLib/rdflib/blob/main/rdflib/namespace/_CSVW.py
[rdflib-doap]: https://github.com/RDFLib/rdflib/blob/main/rdflib/namespace/_DOAP.py
[rdflib-qb]: https://github.com/RDFLib/rdflib/blob/main/rdflib/namespace/_QB.py
[rdflib-sdo]: https://github.com/RDFLib/rdflib/blob/main/rdflib/namespace/_SDO.py
[rdflib-void]: https://github.com/RDFLib/rdflib/blob/main/rdflib/namespace/_VOID.py
[rdflib-xsd]: https://github.com/RDFLib/rdflib/blob/main/rdflib/namespace/_XSD.py
[schema-org]: https://schema.org
[schemaorg]: https://openschemas.github.io/schemaorg/
[temp-schema]: https://stackoverflow.com/a/47376220/5377275
[turtle]: https://en.wikipedia.org/wiki/Turtle_(syntax)
