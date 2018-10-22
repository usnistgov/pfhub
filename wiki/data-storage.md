---
title: "Simulation Data Storage"
layout: wiki
---

## Data Storage

Before submitting a benchmark result to PFHub, you are expected to store your data in a
publicly-accessible location. There are several online services that provide archival storage on a
platform compatible with the PFHub back-end. These are outlined below.

Incompatible hosts -- those with incompatible CORS settings or a prohibitive paywall -- are
collected in the original [Issue][issue] where these services were evaluated. If you find a service
erroneously marked incompatible, please let us know! Likewise, suggestions for new platforms to try
are welcome.

If you're looking for a recommendation, services that mint a DOI or similar persistent unique
identifier are preferred.

**Services**

- [Figshare](#figshare)
- [Amazon S3](#amazon-s3)
- [Backblaze B2](#backblaze-b2)

### [Figshare](https://figshare.com/)

[*Compatible with PFhub as of 2017-12-21.*](https://github.com/usnistgov/pfhub/issues/491#issuecomment-353459760)

1. Create an account on [Figshare][fig].
2. Under "Projects," create a new project to help group benchmark datasets.
2. Under "My Data", either "Create a New Item" or click the [octocat][git] to import from GitHub.
3. Drag-and-drop files into the upload box at the top of the dialog.
3. Fill in the metadata as you see fit. For "Category," I've been using *Numerical Solution of
   Differential and Integral Equations*, since there's no *Computational Materials Science* key
   available.
4. Click on the "Public" check box.
5. If the dataset is not simply for testing purposes, then go ahead and request a DOI for it.
6. Click "Publish." In so doing, you promise to keep these data publicly available forever.
7. Click on your new dataset or fileshare in the list.
8. Under each thumbnail, next to the file name, there's a ⬇ download link. The URL is
   `https://ndownloader.figshare.com/files/<handle>/` where `<handle>` is a numerical index. The
   file can be accessed directly using this URL, *e.g.*,
   [https://ndownloader.figshare.com/files/10030006](https://ndownloader.figshare.com/files/10030006).
9. Retrieve handles for each file.
10. Use the [Upload Form][upload].
11. Wait for your pull request to be approved, then find your landing page.
12. The data chart should show up!

### [Amazon S3](https://aws.amazon.com/s3)

[*Compatible with PFhub as of 2017-12-21.*](https://github.com/usnistgov/pfhub/issues/491#issuecomment-353486891)

1. Create an account on [Amazon S3][aws].
2. Create a bucket.
   - Select the region nearest to you.
   - Enable versioning. Accept other property defaults.
   - Grant public read-access to the bucket.
3. Upload data into the bucket.
    - Click on the bucket name.
    - Drag-and-drop files into the upload box.
    - Click "Next."
    - Grant public read access to the object.
    - Choose "Standard" storage class and no encryption.
4. Open the bucket's "Permissions" tab.
5. Click on the "CORS configuration" button.
    - Change the last line of content from `<AllowedHeader>Authorization</AllowedHeader>` to
        `<AllowedHeader>*</AllowedHeader>`
    - Save the config.
    - Your data will not be plotted unless you do this!
6. Each file has a unique URL of the form `https://s3.<region>.amazonaws.com/<bucket>/<filename>`,
   *e.g.*, [https://s3.us-east-2.amazonaws.com/hiperc-results/free-energy-9pt.csv](https://s3.us-east-2.amazonaws.com/hiperc-results/free-energy-9pt.csv).
7. Use the [Upload Form][upload].
8. Wait for your pull request to be approved, then find your landing page.
9. The data chart should show up!

### [Backblaze B2](https://www.backblaze.com/b2/cloud-storage.html)

[*Compatible with PFhub as of 2017-12-21.*](https://github.com/usnistgov/pfhub/issues/491#issuecomment-352581961)

1. Create account on [Backblaze B2][blz]
2. Create a bucket marked "Public." You get 100 buckets per account, so don't get too granular with it.
3. Click the popup link to "Show Account ID and Application Key".
4. Create an application key.
5. Click your bucket's link to [CORS Rules](https://www.backblaze.com/b2/docs/cors_rules.html), and
   select "Share everything in this bucket with every origin" or specify "https://pages.nist.gov".
    - Your data will not be plotted unless you do this.
    - For buckets storing public data (CC0 or CC-BY compatible licenses), there is no downside to
      opening up access to the whole web.
6. [Install](https://www.backblaze.com/b2/docs/quick_command_line.html) the `b2` command-line tool:
   ```
   $ pip3 install b2
   ```
7. Configure your bucket:
   ```
   $ b2 authorize_account <AccountID>
   Backblaze application key:
   $ b2 list_buckets
   75cf92cc224d664bd62050912 allPublic hiperc-results
   ```
8. Upload a file, using `/` in filenames to set folders.
   ```
   $ b2 upload_file <bucket> <local-name> <b2-name>
   ```
9. Access file on the Web: `https://f001.backblazeb2.com/file/<bucket>/<file>`,
   *e.g.*, [https://f001.backblazeb2.com/file/hiperc-results/gpu-cuda-spinodal/free-energy.csv](https://f001.backblazeb2.com/file/hiperc-results/gpu-cuda-spinodal/free-energy.csv).
10. Use the [Upload Form][upload].
11. Wait for your pull request to be approved, then find your landing page.
12. The data chart should show up!

### Disclaimer

> Certain commercial software, services, or platforms are identified on this page to
> foster understanding. Such identification does not imply recommendation or endorsement
> by the National Institute of Standards and Technology, nor does it imply that the
> materials or equipment identified are necessarily the best available for the purpose.

In addition, you are responsible for the integrity of your research data. Use of any third-party
service to store your data is at your own risk. Please read the terms of use (or a summary thereof)
and relevant documentation before entrusting your data to such third parties.

<!-- References -->
[aws]: https://aws.amazon.com/s3
[blz]: https://www.backblaze.com/b2
[fig]: https://figshare.com
[git]: https://github.com/logos
[issue]: https://github.com/usnistgov/pfhub/issues/491
[upload]: https://pages.nist.gov/pfhub/simulations/upload_form/
