# EncryptOS

[![Maintenance](https://img.shields.io/maintenance/yes/2022.svg)]()


# Resources

- https://snaildos.com
- [Getting help at the forum](https://community.snaildos.com)
- [Bug report](https://community.snaildos.com/t/bug-reporting-guide/27)
- [Twitter news](https://twitter.com/SnailDOS)


### Development source

- [EncryptOS-ISO source](https://github.com/Encrypt-OS/EncryptOS-ISO) (Live environment with XFCE4-Desktop)
- [EncryptOS-ISO source](https://github.com/Encrypt-OS/EncryptOS-calamares) (installer framework)


### Base source

- [Arch-ISO](https://github.com/Encrypt-OS/EncryptOS-ISO)
- [Calamares](https://github.com/Encrypt-OS/EncryptOS-calamares)



# Boot options

Systemd-boot for UEFI systems

Bios-boot (syslinux) for legacy systems



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
sudo ./prepare.sh
```

##### 2. Build

~~~
sudo ./mkarchiso -v "."
~~~

or with log

~~~
sudo ./mkarchiso -v "." 2>&1 | tee "encryptosiso.log"
~~~

##### 3. The .iso appears in `out` directory


## Advanced

To install locally builded packages on ISO put the packages inside directory:

~~~
airootfs/root/packages
~~~

Packages will get installed and directory will be cleaned up after that.

## Versioning
`xx` - Release Candinate
Currently released candinates on mirror + WWW
```
01 - Margherita Pizza
```
