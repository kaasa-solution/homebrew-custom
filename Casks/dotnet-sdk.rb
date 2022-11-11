cask "dotnet-sdk" do
  arch arm: "arm64", intel: "x64"

  on_intel do
    version "6.0.403,bc5cc4ae-e1e8-43fb-9471-cf6469f8db98,0033246d9e1bbc9af3952d602af68c50"
    sha256 "71b9435f38d2e85affebb4177bd218f2f1ffd648fc6df22470fa93cc574f9b40"
  end
  on_arm do
    version "6.0.403,1d1846e3-8e51-4b83-83b5-2d00c384a8ed,62a4a23c59d97114a2156fe1736ee975"
    sha256 "f8a1073be3ae03af2ae73b6ba18cc3b81ef7072af3a500463be5a67ad7ce5171"
  end

  url "https://download.visualstudio.microsoft.com/download/pr/#{version.csv.second}/#{version.csv.third}/dotnet-sdk-#{version.csv.first}-osx-#{arch}.pkg"
  name ".NET SDK"
  desc "Developer platform"
  homepage "https://www.microsoft.com/net/core#macos"

  livecheck do
    url "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/#{version.major_minor}/releases.json"
    regex(%r{/download/pr/([^/]+)/([^/]+)/dotnet-sdk-v?(\d+(?:\.\d+)+)-osx-#{arch}\.pkg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[2]},#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: [
    "dotnet",
    "homebrew/cask-versions/dotnet-preview",
    "homebrew/cask-versions/dotnet-sdk-preview",
  ], formula: "dotnet"
  depends_on macos: ">= :mojave"

  pkg "dotnet-sdk-#{version.csv.first}-osx-#{arch}.pkg"
  binary "/usr/local/share/dotnet/dotnet"

  uninstall pkgutil: [
              "com.microsoft.dotnet.*",
              "com.microsoft.netstandard.pack.targeting.*",
            ],
            delete:  [
              "/etc/paths.d/dotnet",
              "/etc/paths.d/dotnet-cli-tools",
            ]

  zap trash: [
    "~/.dotnet",
    "~/.nuget",
  ]
end
