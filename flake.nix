{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.hydra.url = "github:NixOS/hydra";
  outputs = { self, nixpkgs, hydra }: {

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ hydra.nixosModules.hydraTest
	    ({ pkgs, ... }: {
            boot.isContainer = true;

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 3000 ];

            # Enable a web server.
            services.httpd = {
              enable = true;
              adminAddr = "samuel.rose@gmail.com";
            };
          })
        ];
    };

  };
}
