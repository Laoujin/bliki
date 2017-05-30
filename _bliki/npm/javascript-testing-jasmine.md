---
layout: post
title:  "JavaScript Testing: Jasmine"
date:   2017-05-29 12:00:00 +0200
categories: javascript
tags: [javascript,tutorial,testing]
series: jasmine
---

{% include toc title="Jasmine Tutorial" icon="icon-javascript" %}

Probably the most widely used JavaScript testing framework.

This tutorial covers installation, configuration and execution only.
For the Jasmine syntax, see part 2!

<!--more-->

## Install

Add Jasmine to your project:

```sh
npm install --save-dev jasmine
./node_modules/.bin/jasmine init
```

You can omit the `./node_modules/.bin/` if you have Jasmine installed globally.
The following code snippets will assume you did.

If you have no clue how to start, some **working examples** can be created with `jasmine examples`.



## Configure

`jasmine init` creates `./spec/support/jasmine.json` where you can configure your testing preferences.
If you want to put the jasmine.json file somewhere else, you can do so 
by providing a value for the environment variable `JASMINE_CONFIG_PATH`.

```json
{
	"spec_dir": "spec",
	"spec_files": [
		"**/*[sS]pec.js"
	],
	"helpers": [
		"helpers/**/*.js"
	]
}
```

The default Jasmine configuration makes the assumption that 
all tests are placed in `./spec/` and are suffixed with `spec.js`.
Helpers (not covered here) allow you to provide custom matchers in your tests.

If you want to place your tests closer to the actual code they are testing, you can
simply change `spec_dir`. If the source code is in `./src` use the following spec_dir values:
- `src/**/spec`: The tests for `/src/path/to/file.js` would be in `/src/path/to/spec/fileSpec.js`.
- `src`: To place the tests in the same folder as the source files.

Note that paths in the json are relative to where `jasmine init` was executed.



## Run

Run the tests with a simple `jasmine` or add to your package.json:

```json
"scripts": {
	"test": "jasmine",
	"test:w": "nodemon --exec \"npm test\""
},
```

`test:w`(atch) requires a `npm install --save-dev nodemon` to work.
