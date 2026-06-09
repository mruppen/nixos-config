{ lib
, buildDotnetGlobalTool
, dotnetCorePackages
}:

buildDotnetGlobalTool rec {
  pname = "roslyn-language-server";
  version = "5.9.0-1.26303.1"; # ← Update this to the latest prerelease

  # Use the runtime-specific package for Linux
  nugetName = "roslyn-language-server.linux-x64";
  nugetSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # ← Will be replaced after first build

  dotnet-sdk = dotnetCorePackages.sdk_10_0;   # Recommended: .NET 10+
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  # Optional: source for even newer builds
  # nugetSource = "https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json";

  meta = with lib; {
    description = "Official Roslyn Language Server for C# / Razor (prerelease)";
    homepage = "https://github.com/dotnet/roslyn";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "roslyn-language-server";
  };
}
