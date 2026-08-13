{ lib, ... }: let
  inherit (lib)
    mkOption;
  inherit (lib.types)
    bool;
in {
  options = {

    enable_separate_authentication_policy_id = mkOption {
      description = ''
        The `enable_separate_authentication_policy_id` configuration
        parameter lets you enable access to Snowflake CLI separately from
        the drivers. When this access is enabled, specified users can
        access Snowflake CLI but not the other Snowflake drivers.

        **Warning:**
        If you already have an authentication policy that allows access
        only to drivers and don’t have one that allows access to Snowflake
        CLI only, enabling the `enable_separate_authentication_policy_id`
        parameter will cause the users to lose access to Snowflake CLI if
        you don’t create the new policy first. Make sure to add
        `SNOWFLAKE_CLI` to your authentication policy before enabling the
        configuration parameter.
      '';
      type    = bool;
      default = false;
    };

  };
}
