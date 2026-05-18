{
  pkgs,
  lib,
  config,
  ...
}:
let
  nodejs = if pkgs ? nodejs_18 then pkgs.nodejs_18 else pkgs.nodejs_20;
  pnpm = pkgs.pnpm_8;
in
{
  languages.javascript = {
    enable = true;
    package = nodejs;

    pnpm = {
      enable = true;
      package = pnpm;
    };
  };

  unsetEnvVars = lib.mkAfter [
    "NODE_OPTIONS"
  ];

  packages = with pkgs; [
    awscli2
    bashInteractive
    coreutils
    curl
    findutils
    gawk
    git
    gnugrep
    gnumake
    gnused
    gnutar
    gzip
    jq
    openssh
    shellcheck
    typescript-language-server
    unzip
    yq
    zip
  ];

  env = {
    AWS_SDK_LOAD_CONFIG = "1";
  };

  scripts.install.exec = "pnpm install --frozen-lockfile";
  scripts.build.exec = "pnpm build";

  enterShell = ''
    echo "node: $(node --version)"
    echo "pnpm: $(pnpm --version)"
  '';
}
