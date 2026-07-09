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
          lsft z x c v b n m , . /
          102d lalt      spc     ralt
        )

        (deflayer default
          caps
          @tabmeh _  _  _  _  _   _ _  @i _  _  _ _
          @escext @a @s @d @f _   _ @j @k @l @; _ _
          _       _  _  _  _  _   _ _  _  _  _
          nop0    @sym          _            @sym
        )

        (deflayer extend
          _
          _  _    _    _    _    _   _    pgdn pgup bspc _   _ _
          _  lmet lalt lsft lctl _   left down up   rght del _ _
          _  _    _    _    _    _   _    _    home end  _
          _  _                   enter                   _
        )

        (deflayer symbol
          _
          _  @! @@   @# @$  @%   @^  @& @* @+   _   _ _
          _  @_ lpar [  @{  @:   eql @} ]  rpar min _ _
          _  _  _    @~ grv _    _   _  _  _    _
          _  _                 _                _
        )

        (defvar
          ;; Reference: https://github.com/jtroo/kanata/blob/main/docs/config.adoc#tap-hold
          ;; Hold timeout: Reduced slightly to 175ms for snappier typing.
          ;; If you get accidental modifiers when typing fast, increase to 200.
          tt 200
          ht 200
        )

        (defalias
          ;; ══════════ Layers ══════════
          escext (tap-hold-press $tt $ht esc (layer-while-held extend))
          tabmeh (tap-hold-press $tt $ht tab (multi lctl lalt lsft))
          sym (layer-while-held symbol)

          ;; ══════════ Home Row Mods ══════════
          a (tap-hold-release $tt $ht a lmet)
          s (tap-hold-release $tt $ht s lalt)
          d (tap-hold-release $tt $ht d lsft)
          f (tap-hold-release $tt $ht f lctl)

          j (tap-hold-release $tt $ht j rctl)
          k (tap-hold-release $tt $ht k rsft)
          l (tap-hold-release $tt $ht l lalt)
          ; (tap-hold-release $tt $ht ; rmet)

          i (tap-hold-release $tt $ht i ralt)

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

          dq S-apo
          |  S-bksl
          ~  S-grv
          :  S-;

          {  S-[
          }  S-]
          <  S-,
          >  S-.
        )
      '';
    };
  };
}
