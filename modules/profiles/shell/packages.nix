{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    bat # cat
    difftastic # diff
    doggo # dig
    duf # df
    dust # du
    # choose # awk/cut
    exiftool
    fd # find
    fzf
    # glow
    hyperfine
    jq
    just # make
    moor # less
    oxipng
    p7zip
    pandoc
    procs # ps
    ripgrep # grep
    scooter # interactive find-and-replace
    sd # sed
    snitch # ss/netstat
    tectonic # for using as pandoc's pdf-engine
    trash-cli # rm
    # keep-sorted end
  ];
}
