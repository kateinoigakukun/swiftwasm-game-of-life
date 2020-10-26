# LifeGame with SwiftWasm

https://life-game-with-swiftwasm.netlify.com/

**:warning: Please wait 15sec while loading**

## Requirements

- [swiftwasm/carton: SwiftWasm Tool](https://github.com/swiftwasm/carton)

## Development

```sh
$ swift package --package-path LifeGame generate-xcodeproj
$ open LifeGame/LifeGame.xcodeproj
$ carton dev --custom-index-page static/index.html
```

![](./assets/life-game-dev.gif)
