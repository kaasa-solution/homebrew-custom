cask "dotnet-sdk" do
  arch arm: "arm64", intel: "x64"

  on_intel do
    version "6.0.404,a93ff2f8-c9f6-41d9-ac15-1b96e77f111e,5296b688fcb69e34eb2c6d05a915ee71"
    sha256 "ad76beaec22daccd535118b152f74c2bbbd7377ea8aab421ab992e89df41d29c"
  end
  on_arm do
    version "6.0.404,2a309cee-38ac-4fb5-877e-e4d0a9dbff1b,01a4ad5d7a0ff5734e0749b3880485fb"
    sha256 "c603621b0a579299952f6aebacea79904c50b61131126b8107c7662d063a8204"
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
