# Who is Mr. Hyde?

Mr. Hyde is a minimalist implementation of Jekyll and Github pages. 

## The First Time is Free

This repository is designed to get a Github Pages site up and running in less than a minute.  The first time you use this file; it can forked and modified on Github; BAM! Github Pages.  You can only fork the same repo once, so after the first time you must learn some git/Github.

## Bonus

The entire ``{{site.github}}`` is captured ``/myhyde/github.json`` when you fork this template.

# How does Jeyll turn into Mr. Hyde?

1. Fork this Repo

  *The following steps are required to create your Github page.*

2. Go to the repository settings and rename your forked repository
3. In ``_config.yml``, change ``baseurl: /mrhyde`` to the **exact name** of your repository ``baseurl: /<your-repo-name>``
4. Create a new card

  1. Add a new file to ``_cards``
  2. Use ``layout: jsonify`` in the yaml front matter or one of the other Jekyll parsers
  3. Add user-defined variables and content as you would in a post

5. Access your content through the compiled json files

> **Why cards?** Jekyll posits that collections are things that are nor data nor posts, but somewhere in between.  Let's consider a collection of cards?

# Jekyll Pre-processors

Jekyll is packaged with parsers for Jsonify, Markdown, Sass, and SCSS.  This template has
some basic templates to use these pre-processors.  

## Using the Pre-processors

Each was given a ``_layout`` template.  The templates are trigger using the following layouts
in the YAML Front Matter:

**jsonify**
```
layout: jsonify
```

**markdownify**
```
layout: mardownify
```
Mardownify requires liquid to assign a new variable and parse your own JSON.  
Liquid does not allow the modification of variables.

**sassify**+**scssify**
```
layout: sassify # scssify
```
Sass without the set-up. Winning!
