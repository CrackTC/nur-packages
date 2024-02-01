{ lib
, buildDotnetGlobalTool
, dotnetCorePackages
}:
let
  inherit (dotnetCorePackages) sdk_8_0;
in

buildDotnetGlobalTool {
  pname = "csharprepl";
  version = "0.6.6";

  nugetSha256 = "sha256-VkZGnfD8p6oAJ7i9tlfwJfmKfZBHJU7Wdq+K4YjPoRs=";

  dotnet-sdk = sdk_8_0;
  dotnet-runtime = sdk_8_0;

  meta = with lib; {
    description = "A cross-platform command line REPL for the rapid experimentation and exploration of C#.";
    homepage = "https://github.com/waf/CSharpRepl";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
