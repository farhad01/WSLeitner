# WSLeitner

Leitner is method to memorize and learn, find more about it at wikipedia, **WSLeitner** is a Package to facilitate implementing it.

The Idea is to provide list of `CardProtocol` and initialize `Leitner` then calling `next()` will create a `LeitnerSession` using that you have access to the current card to review and calling `LeitnerSession.success()` or `LeitnerSession.failure()` you can tell whether or not the your answer was correct. all the state is stored on memory you have to use `LeitnerCardDelegate` to store new state of cards in Persistent store.

## Installation

```swift
dependencies: [
    .package(
        url: "https://github.com/farhad01/WSLeitner.git",
        .upToNextMajor(from: "1.0.0"))
]
```

## Usage
```swift
struct Card: CardProtocol {
    var reviewTime: Date
    var box: Box
    var id: ObjectIdentifier
}

class LeitnerDelegate: LeitnerCardDelegate {
    func update(card: Card) {
        // store new reviewTime and box using the `id` persistently.
    }
}

let leitner: Leitner<LeitnerDelegate> = Leitner(cards: [/*Your cards hear*/])

let session = leitner.next()

session?.success()
//OR
session?.failure()

```

## License
Licensed under the Apache License, Version 2.0. [Copy of the license](LICENSE).