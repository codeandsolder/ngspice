# ngspice 47 independent CI reference (Debian 13, x86-64)

This packaging tag is distinct from the tracked upstream fork. The attached
`ngspice-47-source.tar.gz` is the exact upstream release archive, not a build
of this tag's source tree. Its SHA-512 is pinned in `build.sh` and matches the
independently published Arch source checksum. The only patch restarts the
XSPICE interface-description scanner when switching input files, allowing
current Flex to generate every module; it changes no device equations.

The shipped simulator was built with GCC 14.2.0 (Debian 14.2.0-19), glibc
2.41-12+deb13u5, managed sccache C/C++ wrappers, KLU, XSPICE, CIDER and OpenMP.
X11 and readline are disabled. The ELF executable's greatest GLIBC version
requirement is 2.38. The staged tree includes the original initialization
script, code models, help and upstream COPYING. Installers must relocate
`/opt/ngspice-47/lib/ngspice` in `spinit` and set `SPICE_LIB_DIR` and script/help
paths before launching. No host libraries are bundled.

The build image was derived from managed Debian runtime image ID
`sha256:1909de9400f3e40aa2396b20b313eca4080b6184437fb08fb84d85678f4f571b`
using the three tools and versions in Dockerfile. Exact build image ID:
`sha256:e970b90a372a510ad54458649de15180c8c94bbbd9bb7690d3501c0efd968101`.
The build script verifies that image ID, downloads and verifies source, applies
only the recorded patch, and runs all compiler calls through the existing
managed runtime. The checksum in SHA256SUMS identifies the published build,
not a claim that upstream timestamp-bearing binaries are bit-reproducible.

Acceptance: the unchanged managed Debian runtime resolves all executable
libraries, reports ngspice 47 with KLU, and executes an independent analog
XSPICE gain test (1 V input, gain 2, output exactly 2 V).
