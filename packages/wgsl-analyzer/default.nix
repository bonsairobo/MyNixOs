{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wgsl-analyzer";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "wgsl-analyzer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2Y0sFjLHhzBF5vTCTmMWpKWTXPIjujbpfBSlExnd7H4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "la-arena-0.3.1" = "sha256-7/bfvV5kS13zLSR8VCsmsgoWa7PHidFZTWE06zzVK5s=";
      "naga-0.11.0" = "sha256-xvyJVNiPo30/UOx5YWaK3GE0firXpKEMjtcBQ8hb5g0=";
    };
  };

  patches = [
    # https://github.com/wgsl-analyzer/wgsl-analyzer/issues/109
    ./fix_tests.diff
  ];

  meta = {
    description = "A language server implementation for the WGSL shading language";
    homepage = "https://github.com/wgsl-analyzer/wgsl-analyzer";
    mainProgram = "wgsl_analyzer";
  };
}
