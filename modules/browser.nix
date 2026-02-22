{pkgs, ...}: let
  langs = ["en-GB-oxendict" "de-DE"];
in {
  programs.chromium = {
    enable = true;
    extraOpts = {
      # Brave specific policies
      # keep-sorted start
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      BraveRewardsDisabled = true;
      BraveStatsPingEnabled = false;
      BraveTalkDisabled = true;
      BraveVPNDisabled = true;
      BraveWalletDisabled = true;
      # keep-sorted end

      # Common Chromium policies
      ExtensionInstallAllowlist = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "khncfooichmfjbepaaaebmommgaepoid" # Unhook
        "phmcfcbljjdlomoipaffekhgfnpndbef" # Hide YouTube Thumbnails
        "cnjifjpddelmedmihgijeibhnjfabmlf" # Obsidian Web Clipper
        "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # Google Docs Offline
        "cmpdlhmnmjhihmcfnigoememnffkimlk" # Catppuccin Macchiato theme
      ];
      # keep-sorted start
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      AutoplayAllowed = false;
      BackgroundModeEnabled = true;
      BookmarkBarEnabled = false;
      BrowserLabsEnabled = false;
      BrowserSignin = 0;
      DefaultBrowserSettingEnabled = false;
      ExtensionInstallBlocklist = ["*"];
      ForcedLanguages = langs ++ ["ur"];
      HomepageIsNewTabPage = true;
      HttpsOnlyMode = "force_enabled";
      PasswordManagerEnabled = false;
      PasswordManagerPasskeysEnabled = false;
      PrivacySandboxAdMeasurementEnabled = false;
      PrivacySandboxAdTopicsEnabled = false;
      PrivacySandboxPromptEnabled = false;
      PrivacySandboxSiteEnabledAdsEnabled = false;
      PromotionsEnabled = false;
      RestoreOnStartup = 1; # restore last session
      SearchSuggestEnabled = false;
      ShowHomeButton = false;
      SpellcheckEnabled = true;
      SpellcheckLanguage = langs;
      SyncDisabled = true;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      # keep-sorted end
    };
  };

  home-manager.users.talal = {
    home.packages = with pkgs; [
      (pkgs.brave.override {
        commandLineArgs = [
          "--enable-features=BraveCompactHorizontalTabs"
          # Reference: https://source.chromium.org/chromium/chromium/src/+/main:headless/app/headless_shell_switches.cc;drc=3556fbff47c18193f4a39d2496596e89b8307a15;l=47-55
          "--password-store=gnome-libsecret"
        ];
      })

      google-chrome
    ];

    programs.firefox = {
      enable = true;
      languagePacks = ["en-GB" "de" "ur"];
      profiles.default = {
        isDefault = true;
        extensions.force = true;
        settings = {
          # keep-sorted start
          "browser.newtab.url" = "about:blank";
          "browser.newtabpage.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.startup.page" = 3;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.uidensity" = 1;
          "findbar.highlightAll" = true;
          "layout.css.prefers-color-scheme.content-override" = 0; # always prefer dark theme
          "ui.key.menuAccessKeyFocuses" = false; # do not activate menu key when alt is pressed
          # keep-sorted end
        };
      };
    };
  };
}
