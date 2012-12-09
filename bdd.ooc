//
// bdd.ooc
// A simple BDD-style testing library with nice colors and stuff
// 
// Copyright (c) 2012, Wander Nauta
// 
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
// 
// The software is provided "as is" and the author disclaims all warranties
// with regard to this software including all implied warranties of
// merchantability and fitness. In no event shall the author be liable for any
// special, direct, indirect, or consequential damages or any damages
// whatsoever resulting from loss of use, data or profits, whether in an action
// of contract, negligence or other tortious action, arising out of or in
// connection with the use or performance of this software.

import text/Regexp
import os/Terminal
import os/Time

describe: func (name: String, code: Func) {
    BDD specs_total += 1
    BDD nest += 1 // Increase indentation

    if (BDD nest == 1) {
        println()
    }
    
    "  " times(BDD nest - 1) print()

    name println() // Print the spec name
    code() // Execute the spec
    BDD nest -= 1 // Decrease indentation
}

it: func (name: String, test: Func) {
    BDD reset()

    test()

    if (BDD failed == 0) {
        Terminal setFgColor(Color green)
    } else {
        Terminal setFgColor(Color red)
    }

    "%s%s" printfln("  " times(BDD nest), name)

    Terminal reset()
}

BDD: class {
    failed: static UInt = 0
    passed: static UInt = 0

    failed_total: static UInt = 0
    passed_total: static UInt = 0
    specs_total: static UInt = 0

    nest: static UInt = 0

    pass: static func {
        passed += 1
        passed_total += 1
    }

    fail: static func {
        failed += 1
        failed_total += 1
    }

    reset: static func {
        BDD failed = 0
        BDD passed = 0
    }

    assert: static func (test: Bool) {
        if (test) {
            pass()
        } else {
            fail()
        }
    }

    tally: static func () {
        "\n---\nTotals: %d passed, %d failed, %d total in %d specs taking %dms" printfln(BDD passed_total, BDD failed_total, BDD passed_total + BDD failed_total, BDD specs_total, Time runTime)
    }
}

Expectation: class <T> {
    a: T
    inverted: Bool

    init: func (value: T, inv := false) {
        a = value
        inverted = inv
    }

    toBe: func ~Bool (b: Bool) {
        BDD assert((T == Bool && !(a as Bool) == !b) ^ inverted)
    }

    toBe: func ~String (b: String) {
        BDD assert((T == String && (a as String) == b) ^ inverted)
    }

    toBe: func ~Numeric (b: LLong) {
        BDD assert((T inheritsFrom?(LLong) && a as LLong == b) ^ inverted)
    }

    toContain: func ~String (b: String) {
        BDD assert((T == String && (a as String) contains?(b)) ^ inverted)
    }

    toMatch: func ~Regex (b: String) {
        rb := Regexp compile(b)
        BDD assert((T == String && rb matches(a as String) != null) ^ inverted)
    }

    not: Expectation<Bool> {
        get {
            return expect(a, !inverted)
        }
    }
}

expect: func <T> (value: T, inv := false) -> Expectation<T> {
    return Expectation new(value, inv)
}

require: func (value: Bool) {
    expect(value) toBe(true)
}

atexit(BDD tally)
