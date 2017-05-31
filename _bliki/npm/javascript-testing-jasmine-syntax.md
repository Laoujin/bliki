---
layout: post
title:  "JavaScript Testing: Jasmine syntax"
date:   2017-05-30 12:00:00 +0200
categories: javascript
tags: [javascript,cheat-sheet,testing]
series: js-testing
---

{% include toc title="Jasmine Syntax" icon="icon-javascript" %}

Time to start writing some real tests with Jasmine!

<!--more-->

## Basic example

```js
describe('basic example', () => {
	beforeEach(() => {
		this.result = 1;
	});

	it('can hardly fail', () => {
		// toBe() uses ===
		expect(this.result).toBe(1);

		// For primitive types, toEqual
		// behaves the same way as toBe
		// toEqual goes further however
		// by deeply comparing objects.
		expect({a: {}}).toEqual({a: {}});
		expect([0, {a: 1}]).toEqual([0, {a: 1}]);
	});

	afterAll(() => {});
});
```

A `describe` groups one or more related tests together in a suite. Describes can be nested indefinitely
and contain one `it` for each test in the suite.

`beforeAll` and `afterAll` runs once before/after all tests in the containing describe are executed.
`beforeEach` and `afterEach` runs once before/after each test is executed.

The `this` context is shared in the beforeX/afterX functions and the `it`s, allowing you to setup/teardown stuff
and access them in your tests.




## Matchers

Set expectations with matchers. Usage and differences of `toBe` and `toEqual` are already covered
in the basic example above. These are the other matchers:

```js


```

The [matchers source][jasmine-matchers] for if you'd like to take a peek at the implementations.



## Async example

```js

```

TODO: Add new Clock().install().tick(ms)
jasmine.clock() = get currently booted mock


An `it` has a third optional timeout parameter (in ms) which defaults to the global
variable `jasmine.DEFAULT_TIMEOUT_INTERVAL` (=5000ms).

To cover:
- async (done)
- spyOn() and spyOnProperty + jasmine.createSpy('name', originalFn) and jasmine.createSpyObj

done.fail('err')


## Workflow

If you are iterating over the same test(s) you can temporarily run these tests by prefixing
one or more `describe` and/or `it`s with an f.
You can also execute a single file from the CLI `jasmine src/someSpec.js`.

Obviously you'll never want to do the opposite: exclude a test from the suite. But.. If you must, it is possible
to temporarily disable a describe/it by prefixing it with an x.

```js
// f = focused
fdescribe('only my its will run', () => {
	it('which is me', () => {});
	it('and me', () => {});
	xit('but not me', () => {});
});

xit('I will not run, even if the fdescribe above is removed', () => {});
```

Other helpers available in an `it`:
- `pending(string)`. An `it` where the second parameter is omitted is automatically pending.
- `fail(string | Error)`



[jasmine-matchers]: https://github.com/jasmine/jasmine/blob/master/src/core/matchers
