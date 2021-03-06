{ stdenv, fetchurl, gnome3, meson, ninja, pkgconfig, gtk3, intltool, glib
, udev, itstool, libxml2, wrapGAppsHook, libnotify, libcanberra-gtk3, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gnome-bluetooth-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-bluetooth/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1g3yrq5792qvc5rxnf26cgciawrca27hqn6wxfcf63bpa2dsjcsn";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-bluetooth"; attrPath = "gnome3.gnome-bluetooth"; };
  };

  nativeBuildInputs = [ meson ninja intltool itstool pkgconfig libxml2 wrapGAppsHook gobjectIntrospection ];
  buildInputs = [ glib gtk3 udev libnotify libcanberra-gtk3
                  gnome3.defaultIconTheme gnome3.gsettings-desktop-schemas ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en;
    description = "Application that let you manage Bluetooth in the GNOME destkop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
