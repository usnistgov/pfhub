# Who is Mr. Hyde?

Mr. Hyde is a minimalist implementation of Github pages.  

It returns Jekyll Collection API content as "``json``" for direct use in Javascript.  No more Liquid.

## BONUS

The Github site pages are already baked into ``/myhyde/github.json`` the template.

# How does Jeyll turn into Mr. Hyde?

1. Fork this Repo

  *You must change the repository in some one to active Github pages on it.*

2. In the Repository settings, rename your forked repository
3. In ``_config.yml`` change ``baseurl: /mrhyde`` to ``baseurl: /<your-repo-name>``
4. Create new content

  1. Add a new file to ``_content``
  2. Place ``layout: jsonify`` in the yaml front matter
  3. Add user-defined variables and content as you would in a post

5. Access your content through the compiled json files
6. 
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
