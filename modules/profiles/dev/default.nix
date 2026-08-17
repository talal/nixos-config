{
  findModulesList,
  config,
  ...
}: {
  imports = findModulesList ./.;

  environment.variables = {
    GOPATH = "/home/${config.user}/.go";
  };
}
