---
layout: post
title:  "JavaScript Testing: Jasmine customization"
date:   2017-05-31 00:00:00 +0200
categories: javascript
tags: [javascript,cheat-sheet,testing]
series: js-testing
---

{% include toc title="Customization" icon="icon-javascript" %}


- reporters
- custom matchers
- custom boot? from CLI: jasmine spec/run.js
- ...

<!--more-->

## Environment

- inserting global functions: t() --> boot.js?

CLI options
jasmine JASMINE_CONFIG_PATH=spec/jasmine.json --filter=\"a spec name\" --stop-on-failure=true --no-color --random=true -seed=7337





jasmine.addCustomEqualityTester(tester) / addMatchers()
- Only available in a beforeEach or beforeAll
- May be defined in a helper


next part: Mocks

## Spies



Nock? rewire? proxyquire?


