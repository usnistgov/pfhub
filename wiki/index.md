---
layout: wiki
title: Main Page
published: true
---

## Overview

The PFHub wiki is a place for anyone interested in the PFHub website
to add content. See below for details on how to get started editing
this site using [Prose.io]. [Prose.io] provides a beautifully simple
content authoring environment for CMS-free websites.

## How to Edit

Follow these instructions to edit these wiki pages.

 - If this is your first time using [Prose.io]. Go to
   [http://prose.io][Prose.io] and click on "AUTHORIZE ON GITHUB" to
   get started. You do need to have [GitHub] account to use
   [Prose.io].

 - To edit a wiki page or create a new wiki page, click on the links
   in the top right hand corner of this page. This will take you to
   [Prose.io] where you can start editing.

 - Editing is done using the Markdown markup languages. See [Daring
   Fireball](https://daringfireball.net/projects/markdown/) for a
   guide to using Markdown.

 - The right hand panel on the [Prose.io] edit page has a preview icon
   where you can preview your changes and see how they'll look when
   rendered on the website.

 - Once you're happy with your edits, click on the save icon. This
   will prompt you to submit your changes with a commit message.

 - The changes will be submitted as a pull request to
   [https://github.com/wd15/pfhub/pulls](https://github.com/wd15/pfhub/pulls). After
   review the changes will be pushed to the main site and you will be
   notified. During this process, [Prose.io] will fork the PFHub
   repository into your [GitHub] user area.

## Current Wiki Pages

List of the current wiki pages available on these pages.

{% for file in site.pages %}
  {% assign f4 = file.path | slice: 0, 4 %}
  {% if f4 == 'wiki' %}
 * [{{ file.path }}]({{ site.baseurl }}{{ file.url }}): {{ file.title }}
  {% endif %}
{% endfor %}


[Prose.io]: http://prose.io
[GitHub]: https://github.com
