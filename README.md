# LifeGame with SwiftWasm

https://life-game-with-swiftwasm.netlify.com/

**:warning: Please wait 15sec while loading**

## Requirements

- [kylef/swiftenv: Swift Version Manager](https://github.com/kylef/swiftenv)

## Bootstrap

```sh
$ swiftenv install https://github.com/swiftwasm/swift/releases/download/swift-wasm-5.3-SNAPSHOT-2020-08-20-a/swift-wasm-5.3-SNAPSHOT-2020-08-20-a-osx.tar.gz
$ npm install
$ npm run start
```

## Development

```sh
$ swift package --package-path LifeGame generate-xcodeproj
$ open LifeGame/LifeGame.xcodeproj
$ npm run start
```

![](./assets/life-game-dev.gif)
