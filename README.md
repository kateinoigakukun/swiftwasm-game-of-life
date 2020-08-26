# LifeGame with SwiftWasm

https://life-game-with-swiftwasm.netlify.com/

**:warning: Please wait 15sec while loading**

## Requirements

- Xcode 11.4 or later on macOS Catalina, or Swift 5.2 or later on Linux.
- [carton](https://carton.dev), which can be installed on macOS via [Homebrew](https://brew.sh/):

```sh
$ brew install swiftwasm/tap/carton
```

You'll have to build carton from sources on Linux. Clone the repository and run 
`swift build -c release`, the `carton` binary will be located in the `.build/release` 
directory after that.

## Development

```sh
$ carton dev
```

Open [http://127.0.0.1:8080/](http://127.0.0.1:8080/) after the initial build process has completed.
If you change the source code, `carton` will rebuild it and reload your browser tab as it watches
for changes.

![](./assets/life-game-dev.gif)
