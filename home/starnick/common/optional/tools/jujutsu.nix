{ pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    package = pkgs.unstable.jujutsu;
    settings = {
      aliases = {
        cl-up = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            set -euo pipefail
            INPUT=''${1:-"@-"}
            HASH=$(jj log -r "''${INPUT}" -T commit_id --no-graph)
            HASHINFO=$(git log -n 1 ''${HASH} --oneline --color=always)
            echo "Pushing from commit ''${HASHINFO}"
            git push origin "''${HASH}":refs/for/canon
          ''
          ""
        ];
      };
    };
  };
}
