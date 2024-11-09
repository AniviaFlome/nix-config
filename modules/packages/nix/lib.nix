{ pkgs, ... }: {

  environment.variables.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
bzip2
glib
gtk3
openssl
libgcc
glibc
  ]);
}
