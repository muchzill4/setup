# Refactoring

## Two Hats

You are either adding functionality or refactoring — never both at once. When refactoring, add no new behavior. When adding features, resist restructuring. Swap hats frequently, but always know which you are wearing.

## Make the change easy, then make the easy change

Before implementing a feature, restructure existing code so the feature becomes trivial to add.

## Mixed abstraction levels are the real smell

A method at one level of abstraction is fine regardless of length. A short method mixing policy and mechanism is worse. Refactor to separate abstraction levels, not to hit a line count.
