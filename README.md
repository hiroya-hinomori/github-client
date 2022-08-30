# github-client

![chipset](https://img.shields.io/badge/M1-ffffff?style=flat&logo=apple&logoColor=000000)
![macOS](https://img.shields.io/badge/12.1-ffffff?style=flat&logo=macOS&logoColor=000000)
![Xcode](https://img.shields.io/badge/13.3.1-ffffff?style=flat&logo=Xcode&logoColor=147EFB)

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
