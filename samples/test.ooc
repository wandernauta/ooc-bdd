use bdd
import bdd

import structs/ArrayList

describe("A boolean expectation of true", ||
    it("should be true", ||
        expect(true) toBe(true)
    )

    it("should not be false", ||
        expect(true) not toBe(false)
    )

    it("should not not be true", ||
        expect(true) not not toBe(true)
    )
)

describe("A boolean expectation of false", ||
    it("should be false", ||
        expect(false) toBe(false)
    )

    it("should not be true", ||
        expect(false) not toBe(true)
    )
)

describe("A string \"llama\"", ||
    it("should be \"llama\"", ||
        expect("llama") toBe("llama")
    )

    it("should not be \"alpaca\"", ||
        expect("llama") not toBe("alpaca")
    )

    it("should contain \"ll\"", ||
        expect("llama") toContain("ll")
    )

    it("should match \"^[a-m]+$\"", ||
        expect("llama") toMatch("^[a-m]+$")
    )

    it("should not match \"^(.*)al(.*)$\"", ||
        expect("llama") not toMatch("^(.*)al(.*)$")
    )
)

describe("The number 12", ||
    it("should be 12", ||
        expect(12) toBe(12)
    )

    it("should not be 13", ||
        expect(12) not toBe(13)
    )
)

describe("A list with elements 'a', 'b' and 'c'", ||
    al := ArrayList<Char> new()
    al add('a')
    al add('b')
    al add('c')

    it("should have three elements", ||
        expect(al getSize()) toBe(3)
    )

    it("should not have zero elements", ||
        expect(al getSize()) not toBe(0)
    )

    it("should have 'a' as its first element", ||
        require(al first() == 'a')
    )
)

describe("A spec", ||
    describe("with a nested spec", ||
        describe("which is a nested spec", ||
            it("should pass", ||
                expect(true) toBe(true)
            )
        )
    )

    it("can have multiple tests", ||
        require(true)
        require(true)
    )
)
