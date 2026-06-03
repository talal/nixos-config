lib: let
  inherit (builtins) readDir isPath;
  inherit (lib) hasSuffix removeSuffix mapAttrs' filterAttrs collect;

  findModules = dir:
    filterAttrs (_: v: v != {}) (
      mapAttrs' (name: type: let
        fullPath = dir + "/${name}";
        isNixModule = type == "regular" && hasSuffix ".nix" name && name != "default.nix";
        isDir = type == "directory";
        isDirModule = isDir && readDir fullPath ? "default.nix";
      in {
        name = removeSuffix ".nix" name;
        value =
          if isNixModule || isDirModule
          then fullPath
          else if isDir
          then findModules fullPath
          else {};
      }) (readDir dir)
    );

  findModulesList = dir: collect isPath (findModules dir);
in {
  inherit findModules findModulesList;
}
