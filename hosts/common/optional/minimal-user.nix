{ config, ... }:
{
  # Set a temp password for use by minimal builds like installer and iso
  users.users.${config.hostSpec.username} = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$ahay7YhspGfrXh9VtOUW//$l3wjXEOZwxoh6VPbA6/Tuph8uXiXJU5Ezl.CapztZ95";
    extraGroups = [ "wheel" ];
  };
}
