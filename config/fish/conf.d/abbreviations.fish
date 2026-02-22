status is-interactive || exit

# Define here instead of programs.fish.shellAliases so that it expands as expected.
abbr -a e "$EDITOR"

abbr -a cp 'cp -r'
abbr -a mkdir 'mkdir -p'
abbr -a sc "systemctl --user"
abbr -a shred 'shred --verbose --zero --remove --iterations 100'
abbr -a ssc "sudo systemctl"

abbr -a ls eza
abbr -a ll "eza --long --all"
abbr -a tree 'eza --tree --all --ignore-glob=".git|.jj"'
abbr -a tl 'eza --tree --all --ignore-glob=".git|.jj" --level'

# vcs
# NOTE: don't use 'push --force' profusely. Only push changes when you're done, not
# pre-maturely and once pushed then see if you can make a commit on top to update rather
# than ammending and force-pushing.
abbr -a g git
abbr -a ga "git add"
abbr -a gaa "git add --all"
abbr -a gac "git add --all; and git commit -v"
abbr -a gb "git branch"
abbr -a gc "git commit -v"
abbr -a 'gc!' "git commit --amend"
abbr -a gcd 'git add --all; and git commit -m "$(date +%Y-%m-%d-%H%M%S)"'
abbr -a gd "git diff"
abbr -a gdf "git df" # will use difftastic instead of delta
abbr -a gf "git fetch; and git pull"
abbr -a gl "git l" # better log output
abbr -a gp "git push"
abbr -a gs "git status --short --branch"
abbr -a gscope "git config get user.email; and git config get user.signingKey"

abbr -a j jj
abbr -a jb "jj bookmark"
abbr -a jc "jj commit"
abbr -a jcd 'jj commit -m "$(date +%Y-%m-%d-%H%M%S)"'
abbr -a jd "jj diff"
abbr -a jdf "jj diff --tool difft"
abbr -a jf "jj git fetch"
abbr -a jl "jj log"
abbr -a jll "jj log -r .."
abbr -a jp "jj git push"
abbr -a js "jj status"
abbr -a jtp "jj tug; and jj git push"
abbr -a jscope "jj config get user.email; and jj config get signing.key"

# A simple version of history expansion - '!!' and '!$'
function histreplace
    switch "$argv[1]"
        case !!
            echo -- $history[1]
            return 0
        case '!$'
            echo -- $history[1] | read -lat tokens
            echo -- $tokens[-1]
            return 0
    end
    return 1
end
abbr -a !! --function histreplace --position anywhere
abbr -a '!$' --function histreplace --position anywhere

# Use dot dot for `cd ..`, the number of dots can vary.
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd
