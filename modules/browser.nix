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
        "cnjifjpddelmedmihgijeibhnjfabmlf" # Obsidian Web Clipper
        "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # Google Docs Offline
        "jabopobgcpjmedljpbcaablpmlmfcogm" # WhatFont
        # Ideally this should be defined in modules/catppuccin.nix and the list merged but
        # unfortunately the extraOpts is of type lib.types.attrs 😔
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

  environment.systemPackages = with pkgs; [
    (pkgs.brave.override {
      commandLineArgs = [
        "--enable-features=BraveCompactHorizontalTabs"
        # Reference: https://source.chromium.org/chromium/chromium/src/+/main:headless/app/headless_shell_switches.cc;drc=3556fbff47c18193f4a39d2496596e89b8307a15;l=47-55
        "--password-store=gnome-libsecret"
      ];
    })

    google-chrome
  ];

  home-manager.users.talal = {
    programs.firefox = {
      enable = true;
      languagePacks = ["en-GB" "de" "ur"];
      nativeMessagingHosts = with pkgs; [ff2mpv-rust];

      policies = {
        # keep-sorted start block=yes
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        Cookies = {
          Behavior = "reject-tracker-and-partition-foreign"; # Total Cookie Protection
          BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
          Locked = true;
        };
        DefaultDownloadDirectory = "\${home}/Downloads";
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Category = "strict";
        };
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        GenerativeAI = {
          Enabled = false;
          Locked = true;
        };
        HttpsOnlyMode = "force_enabled";
        NetworkPrediction = false;
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        Permissions = {
          Camera = {
            BlockNewRequests = true;
            Locked = true;
          };
          Microphone = {
            BlockNewRequests = true;
            Locked = true;
          };
          Location = {
            BlockNewRequests = true;
            Locked = false;
          };
          Notifications = {
            BlockNewRequests = true;
            Locked = false;
          };
        };
        SearchSuggestEnabled = false; # Stops live keystroke-sending to search engine
        UserMessaging = {
          FirefoxLabs = false;
          ExtensionRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };
        # keep-sorted end
      };

      profiles.default = {
        isDefault = true;

        # Hide native tabs, title bar, and sidebar header
        userChrome = ''
          #TabsToolbar {
              visibility: collapse;
          }
          #titlebar {
              visibility: collapse;
          }
          #sidebar-header {
              visibility: collapse !important;
          }
          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"]
              #sidebar-header {
              display: none;
          }
        '';

        extensions.force = true; # required when using settings
        settings = {
          # keep-sorted start
          "browser.newtab.url" = "about:blank";
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
