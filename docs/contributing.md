# Contributing

- [Contributing](#contributing)
  - [1. Ruby coding standards](#1-ruby-coding-standards)
    - [1.1. Documentation](#11-documentation)
    - [1.2. Naming](#12-naming)
    - [1.3. Formatting](#13-formatting)
  - [2. Committing](#2-committing)
  - [3. IDE recommendations](#3-ide-recommendations)

## 1. Ruby coding standards

### 1.1. Documentation

The Ruby *entities* such as classes, modules and functions should have their respective [YARD](https://www.rubydoc.info/gems/yard/file/README.md) documentation (please check [section 3](#3-recommended-vscode-extensions)). The name of those entities should be ideally self-descriptive, so as not to place a description on every entity, but the types must be documented properly (e.g. function parameters, return type, class attributes). Note that, as YARD is the standard for Ruby, when documenting types with it, your IDE will recognize them and thus will be able to help with autocompletion, etc.

For documenting models, please do it in the model class and not in the migration. [This good man](https://stackoverflow.com/questions/64678789/documenting-ruby-on-rails-models-with-yard) provides a good example of the format.

### 1.2. Naming

Of course, everything should be in english, as is the standard in the industry. For this project, `camelCase` will be used for both methods, attributes and variables (except for Rails models), instead of Ruby's recommended style (which is `snake_case`). All other Ruby naming standards will be followed (e.g. `PascalCase` for class/module names, indentation of 2 spaces, etc.).

### 1.3. Formatting

- Parenthesis have to be used wherever possible, in order to distinguish actual methods with attributes (attribute getters). This includes methods with no parameters.
- Automatic formatting with [`rufo`](https://github.com/ruby-formatter/rufo) linter.
- Line breaks should be configured at 100 characters. Make sure to set a vertical ruler at that threshold in your IDE, as the `rufo` formatter does not yet includes automatic line breaks.

<!-- TODO: decide if to use `rufo` or `rubocop`, and automate it in `Makefile` and `settings.json` somehow -->

## 2. Committing

... <!-- TODO, sometime -->

## 3. IDE recommendations

It is strongly advised to use Visual Studio Code IDE with the following extensions:

1. [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments): as various comments are formatted to be rendered nicely by this tool.
2. [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker): for `Dockerfile` and `docker-compose` intellisense.
3. [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one): for various smart Markdown utilities, such as automatic section headers and table of contents, formatting, and more.
4. [Markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint): linter for implementing the best practices on the industry for writing Markdown files.
5. [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker): great tool for avoiding typos on code and documentation.
6. [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph): autocompletion and intellisense for Ruby files, specially useful if you refuse to use [RubyMine IDE](https://www.jetbrains.com/ruby/) at all.
7. [Yard documenter](https://marketplace.visualstudio.com/items?itemName=pavlitsky.yard): ruby documentation generator for functions, classes and modules. Once installed, locate your cursor in a function you want to document, and run on the command palette (with `ctrl+shift+p`): `Document with YARN`.
8. [Rufo formatter](https://marketplace.visualstudio.com/items?itemName=jnbt.vscode-rufo): code linter for Ruby integrated in the IDE.

Note: since [RubyMine](https://www.jetbrains.com/ruby/) has great build-in intellisense, it is recommended to use that IDE as well, for when the listed `vscode` extensions are not smart enough, specially when editing views with embedded ruby code.
