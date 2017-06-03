---
layout: post
title:  "JavaScript Testing: Jasmine customization"
date:   3017-06-01 00:00:00 +0200
categories: javascript
tags: [javascript,tutorial,testing]
series: js-testing
extras:
  - githubproject: https://github.com/be-pongit/jasmine-tut
---

{% include toc title="Customization" icon="icon-javascript" %}


https://jasmine.github.io/edge/custom_matcher.html

- reporters
- custom matchers
--> beforeEach, beforeAll: jasmine.addMatchers(matchers)


<!--more-->

## Environment

- inserting global functions: t() --> boot.js?


jasmine.addCustomEqualityTester(tester) / addMatchers()
- Only available in a beforeEach or beforeAll
- May be defined in a helper



describe('Hello world', function () {

  beforeEach(function () {
    this.addMatchers({
      toBeDivisibleByTwo: function () {
        return (this.actual % 2) === 0;
      }
    });
  });

  it('is divisible by 2', function () {
    expect(gimmeANumber()).toBeDivisibleByTwo();
  });

});




var customMatchers = {
	toBeGoofy: function(util, customEqualityTesters) {
	return {
		compare: function(actual, expected) {
			if (expected === undefined) {
				expected = '';
			}
			var result = {};

			result.pass = util.equals(actual.hyuk, "gawrsh" + expected, customEqualityTesters);
			if (result.pass) {
				result.message = "Expected " + actual + " not to be quite so goofy";
			} else {
				result.message = "Expected " + actual + " to be goofy, but it was not very goofy";
			}
			return result;
		}
	}
};

describe("Custom matcher: 'toBeGoofy'", function() {
  beforeEach(function() {
    jasmine.addMatchers(customMatchers);
  });

  it("is available on an expectation", function() {
   expect({
     hyuk: 'gawrsh'
   }).toBeGoofy();
  });

  it("can take an 'expected' parameter", function() {
   expect({
     hyuk: 'gawrsh is fun'
   }).toBeGoofy(' is fun');
  });

  it("can be negated", function() {
   expect({
     hyuk: 'this is fun'
   }).not.toBeGoofy();
  });
});
