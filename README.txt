To use this overlay you first need to configure layman. Once
you have done this, copy the included overlay.xml file over
to /etc/layman/overlays/ogelpre.xml so that layman knows about
this overlay.

After this you can active the "ogelpre" repository using
 $ layman -a ogelpre

Then you can update the repository using
 $ layman -s ogelpre

Have fun!
