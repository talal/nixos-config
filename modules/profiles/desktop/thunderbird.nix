{
  hm = {
    programs.thunderbird = {
      enable = true;
      languagePacks = ["en-GB" "de" "ur"];
      profiles.default = {
        isDefault = true;
        settings = {
          "app.update.auto" = false;
          "mail.shell.checkDefaultClient" = false;
          "mailnews.start_page.enabled" = false;
          "privacy.donottrackheader.enabled" = true;
        };
      };
    };
  };
}
