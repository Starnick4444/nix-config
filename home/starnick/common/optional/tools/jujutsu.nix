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
            shift  # Remove the first argument, leaving potential extra arguments in $@
            HASH=$(jj log -r "''${INPUT}" -T commit_id --no-graph)
            HASHINFO=$(git log -n 1 ''${HASH} --oneline --color=always)

            # Start with the base parameter
            PARAMS="l=Autosubmit+1"

            # Append additional arguments with commas (if any exist)
            if [ $# -gt 0 ]; then
              EXTRA_ARGS=$(printf "%s" "$@" | paste -sd "," -)
              PARAMS="''${PARAMS},''${EXTRA_ARGS}"
            fi

            echo "Pushing from commit ''${HASHINFO}"
            git push origin "''${HASH}":refs/for/canon%''${PARAMS}
          ''
          ""
        ];
      };
      ui = {
        diff-formatter = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
      };
    };
  };
  home.packages = [ pkgs.difftastic ];
}
