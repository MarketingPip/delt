# generate-sitemap

[![cicirello/generate-sitemap - Generate XML sitemaps for static websites in GitHub Actions](https://actions.cicirello.org/images/generate-sitemap640.png)](#generate-sitemap)

Check out all of our GitHub Actions: https://actions.cicirello.org/

## About

| __GitHub Actions__ | [![GitHub release (latest by date)](https://img.shields.io/github/v/release/cicirello/generate-sitemap?label=Marketplace&logo=GitHub)](https://github.com/marketplace/actions/generate-sitemap) [![Count of Action Users](https://badgen.net/github/dependents-repo/cicirello/generate-sitemap?icon=github&label=used%20by)](https://github.com/cicirello/generate-sitemap/network/dependents) |
| :--- | :--- |
| __Build Status__ | [![build](https://github.com/cicirello/generate-sitemap/actions/workflows/build.yml/badge.svg)](https://github.com/cicirello/generate-sitemap/actions/workflows/build.yml) [![CodeQL](https://github.com/cicirello/generate-sitemap/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/cicirello/generate-sitemap/actions/workflows/codeql-analysis.yml) |
| __Source Info__ | [![GitHub](https://img.shields.io/github/license/cicirello/generate-sitemap)](https://github.com/cicirello/generate-sitemap/blob/master/LICENSE) [![GitHub top language](https://img.shields.io/github/languages/top/cicirello/generate-sitemap)](https://github.com/cicirello/generate-sitemap) |
| __Support__ | [![GitHub Sponsors](https://img.shields.io/badge/sponsor-30363D?logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/cicirello) [![Liberapay](https://img.shields.io/badge/Liberapay-F6C915?logo=liberapay&logoColor=black)](https://liberapay.com/cicirello) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?logo=ko-fi&logoColor=white)](https://ko-fi.com/cicirello) |

The generate-sitemap GitHub action generates a sitemap for a website hosted on GitHub
Pages, and has the following features:
* Support for both xml and txt sitemaps (you choose using one of the action's inputs). 
* When generating an xml sitemap, it uses the last commit date of 
  each file to generate the `<lastmod>` tag in the sitemap entry. If the file
  was created during that workflow run, but not yet committed, then it instead uses
  the current date (however, we recommend if possible committing newly created files first).
* Supports URLs for html and pdf files in the sitemap, and has inputs 
  to control the included file types (defaults include both html and pdf files in the sitemap).
* Now also supports including URLs for a user specified list of 
  additional file extensions in the sitemap. 
* Checks content of html files for `<meta name="robots" content="noindex">` 
  directives, excluding any that do from the sitemap. 
* Parses a robots.txt, if present at the root of the website, excluding 
  any URLs from the sitemap that match `Disallow:` rules for `User-agent: *`.
* Sorts the sitemap entries in a consistent order, such that the URLs are 
  first sorted by depth in the directory structure (i.e., pages at the website 
  root appear first, etc), and then pages at the same depth are sorted alphabetically. 
* It assumes that for files with the name `index.html` that the preferred URL for the page
  ends with the enclosing directory, leaving out the `index.html`. For example,
  instead of `https://WEBSITE/PATH/index.html`, the sitemap will contain
  `https://WEBSITE/PATH/` in such a case. 
* Provides option to exclude `.html` extension from URLs listed in sitemap.   

The generate-sitemap GitHub action is designed to be used 
in combination with other GitHub Actions. For example, it 
does not commit and push the generated sitemap. See 
the [Examples](#examples) for examples of combining
with other actions in your workflow.

The generate-sitemap action is for GitHub Pages sites,
such that the repository contains the html, etc of the 
site itself, regardless of whether or not the html was 
generated by a static site generator or written by 
hand. For example, I use it for multiple Java project 
documentation sites, where most of the site is generated 
by javadoc. I also use it with my personal website, which 
is generated with a custom static site generator. As long as
the repository for the GitHub Pages site contains the
site as served (e.g., html files, pdf files, etc), the 
generate-sitemap action is applicable.

The generate-sitemap action is not for GitHub Pages 
Jekyll sites (unless you generate the site locally and 
push the html output instead of the markdown, but why would 
you do that?). In the case of a GitHub Pages Jekyll site, 
the repository contains markdown, and not the html that 
is generated from the markdown. The generate-sitemap action 
does not support that use-case. If you are looking to generate 
a sitemap for a Jekyll website, there is 
a [Jekyll plugin](https://github.com/jekyll/jekyll-sitemap) for that. 

## Table of Contents

The remainder of the documentation is organized into the following
sections:
* [Requirements](#requirements): Explanation of a pre-requisite step of any workflow
  using the action.
* [Inputs](#inputs): Documentation of all of the actions's inputs.
* [Outputs](#outputs): Documentation of all of the actions's outputs.
* [Examples](#examples): Several example workflows illustrating various features.
* [Real Examples From Projects Using the Action](#real-examples-from-projects-using-the-action)
* [Support the Project](#support-the-project): Information on various ways that you can support
  the project.

## Requirements

This action relies on `actions/checkout@v2` with `fetch-depth: 0`.
Setting the `fetch-depth` to 0 for the checkout action ensures
that the `generate-sitemap` action will have access to the commit
history, which is used for generating the `<lastmod>` tags in the
`sitemap.xml` file.  If you instead use the default when applying the
checkout action, the `<lastmod>` tags will be incorrect.  So be
sure to include the following as a step in your workflow:

```yml
    steps:
    - name: Checkout the repo
      uses: actions/checkout@v2
      with:
        fetch-depth: 0 
```

## Inputs

### `path-to-root`

The path to the root of the website relative to the
root of the repository. Default `.` is appropriate in most cases,
such as whenever the root of your Pages site is the root of the
repository itself. If you are using this for a GitHub Pages site
in the `docs` directory, such as for a documentation website, then
just pass `docs` for this input.

### `base-url-path`

This is the url to your website. You must specify this
for your sitemap to be meaningful.  It defaults
to `https://web.address.of.your.nifty.website/` for demonstration
purposes.

### `include-html`

This flag determines whether html files are included in
your sitemap (files with an extension of either `.html` 
or `.htm`). Default: `true`.

### `include-pdf`

This flag determines whether pdf files are included in
your sitemap. Default: `true`.

### `additional-extensions`

If you want to include URLs to other document types, you can use
the `additional-extensions` input to specify a list (separated by
spaces) of file extensions. For example, Google (and other search
engines) index a variety of other file types, including `docx`, `doc`,
source code for various common programming languages, etc. Here
is an example:

```yml
    - name: Generate the sitemap
      uses: cicirello/generate-sitemap@v1
      with:
        additional-extensions: doc docx ppt pptx
```

### `sitemap-format`

Use this to specify the sitemap format. Default: `xml`.
The `sitemap.xml` generated by the default will contain lastmod dates
that are generated using the last commit dates of each file. Setting 
this input to anything other than `xml` will generate a plain text 
`sitemap.txt` simply listing the urls.

### `timestamp-format`

Use this to change the timestamp format. Default: `1`.
The `timestamp-format` input provides the option to change the default lastmod
date format in the generated sitemap from `YYYY-MM-DDThh:mm:ssTZD` to `YYYY-MM-DD`


### `drop-html-extension`

The `drop-html-extension` input provides the option to exclude `.html` extension 
from URLs listed in the sitemap. The default is `drop-html-extension: false`.  If
you want to use this option, just pass `drop-html-extension: true` to the action in
your workflow. GitHub Pages automatically serves the 
corresponding html file if URL has no file extension. For example, if a user
of your site browses to the URL, `https://WEBSITE/PATH/filename` (with no extension),
GitHub Pages automatically serves `https://WEBSITE/PATH/filename.html` if it exists.
The default behavior of the `generate-sitemap` action includes the `.html` extension
for pages where the filename has the `.html` extension. If you prefer to exclude the
`.html` extension from the URLs in your sitemap, then 
pass `drop-html-extension: true` to the action in your workflow. 
Note that you should also ensure that any canonical links that you list within
the html files corresponds to your choice here.  

## Outputs

### `sitemap-path`

The generated sitemap is placed in the root of the website. This 
output is the path to the generated sitemap file relative to the
root of the repository. If you didn't use the `path-to-root` input, then
this output should simply be the name of the sitemap file (`sitemap.xml`
or `sitemap.txt`).

### `url-count`

This output provides the number of URLs in the sitemap.

### `excluded-count`

This output provides the number of URLs excluded from the sitemap due
to either `<meta name="robots" content="noindex">` within html files,
or due to exclusion from directives in a `robots.txt` file.

## Examples

### Basic Action Syntax

You can run the action with a step in your workflow like this:

```yml
    - name: Generate the sitemap
      uses: cicirello/generate-sitemap@v1
      with:
        base-url-path: https://THE.URL.TO.YOUR.PAGE/
```

In the above example, the major release version was used, which ensures that you'll
be using the latest patch level release, including any bug fixes, etc. If you prefer,
you can also use a specific version such as with:

```yml
    - name: Generate the sitemap
      uses: cicirello/generate-sitemap@v1.8.0
      with:
        base-url-path: https://THE.URL.TO.YOUR.PAGE/
```

### Example 1: Minimal Example

In this example workflow, we use all of the default inputs except for
the `base-url-path` input. The result will be a `sitemap.xml`
file in the root of the repository. After completion, it then
simply echos the outputs.

```yml
name: Generate xml sitemap

on:
  push:
    branches: [ main ]

jobs:
  sitemap_job:
    runs-on: ubuntu-latest
    name: Generate a sitemap

    steps:
    - name: Checkout the repo
      uses: actions/checkout@v2
      with:
        fetch-depth: 0 

    - name: Generate the sitemap
      id: sitemap
      uses: cicirello/generate-sitemap@v1
      with:
        base-url-path: https://THE.URL.TO.YOUR.PAGE/

    - name: Output stats
      run: |
        echo "sitemap-path = ${{ steps.sitemap.outputs.sitemap-path }}"
        echo "url-count = ${{ steps.sitemap.outputs.url-count }}"
        echo "excluded-count = ${{ steps.sitemap.outputs.excluded-count }}"
```

### Example 2: Webpage for API Docs

This example workflow illustrates how you might use this to generate
a sitemap for a Pages site in the `docs` directory of the
repository. It also demonstrates excluding `pdf` files, and
configuring a plain text sitemap.

```yml
name: Generate API sitemap

on:
  push:
    branches: [ main ]

jobs:
  sitemap_job:
    runs-on: ubuntu-latest
    name: Generate a sitemap

    steps:
    - name: Checkout the repo
      uses: actions/checkout@v2
      with:
        fetch-depth: 0 

    - name: Generate the sitemap
      id: sitemap
      uses: cicirello/generate-sitemap@v1
      with:
        base-url-path: https://THE.URL.TO.YOUR.PAGE/
        path-to-root: docs
        include-pdf: false
        sitemap-format: txt

    - name: Output stats
      run: |
        echo "sitemap-path = ${{ steps.sitemap.outputs.sitemap-path }}"
        echo "url-count = ${{ steps.sitemap.outputs.url-count }}"
        echo "excluded-count = ${{ steps.sitemap.outputs.excluded-count }}"
``` 

### Example 3: Including Additional Indexable File Types

In this example workflow, we add various additional types to the
sitemap using the `additional-extensions` input. Note that this
also include html files and pdf files since the workflow is using the
default values for `include-html` and `include-pdf`, which both default to
`true`.

```yml
name: Generate xml sitemap

on:
  push:
    branches: [ main ]

jobs:
  sitemap_job:
    runs-on: ubuntu-latest
    name: Generate a sitemap

    steps:
    - name: Checkout the repo
      uses: actions/checkout@v2
      with:
        fetch-depth: 0 

    - name: Generate the sitemap
      id: sitemap
      uses: cicirello/generate-sitemap@v1
      with:
        base-url-path: https://THE.URL.TO.YOUR.PAGE/
        additional-extensions: doc docx ppt pptx xls xlsx

    - name: Output stats
      run: |
        echo "sitemap-path = ${{ steps.sitemap.outputs.sitemap-path }}"
        echo "url-count = ${{ steps.sitemap.outputs.url-count }}"
        echo "excluded-count = ${{ steps.sitemap.outputs.excluded-count }}"
```

### Example 4: Combining With Other Actions

Presumably you want to do something with your sitemap once it is 
generated. In this example workflow, we combine it with the action
[peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request).
First, the `cicirello/generate-sitemap` action generates the sitemap. And
then the `peter-evans/create-pull-request` monitors for changes, and
if the sitemap changed will create a pull request.

```yml
name: Generate xml sitemap

on:
  push:
    branches: [ main ]

jobs:
  sitemap_job:
    runs-on: ubuntu-latest
    name: Generate a sitemap

    steps:
    - name: Checkout the repo
      uses: actions/checkout@v2
      with:
        fetch-depth: 0 

    - name: Generate the sitemap
      id: sitemap
      uses: cicirello/generate-sitemap@v1
      with:
        base-url-path: https://THE.URL.TO.YOUR.PAGE/

    - name: Create Pull Request
      uses: peter-evans/create-pull-request@v3
      with:
        title: "Automated sitemap update"
        body: > 
          Sitemap updated by the [generate-sitemap](https://github.com/cicirello/generate-sitemap) 
          GitHub action. Automated pull-request generated by the 
          [create-pull-request](https://github.com/peter-evans/create-pull-request) GitHub action.
```

## Real Examples From Projects Using the Action

### Personal Website

This first real example is from the [personal website](https://www.cicirello.org/) 
of the developer. One of the workflows, 
[sitemap-generation.yml](https://github.com/cicirello/cicirello.github.io/blob/staging/.github/workflows/sitemap-generation.yml), 
is strictly for generating the sitemap. It runs on pushes of either `*.html` or `*.pdf` 
files to the staging branch of this repository. After generating the sitemap, it uses 
[peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request)
to generate a pull request. You can also replace that step with a commit and push instead.
You can find the resulting sitemap here: [sitemap.xml](https://www.cicirello.org/sitemap.xml).

### Documentation Website for a Java Library

This next example is for the documentation website of 
the [Chips-n-Salsa](https://chips-n-salsa.cicirello.org/) library. The
[docs.yml](https://github.com/cicirello/Chips-n-Salsa/blob/master/.github/workflows/docs.yml)
workflow runs on push and pull-requests of either `*.java` files. It uses Maven
to run javadoc (e.g., with `mvn javadoc:javadoc`). It then copies the generated javadoc
documentation to the `docs` directory, from which the API website is served. This is followed
by another GitHub Action, 
[cicirello/javadoc-cleanup](https://github.com/cicirello/javadoc-cleanup),
which makes a few edits to the javadoc generated website to improve mobile browsing. 

Next, it commits any changes (without pushing yet) produced by javadoc and/or 
javadoc-cleanup. After performing those commits, it now runs the generate-sitemap
action to generate the sitemap. It does this after committing the site changes so that
the lastmod dates will be accurate. Finally, it uses 
[peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request)
to generate a pull request. You can also replace that step with a commit and push instead.

You can find the resulting sitemap here: [sitemap.xml](https://chips-n-salsa.cicirello.org/sitemap.xml).

## Support the Project

You can support the project in a number of ways:
* __Starring__: If you find the `generate-sitemap` action 
  useful, consider starring the repository.
* __Sharing with Others__: Consider sharing it with others who
  you feel might find it useful.
* __Reporting Issues__: If you find a bug or have a suggestion for
  a new feature, please report it via 
  the [Issue tracker](https://github.com/cicirello/generate-sitemap/issues).
* __Contributing Code__: If there is an open issue that you think
  you can help with, submit a pull request.
* __Sponsoring__: You can also consider 
  [becoming a sponsor](https://github.com/sponsors/cicirello).
  
## License

The scripts and documentation for this GitHub action is released under
the [MIT License](https://github.com/cicirello/generate-sitemap/blob/master/LICENSE).
