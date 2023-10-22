{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdpls";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "euclio";
    repo = pname;
    rev = "30761508593d85b5743ae39c4209947740eec92d";
    sha256 = "4n1MX8hS7JmKzaL8GfMq2q3IdwE4fvMmWOYo7rY+cdY=";
  };

  cargoSha256 = "0braGtUUckReN1fqRtXcnKGlBQJzJ9XuWBk2T3ieMR8=";

  meta = {
    description = "A language server that provides a live HTML preview of markdown in your browser.";
    homepage = "https://github.com/euclio/mdpls";
    mainProgram = "mdpls";
  };
}
