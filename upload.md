# PFHub Upload Procedure

The following are instructions for adding benchmark results to the
[benchmark tables and charts][benchmarks]. Please feel free to upload
benchmark results. More benchmark results will greatly improve the
utility of the website and encourage community collaboration. The new
upload procedure requires the submitter to add their result to a
scientific data archive site that provides a DOI. Currently, only
Zenodo is supported. However, we hope to expand to other data
services in future.

## How to Upload

1. Firstly, read the Submission Guidelines for your particular
   benchmark carefully. Remember that each benchmark sub-problem
   requires a seperate upload (e.g. [BM8 Submission Guidelines][
   guidelines]). Pay special attention to the required file names and
   column headings for tabular data. PFHub now requires that data
   files and internal data are labeled correctly.  Also note the
   simulation time versus wall time and the memory usage.

2. The software that is used requires a [codemeta.json] file in the
   accompanying repository. This is a convenient standard for storing
   data about software. The PFHub developers will endeavor to ensure
   that common phase-field codes used for submission have an
   accompanying [codemeta.json] file in the code repositories
   requiring the submitter to supply the correct URL.
   [codemeta.json] describes the software used for the simulation,
   not the simulation provenance, which is discussed in the following
   step. To generate a new [codemeta.json] fill out the [codemeta
   online web form] and add the JSON output to the software
   repository.

3. Generate a pfhub.json file. This will be submitted alongside the
   data files to a data archiving service. This file contains a
   limited set of meta-data / provenance about the simulation used to
   generate the submission data. There is a [JSON generator] for
   generating this file. Once the form is complete, copy and paste
   the JSON on the right into a file called `pfhub.json`. This will
   be added to the upload at the archiving service.

4. The following instructions are for uploading to [Zenodo]. Go to
   the PFHub community and add your upload within that context. Click
   on "New Upload" and then "Choose Files" to add the required data
   files and `pfhub.json` file. Choose "Dataset" as the upload
   type. The data, title, author and description will be used on the
   website to display information. Ensure that the upload is "Open
   Access". Note the DOI for the next step

5. Submit the DOI in the [PFHub upload form] via an issue on the
  [PFHub GitHub site]. After hitting submit, this will generate a
  pull-request at <https://github.com/usnistgov/pfhub/pulls>
  alongside a temporary view of the website with the new data. The
  upload will be evaluated and the submitter can interact with the
  PFHub moderators to correct any issues with the data. Zenodo allows
  for updates with version numbers. Once both the submitter and
  moderator have approved the upload the PR will be merged and the
  new submission will appear on the website.

<!-- links -->

[benchmarks]: https://pages.nist.gov/pfhub/simulations/
[guidelines]: https://pages.nist.gov/pfhub/benchmarks/benchmark8.ipynb/#Submission-Guidelines
[codemeta.json]: (https://codemeta.github.io/)
[codemeta online web form]: (https://codemeta.github.io/codemeta-generator/)
[JSON generator]: https://json-editor.github.io/json-editor/?data=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
[Zenodo]: https://zenodo.org/communities/pfhub/?page=1&size=20
[PFHub upload form]: https://github.com/usnistgov/pfhub/issues/new?assignees=wd15&labels=upload&template=upload.yml&title=%5BUpload%5D%3A+
[PFHub GitHub site]: https://github.com/usnistgov/pfhub
