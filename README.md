# EncryptOS

[![Maintenance](https://img.shields.io/maintenance/yes/2022.svg)]()


This ISO is based on hugely modified Arch-ISO to provide Installation Environment for EncryptOS.
## Resources:

- https://encryptos.snaildos.com
- [Getting help at the forum](https://community.snaildos.com)
- [Bug report](https://community.snaildos.com/t/bug-reporting-guide/27)
- [Discord Chat](https://invite.gg/snaildos)
- [Twitter news](https://twitter.com/SnailDOS)


### Development source

- [EncryptOS-ISO source](https://github.com/Encrypt-OS/EncryptOS-ISO) (Live environment with XFCE4-Desktop)
- [EncryptOS-calamares](https://github.com/EncryptOS-OS/EncryptOS-calamares) (installer framework)


### Base source

- [Arch-ISO](https://gitlab.archlinux.org/archlinux/archiso)
- [Calamares](https://github.com/calamares/calamares)


# How to build ISO

You need to use an installed EncryptOS system or any archbased system with EncryptOS [repository](https://github.com/Encrypt-OS/mirrors) enabled.

As the installer packages and needed dependencies will get installed from EncryptOS repository.

### Install build dependencies

```
sudo pacman -S archiso mkinitcpio-archiso git squashfs-tools --needed
```

### Build

##### 1. Prepare

```
git clone https://github.com/Encrypt-OS/EncryptOS-ISO.git
cd "EncryptOS-ISO"
./prepare.sh
```

##### 2. Build

~~~
sudo ./mkarchiso -v "."
~~~

or with log

~~~
sudo ./mkarchiso -v "." 2>&1 | tee "eosiso_$(date -u +'%Y.%m.%d-%H:%M').log"
~~~

##### 3. The .iso appears in `out` directory


## Advanced

To install locally builded packages on ISO put the packages inside directory:

~~~
airootfs/root/packages
~~~

Packages will get installed and directory will be cleaned up after that.
