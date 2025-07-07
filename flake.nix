{
  description = "Ceng development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.glfw # Going to need it in the future
            (pkgs.sbcl.withPackages (ps:
              with ps; [
                alexandria # for common functions
                local-time # for time
                bt-semaphore # for threads
                usocket # for tcp/ip
                ironclad # for encryption
                cl-gtk4
              ]))
            pkgs.asdf-vm # for package management but its redundant
          ];

          # Not needed for now
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            #
          ];

          shellHook = ''
            PS1="[\\u@\\h && CENG-DEV-ENV:\\w]\$ "
          '';
        };
      });
}
