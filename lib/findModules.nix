lib: let
  inherit (builtins) readDir isPath;
  inherit (lib) hasSuffix removeSuffix mapAttrs' filterAttrs collect;

  /**
  Recursively find Nix modules in a directory. A module is either a `.nix` file (excluding `default.nix` and those prefixed with `_`) or a directory containing a `default.nix` file.

  # Arguments

  - [dir] The directory path to search for modules.

  # Type

  ```
  findModules :: Path -> AttrSet
  ```
  */
  findModules = dir:
    filterAttrs (_: v: v != {}) (
      mapAttrs' (name: type: let
        fullPath = dir + "/${name}";
        isNixModule = type == "regular" && hasSuffix ".nix" name && name != "default.nix" && !(lib.hasPrefix "_" name);
        isDir = type == "directory" && !(lib.hasPrefix "_" name);
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

  /**
  Return a list of all Nix modules found recursively in a directory.

  # Arguments

  - [dir] The directory path to search for modules.

  # Type

  ```
  findModulesList :: Path -> [Path]
  ```
  */
  findModulesList = dir: collect isPath (findModules dir);
in {
  inherit findModules findModulesList;
}
