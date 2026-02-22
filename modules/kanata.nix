{
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
      extraDefCfg = ''
        process-unmapped-keys yes
        concurrent-tap-hold yes
      '';
      config = ''
        (defsrc
          esc
          tab            u i
          caps a s d f h j k l ;
                       n m , .
                     spc
        )

        (deflayer default
          caps
          @tabmeh                  _  @i
          @escext @a @s @d @f _ @j @k @l @;
                              _ _  _  _
                          @spchyp
        )

        (deflayer extend
          _
          _                           pgdn pgup
          _  lmet lalt lsft lctl left down up   rght _
                                 _    _    home end
          _
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

          ;; ══════════ Mod Keys ══════════
          spchyp (tap-hold-press $tt $ht spc (multi lmet lctl lalt lsft))
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
