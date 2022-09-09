# github-client

![chipset](https://img.shields.io/badge/M1-ffffff?style=flat&logo=apple&logoColor=000000)
![macOS](https://img.shields.io/badge/12.1-ffffff?style=flat&logo=macOS&logoColor=000000)
![Xcode](https://img.shields.io/badge/13.3.1-ffffff?style=flat&logo=Xcode&logoColor=147EFB)

| Public Repository | Private Repository |
| --- | --- |
| ![Simulator Screen Recording - iPhone 13 - 2022-09-09 at 11 14 32](https://user-images.githubusercontent.com/86991723/189258152-ff5034ae-0748-4909-873b-a443ed86fe89.gif) | ![Simulator Screen Recording - iPhone 13 - 2022-09-09 at 11 14 45](https://user-images.githubusercontent.com/86991723/189258168-e952804f-0e49-4d93-9442-eb783866935b.gif) |

## Required

### Tool

- [Xcodegen](https://github.com/yonaskolb/XcodeGen) ver 2.32.0

### Github Personal Access Token

API接続時に使用する[Github Personal Access Tokenを用意](https://github.com/settings/tokens)して、
プロジェクトのルートに `.github-access-token` というファイル名で保存する。

ex)
```
$ touch .github-access-token
$ echo YOUR_GITHUB_ACCESS_TOKEN > .github-access-token
```
### Generate xcodeproject file

`$ xcodegen` を実行でプロジェクトファイルを生成、実行可能になる。
