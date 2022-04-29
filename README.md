# WSLeitner

Leitner is the method to memorize and learn, You can find more about it on [Wikipedia](https://en.wikipedia.org/wiki/Leitner_system), **WSLeitner** is a Package to facilitate implementing it.

The Idea is to provide a list of `CardProtocol` and initialize `Leitner` and then calling `next()` will create a `LeitnerSession` using that you have access to the current card to review and calling `LeitnerSession.success()` or `LeitnerSession.failure()` you can tell whether or not your answer was correct. all the state is stored on memory you have to use `LeitnerCardDelegate` to store the new state of cards in the Persistent Store.

## Installation
### Swift Package Manager
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