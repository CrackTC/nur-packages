{ lib
, buildDotnetGlobalTool
, dotnetCorePackages
}:

let
  pname = "BBDown";
  version = "1.6.1";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
in
buildDotnetGlobalTool {
  inherit pname version dotnet-sdk;
  nugetSha256 = "sha256-FujKRBiuvbndxPo/SF7dOQbRqLr85mYl9Kay0W+CvkU=";

  meta = with lib; {
    description = "Bilibili Downloader";
    homepage = "https://github.com/nilaoda/BBDown";
    license = licenses.mit;
    mainProgram = "BBDown";
    platforms = [ "x86_64-linux" ];
  };
}
