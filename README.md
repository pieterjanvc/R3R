# R3R - Code Rigour, Reproducibility and Responsibility in R

This demo repo is used to teach coding practices that ensure robust and
reproducible analyses.

The dummy project will provide some code related to single cell RNA sequencing,
but has been written for demonstrating project organization and not actual
analysis so do not use it for that purpose.

The information below is a summary on how to setup a good R project for a data
science project.

## Step 1 - Project Setup

Larger projects in R are best organized as a package as this allows the use of
the `devtools` and `usethis` libraries (install if needed).

### Create a package structure

```r
usethis::create_package()
```

_This can be run in an existing folder_

All R scripts that will contain functions relevant to your project should be put
into the `/R` folder. If you have a pipeline or other main script that is using
the functions declared in the `/R` folder, you can put that in the root folder.

### Git + GitHub

You should always use git for a coding project, and make good use of commits,
branching and GitHub collaboration tools where relevant.

To initialize git, make sure you are in the project root folder and run

```shell
git init
```

## Step 2 - Code organization

### Reproducible best practices

- Have a list of all dependencies and R version used for development / testing
  (see roxygen below for more info)
- Never use hard-coded paths
- Set seeds `set.seed()` for random processes where applicable
- Provide dummy / test datasets or functions that can generate reproducible data

### Functions

Try to parse out steps in your pipeline, analysis, ... into separate functions.
This has many advantages

- Make code modular
- Allow dedicated (unit) testing
- Improve overview and readability
- Reuse components across your project or even in other projects

### Automated formatting

It is highly recommended to format your code using a formatter. This not only
increases readability, but also improves consistency and saves a lot of time as
you no longer have to worry about where to add linebreaks or other formatting
choices.

In R, `styler` is the most popular package which can automatically style all
files in a project or folder using

```r
styler::style_pkg()
```

Alternatively you can use `style_dir()` or `style_file()`

Posit also released [Air](https://www.tidyverse.org/blog/2025/02/air/) an
extension and language server with very fast and convenient styling options

## Step 3 - Documentation

### README

Each repo should at least have a README file in the root folder, preferably
written in markdown. Sub-folders can have their own README files if applicable

### Generate function documentation with roxygen2

The `roxygen2` library allows you to generate all from any function annotated
with roxygen compatible docstrings.

See the [website](https://roxygen2.r-lib.org/articles/roxygen2.html) to learn
more about how to create these doc strings.

Once created, generating the actual documentation is done by running

```r
roxygen2::roxygenize()
```

_This will also automatically update the NAMESPACE file with dependencies_

## Step 4 - Automated testing

### Initialize the folders that will hold the test scripts

```r
usethis::use_testthat()
```

### Create a test file per script in the `/R` folder

Make sure you have the script for which you want to create the test file open
and selected, then run

```r
usethis::use_test()
```

This will generate a test file in the `tests/testthat` folder with the name
`test-<scriptName>.R`

To run all tests

```r
devtools::test()
```

## Step 5 - Sharing

Depending on the application, there are multiple ways you can share your project
based on your needs.

### GitHub

At least your code should be available on GitHub to ensure reproducibility. Make
sure not to commit large datasets and consider hosting data elsewhere.

### Publishing as a package

You can use GitHub or Cran to publish your project as an R package so others can
install it from within R

### Docker or other containers

Tools like docker allow you to "freeze" a whole workflow into a sandbox
container such that all software, data and other dependencies are combined into
a single application. It is nice for reproducibility, but can be a hassle to set
up and may not be useful for some applications or is not supported on some
platforms
