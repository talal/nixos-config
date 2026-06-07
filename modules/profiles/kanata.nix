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
               z x c v b n m , . /
          102d lalt      spc
        )

        (deflayer default
          caps
          @tabmeh _  _  _  _  _ _ _  @i _  _  _ _
          @escext @a @s @d @f _ _ @j @k @l @; _ _
                  _  _  _  _  _ _ _  _  _  _
          grv     @num       @sym
        )

        (deflayer extend
          _
          _  _    _    _    _    _  _    pgdn pgup _    _    _   _
          _  lmet lalt lsft lctl _  left down up   rght bspc del _
             _    _    _    _    _  _    _    home end  _
          _  _                   enter
        )

        (deflayer number
          _
          _  _ _ _ _ _ _ 7 8 9 _ _ _
          _  _ _ _ _ _ _ 4 5 6 _ _ _
             _ _ _ _ _ _ 1 2 3 _
          _  _        0
        )

        (deflayer symbols
          _
          _  @! @@   @#   @$ @%    @^  @&  @* _  _  _ _
          _  @{ lpar rpar @} @:    eql min @[ @] @+ _ _
             _  _    _    _  grv   @~  _   _  _  _
          _  _                   _
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
          num    (tap-hold-press $tt $ht lalt (layer-while-held number))
          sym    (tap-hold-release $tt $ht spc (layer-while-held symbols))

          ;; ══════════ Home Row Mods ══════════
          tabmeh (tap-hold-press $tt $ht tab (multi lctl lalt lsft))

          a (tap-hold-release $ht $ht a lmet)
          s (tap-hold-release $ht $ht s lalt)
          d (tap-hold-release $ht $ht d lsft)
          f (tap-hold-release $ht $ht f lctl)

          j (tap-hold-release $ht $ht j rctl)
          k (tap-hold-release $ht $ht k rsft)
          l (tap-hold-release $ht $ht l lalt)
          ; (tap-hold-release $ht $ht ; lmet)

          i (tap-hold-press $ht $ht i ralt)

          ;; ══════════ Symbol Aliases ══════════
          !  S-1
          @  S-2
          #  S-3
          $  S-4
          %  S-5
          ^  S-6
          &  S-7
          *  S-8
          _  S-min
          +  S-eql
          |  S-bksl
          ~  S-grv
          :  S-;
          [  [
          ]  ]
          {  S-[
          }  S-]
          <  S-,
          >  S-.
        )
      '';
    };
  };
}
