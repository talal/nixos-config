{
  hm = {
    programs.firefox = {
      enable = true;
      languagePacks = ["en-GB" "de" "ur"];
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
