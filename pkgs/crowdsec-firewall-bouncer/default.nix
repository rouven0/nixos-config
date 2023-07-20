{ lib, buildGoModule, makeWrapper, fetchFromGitHub, playerctl }:
buildGoModule rec {
  pname = "crowdsec-firewall-bouncer";
  version = "0.0.27";

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = "cs-firewall-bouncer";
    rev = "v${version}";
    hash = "sha256-zrYs/9hH+sGG1RMFWMeTm1yIDPElGBr7rVGeWR3ff34=";
  };

  patches = [ ./0001-remove-natend-go-mod-for-nix-builds.patch ];

  vendorSha256 = "sha256-7wIdwTv4jMpFQkl3tKeH3MWxJ/EbiFg5FtGSAvNNpos=";

  meta = with lib; {
    description = "Crowdsec bouncer written in golang for firewalls";
    homepage = "https://github.com/crowdsecurity/cs-firewall-bouncer";
    license = licenses.mit;
    maintainers = with maintainers; [ therealr5 ];
    platforms = platforms.all;
  };
}
