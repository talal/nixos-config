{pkgs, ...}: let
  langs = ["en-GB-oxendict" "de-DE"];
  allowedExtensions = [
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
    "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
    "khncfooichmfjbepaaaebmommgaepoid" # Unhook
    "cnjifjpddelmedmihgijeibhnjfabmlf" # Obsidian Web Clipper
    "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # Google Docs Offline
    "jabopobgcpjmedljpbcaablpmlmfcogm" # WhatFont
    # Ideally, this should be defined in modules/catppuccin.nix and the list merged but
    # unfortunately programs.chromium.extraOpts is of type lib.types.attrs 😔
    "cmpdlhmnmjhihmcfnigoememnffkimlk" # Catppuccin Macchiato theme
  ];
in {
  programs.chromium = {
    enable = true;
    extraOpts = {
      # keep-sorted start prefix_order=Brave
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      BraveRewardsDisabled = true;
      BraveStatsPingEnabled = false;
      BraveTalkDisabled = true;
      BraveVPNDisabled = true;
      BraveWalletDisabled = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      AutoplayAllowed = false;
      BackgroundModeEnabled = true;
      BookmarkBarEnabled = false;
      BrowserLabsEnabled = false;
      BrowserSignin = 0;
      DefaultBrowserSettingEnabled = false;
      ExtensionInstallAllowlist = allowedExtensions;
      ExtensionInstallBlocklist = ["*"];
      FeedbackSurveysEnabled = false;
      ForcedLanguages = langs ++ ["ur"];
      HomepageIsNewTabPage = true;
      HttpsOnlyMode = "force_enabled";
      MediaRecommendationsEnabled = false;
      MetricsReportingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      PasswordManagerEnabled = false;
      PasswordManagerPasskeysEnabled = false;
      PasswordSharingEnabled = false;
      PrivacySandboxAdMeasurementEnabled = false;
      PrivacySandboxAdTopicsEnabled = false;
      PrivacySandboxFingerprintingProtectionEnabled = true;
      PrivacySandboxPromptEnabled = false;
      PrivacySandboxSiteEnabledAdsEnabled = false;
      PromotionsEnabled = false;
      RestoreOnStartup = 1; # restore last session
      SearchSuggestEnabled = false;
      ShoppingListEnabled = false;
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
}
