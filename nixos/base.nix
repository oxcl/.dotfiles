
{ config, lib, pkgs, inputs, ... }: {
  imports = [];

  boot = {
    # no efi simple grub boot with mbr partition table
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    # silent boot
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = ["quiet" "udev.log_level=3"];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    shell = pkgs.zsh;
   extraGroups = [ "wheel" "vboxsf" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  programs.zsh.enable = true;

  
  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "nixos";
  # networkManager provides the two very handy tools: nmcli and nmtui which can be used to quickly change network settings. as an alternative you can use
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default



  services = {
    xserver = {
      enable = true;
      windowManager.qtile.enable = true; # temporarily until i switch to xmonad or hyperland
      
      # keymap configuration in x11
      xkb = {
	layout = "us,ir(pes_keypad)";
	# switch keyboard layout with LeftAlt+LShift
	# the caps lock key is repurposed as a Hyper Modifier which is an additional modifier that is not available in normal keyboards. that can be used for keyboard shortcuts in programs like emacs
	options = "grp:lalt_lshift_toggle,caps:hyper";	
      };
    };
  };


  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # tty settings
  console = {
    font= "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  # packages that are listed here will be installed system wide.
  # most packages should be installed with home-manager
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    nano
    htop
    home-manager
  ];


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
