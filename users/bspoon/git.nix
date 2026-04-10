{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "0bSpoon";
        email = "bSpoon@outlook.jp";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    ignores = [
      ".ai-local/"
    ];
  };
}
