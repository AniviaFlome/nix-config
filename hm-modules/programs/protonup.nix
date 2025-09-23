{ pkgs, lib, ... }:

{
 home.activation.protonup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
   ${lib.getExe pkgs.protonup-ng} -y || true
 '';
}
