# Contributing

Welcome! This document details instructions for contributing to TomaRamosApp.

- [Contributing](#contributing)
  - [1. Ruby coding standards](#1-ruby-coding-standards)
    - [1.1. Documentation](#11-documentation)
    - [1.2. Naming (Ruby)](#12-naming-ruby)
    - [1.3. Formatting (Ruby)](#13-formatting-ruby)
  - [2. Committing](#2-committing)
  - [Languages](#languages)
  - [3. IDE recommendations](#3-ide-recommendations)
    - [3.1. Documentation](#31-documentation)
    - [3.2. Coding](#32-coding)
    - [3.3. Git](#33-git)

## 1. Ruby coding standards

### 1.1. Documentation

The Ruby *entities* such as classes, modules and functions should have their respective [YARD](https://www.rubydoc.info/gems/yard/file/README.md) documentation (please check [section 3](#3-ide-recommendations)). The name of those entities should be ideally self-descriptive, so as not to place a description on every entity, but the types must be documented properly (e.g. function parameters, return type, class attributes). Note that, as YARD is the standard for Ruby, when documenting types with it, your IDE will recognize them and thus will be able to help with autocompletion, etc.

For documenting models, please do it in the model class and not in the migration. [This good man](https://stackoverflow.com/questions/64678789/documenting-ruby-on-rails-models-with-yard) provides a good example of the format.

### 1.2. Naming (Ruby)

Of course, everything should be in english, as is the standard in the industry. For this project, `camelCase` will be used for both methods, attributes and variables (except for Rails models), instead of Ruby's recommended style (which is `snake_case`). All other Ruby naming standards will be followed (e.g. `PascalCase` for class/module names, indentation of 2 spaces, etc.).

### 1.3. Formatting (Ruby)

- Parenthesis have to be used wherever possible, in order to distinguish actual methods (callables) with attributes (not callables). This includes methods with no parameters.
- Strings in double quotes.
- Indentation with 2 spaces.
- Automatic formatting with [`rufo`](https://github.com/ruby-formatter/rufo) linter, mostly.
- Line breaks should be configured at 100 characters. Make sure to set a vertical ruler at that threshold in your IDE.

## 2. Committing

Commit names must be meaningful and should always reference an issue they are related to. The expected format is the following (note the blank line between *paragraphs*):

```text
#ISSUE_NUMBER: meaningful summary

Detailed summary of changes
```

Example for WIP commit on an issue:

```text
#33: fix on documentation related to tests

And some refactorings
```

Example for when closing an issue:

```text
Closes #18: added working cookie dialog

- Added standard modal automatically displayed when a host with no session (cookies) access any page
- Also added blank JavaScript files properly included for each controller
```

## Languages

Git commit messages and ALL code (including code documentation) must be in english, as it is the standard in the software industry. Markdown documents should also be in english. Other ways of communication (e.g. GitHub issues and GitHub discussion) has to be in spanish.

## 3. IDE recommendations

It is strongly advised to use Visual Studio Code IDE with the extensions mentioned in this section, separated from the contribution scope. They are also recommended for just code reading.

### 3.1. Documentation

- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one): for various smart Markdown utilities, such as automatic section headers and table of contents, formatting, and more.
- [Markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint): linter for implementing the best practices on the industry for writing Markdown files.

### 3.2. Coding

- [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments): as various comments are formatted to be rendered nicely by this tool.
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker): for `Dockerfile` and `docker-compose` intellisense.
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker): great tool for avoiding typos on both code and documentation.
- [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph): autocompletion and intellisense for Ruby files, specially useful if you refuse to use [RubyMine IDE](https://www.jetbrains.com/ruby/) at all.
- [Yard documenter](https://marketplace.visualstudio.com/items?itemName=pavlitsky.yard): ruby documentation generator for functions, classes and modules. Once installed, locate your cursor in a function you want to document, and run on the command palette (with `ctrl+shift+p`): `Document with YARN`.
- [Rufo formatter](https://marketplace.visualstudio.com/items?itemName=jnbt.vscode-rufo): code linter for Ruby integrated in the IDE.

Note: since [RubyMine](https://www.jetbrains.com/ruby/) has great build-in intellisense, it is recommended to use that IDE as well, for when the listed `vscode` extensions are not smart enough, specially when editing views (with embedded ruby code).

### 3.3. Git

- [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph): provides visualization of commit history. Useful for viewing changes and merges on branches.
