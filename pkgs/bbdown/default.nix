{ lib
, buildDotnetGlobalTool
, dotnetCorePackages
, ffmpeg
}:

let
  pname = "BBDown";
  version = "1.6.1";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnet-sdk;
  bbdown = buildDotnetGlobalTool
    {
      inherit pname version dotnet-runtime dotnet-sdk;
      nugetSha256 = "sha256-FujKRBiuvbndxPo/SF7dOQbRqLr85mYl9Kay0W+CvkU=";

      meta = with lib; {
        description = "Bilibili Downloader";
        homepage = "https://github.com/nilaoda/BBDown";
        license = licenses.mit;
        mainProgram = pname;
        platforms = platforms.linux;
      };
    };
in
bbdown.overrideAttrs (attrs: {
  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
  '';
})
