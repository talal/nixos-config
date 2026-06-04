{
  config,
  lib,
  ...
}: let
  cfg = config.services.kanata;
in {
  options.services.kanata.devices = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    example = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
    description = "Input devices to attach to services.kanata.keyboards.default.";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.devices != [];
        message = "services.kanata.devices must not be empty when services.kanata.enable = true.";
      }
    ];

    services.kanata.keyboards.default = {
      inherit (cfg) devices;
      extraDefCfg = ''
        process-unmapped-keys yes
        concurrent-tap-hold yes
      '';
      config = ''
        (defsrc
          esc
          tab  q w e r t y u i o p [ ]
          caps a s d f g h j k l ; ' \
                         n m , .
          102d         spc
        )


        (deflayer default
          caps
          @tabmeh _  _  _  _  _ _ _  @i _  _  _ _
          @escext @a @s @d @f _ _ @j @k @l @; _ _
                                _ _  _  _
          grv               @spcnum
        )

        (deflayer extend
          _
          _  _    _    _    _    _  _    pgdn pgup _    _    _   _
          _  lmet lalt lsft lctl _  left down up   rght bspc del _
                                    _    _    home end
          _                      enter
        )

        (deflayer number
          _
          _  S-1 S-2 S-3 S-4 S-5 S-6 S-7 S-8 S-9 S-0 S-- S-=
          _  1   2   3   4   5   6   7   8   9   0   -   =
                                 _   _   _   _
          _                    _
        )

        (defvar
          ;; Reference: https://github.com/jtroo/kanata/blob/main/docs/config.adoc#tap-hold
          ;; tap-repress-timeout
          tt 200
          ;; hold-timeout
          ht 200
        )

        (defalias
          ;; ══════════ Layers ══════════
          escext (tap-hold-press $tt $ht esc (layer-while-held extend))
          spcnum (tap-hold-press $tt $ht spc (layer-while-held number))

          ;; ══════════ Mod Keys ══════════
          ;; spchyp (tap-hold-press $tt $ht spc (multi lmet lctl lalt lsft))
          tabmeh (tap-hold-press $tt $ht tab (multi lctl lalt lsft))

          ;; Home Row Mod
          a (tap-hold $tt $ht a lmet)
          s (tap-hold $tt $ht s lalt)
          d (tap-hold $tt $ht d lsft)
          f (tap-hold $tt $ht f lctl)
          j (tap-hold $tt $ht j rctl)
          k (tap-hold $tt $ht k rsft)
          l (tap-hold $tt $ht l lalt)
          ; (tap-hold $tt $ht ; lmet)

          ;; i is not on home row but close enough...
          i (tap-hold $tt $ht i ralt)
        )
      '';
    };
  };
}
