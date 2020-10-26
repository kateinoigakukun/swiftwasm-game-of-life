# LifeGame with SwiftWasm

https://kateinoigakukun.github.io/swiftwasm-game-of-life/

## Requirements

- [swiftwasm/carton: SwiftWasm Tool](https://github.com/swiftwasm/carton)

## Development

```sh
$ swift package generate-xcodeproj
$ open LifeGame.xcodeproj
$ carton dev --custom-index-page static/index.html
```

![](./assets/life-game-dev.gif)
