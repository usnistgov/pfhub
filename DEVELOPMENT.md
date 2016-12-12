---
title: "Development Guide"
layout: essay
comment: How to develop this web site
---

The following is an overview on how to update the website for each
particular element. The website is tested on
[Travis CI](https://travis-ci.org/usnistgov/chimad-phase-field) using
[html-proofer](https://github.com/gjtorikian/html-proofer), which
automatically checks the site for errors.. The [`.travis.yml`]({{
site.links.github }}/blob/nist-pages/.travis.yml) contains everything
required to build the website. Note that the instructions below may
become out of date with the [`.travis.yml`]({{ site.links.github
}}/blob/nist-pages/.travis.yml) file and have only been tested on
Ubuntu and on Travis CI.

## Build and Serve the Website

The site uses the [Jekyll](https://jekyllrb.com) static web site
generator. To build the environment require to serve the site, use the
following commands,

    $ sudo apt-get update
    $ sudo apt-get install ruby
    $ gem install jekyll jekyll-coffeescript

Then clone the GitHub repository

    $ git clone https://github.com/usnistgov/chimad-phase-field.git
    $ cd chimad-phase-field
    $ jekyll serve

At this point Jekyll should be serving the website. Go to
[http://localhost:4000/chimad-phase-field](http://localhost:4000/chimad-phase-field])
to view the site.

## Add a New Phase Field Code

To add a new phase field code to the list of codes on the front page,
follow the [submission instructions]({{ site.baseurl
}}/sumbit_a_new_code) on the main site. Jekyll will automatically
rebuild the site after `codes.yaml` is editied.

## Add a new workshop

To add a new workshop edit the [`workshop`]({{ site.links.github
}}/blob/nist-pages/data/workshops.yaml)

## Update the Community Page

## Update and Build the Hexbin

## Add a Jupyter Notebook

## Add a new Benchmark Problem

## Testing

This site uses Jekyll. To view locally use

    $ jekyll serve

and go to
[http://localhost:4000/chimad-phase-field](http://localhost:4000/chimad-phase-field]).


In order to discuss this repository with other users, we encourage you
to sign up for the mailing list by sending a subscription email:

To:

    chimad-phase-field-request@nist.gov

Subject: (optional)

Body:

    subscribe

Once you are subscribed, you can post messages to the list simply by
addressing email to <chimad-phase-field@nist.gov>.

To get off the list follow the instructions above, but place
unsubscribe in the text body.

### List Archive

The list is archived at the Mail Archive,

[https://www.mail-archive.com/chimad-phase-field@nist.gov/](https://www.mail-archive.com/chimad-phase-field@nist.gov/)

<!-- The NIST email achive is dead! -->

<!-- and at -->

<!-- [https://email.nist.gov/pipermail/chimad-phase-field/](https://email.nist.gov/pipermail/chimad-phase-field/) -->

Any mail sent to <chimad-phase-field@nist.gov> will appear in these
publicly available archives.
