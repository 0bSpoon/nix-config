{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt;

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          age
          nil
          nixfmt
          sops
        ];
      };
    };
}
