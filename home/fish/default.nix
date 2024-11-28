{ pkgs, ... }:
let
  myAliases = {
    # PS
    psa = "ps aux";
    psg = "ps aux | grep ";

    # show me files matching "ls grep"
    lsg = "ll | rg";

    # Git Aliases
    # Don't try to glob with zsh so you can do
    # stuff like ga *foo* and correctly have
    # git add the right stuff
    # git = "noglob git";
    gs = "git status";
    gst = "git stash";
    gsp = "git stash pop";
    gsa = "git stash apply";
    gsh = "git show";
    gshw = "git show";
    gshow = "git show";
    gi = "vim .gitignore";
    gcm = "git ci -m";
    gcim = "git ci -m";
    gci = "git ci";
    gco = "git co";
    gcp = "git cp";
    ga = "git add -A";
    guns = "git unstage";
    gunc = "git uncommit";
    gm = "git merge";
    gms = "git merge --squash";
    gam = "git amend --reset-author";
    grv = "git remote -v";
    grr = "git remote rm";
    grad = "git remote add";
    gr = "git rebase";
    gra = "git rebase --abort";
    ggrc = "git rebase --continue";
    gbi = "git rebase --interactive";
    gl = "git l";
    glg = "git l";
    glog = "git l";
    co = "git co";
    gf = "git fetch";
    gfch = "git fetch";
    gd = "git diff";
    gb = "git b";
    gbd = "git b -D -w";
    gdc = "git diff --cached -w";
    gpub = "grb publish";
    gtr = "grb track";
    gpl = "git pull";
    gplr = "git pull --rebase";
    gps = "git push";
    gpsh = "git push";
    gnb = "git nb"; # new branch aka checkout -b
    grs = "git reset";
    grsh = "git reset --hard";
    gcln = "git clean";
    gclndf = "git clean -df";
    gclndfx = "git clean -dfx";
    gsm = "git submodule";
    gsmi = "git submodule init";
    gsmu = "git submodule update";
    gt = "git t";
    gbg = "git bisect good";
    gbb = "git bisect bad";

    ls = "eza -l";
    cat = "bat";
    fd = "fd -L";
    cd = "z";
  };
in
{
  programs.fish = {
    enable = true;
    shellAliases = myAliases;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellInitLast = "direnv hook fish | zoxide init fish | source";
    plugins = [
      { name = "done"; inherit (pkgs.fishPlugins.done) src; }
    ];
  };
}
