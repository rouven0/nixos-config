{ ... }:
{
  programs = {
    aerc = {
      enable = true;
      extraConfig = {
        # general = {
        #   unsafe-accounts-conf = true;
        # };
        ui = {
          sort = "date";
          dirlist-tree = true;
          fuzzy-complete = true;
          styleset-name = "dracula";
          threading-enabled = true;
          icon-encrypted = "󰯄";
          icon-signed = "";
          icon-unknown = "";
          icon-attachment = "";
          icon-new = "";
          icon-old = "";
          icon-replied = "";
          icon-marked = "󰄳";
          icon-flagged = "";
          icon-deleted = "";
        };
        filters = {
          "text/plain" = "colorize";
          "text/html" = "html | colorize";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/calendar" = "calendar";
        };
      };

    };
  };
}
