pkgname=rp-audio-git
pkgver=r0
pkgrel=1
pkgdesc="One audio output at a time, the same volume on every sink"
arch=(any)
url="https://github.com/roman-petruzela/rp-audio"
license=(MIT)
depends=(bash jq libpulse pipewire wireplumber)
makedepends=(git)
provides=(rp-audio)
conflicts=(rp-audio)
source=("git+$url.git")
sha256sums=(SKIP)

pkgver() {
    cd rp-audio
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
    cd rp-audio
    install -Dm755 bin/rp-audio "$pkgdir/usr/bin/rp-audio"
    install -Dm644 systemd/rp-audio.service "$pkgdir/usr/lib/systemd/user/rp-audio.service"
    sed -i 's|^ExecStart=.*/rp-audio |ExecStart=/usr/bin/rp-audio |' "$pkgdir/usr/lib/systemd/user/rp-audio.service"
    install -Dm644 wireplumber.conf.d/51-rp-audio.conf "$pkgdir/usr/share/wireplumber/wireplumber.conf.d/51-rp-audio.conf"
    install -Dm644 config/rp-audio.conf "$pkgdir/usr/share/doc/rp-audio/rp-audio.conf"
    install -Dm644 config/blacklist.conf "$pkgdir/usr/share/doc/rp-audio/blacklist.conf"
    install -Dm644 README.md "$pkgdir/usr/share/doc/rp-audio/README.md"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
