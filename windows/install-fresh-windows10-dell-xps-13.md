# Install Windows10 to Dell XPS 13 (9360)

- Laptop Model
  - XPS 13 9360
  - ram 16GB
  - QHD+ display with touch
  - 512GB SSD


## Create Windows boot USB

- Download Windows Image
  - [Dell Windows image donwload](http://www.dell.com/support/article/pw/en/pwbiz1/SLN299044/how-to-create-and-use-the-dell-windows-recovery-image?lang=EN)
  - [Dell Windows image donwload (KO)](http://www.dell.com/support/article/pw/en/pwbiz1/SLN299044/dell-windows-복구-이미지를-만들고-사용하는-방법?lang=KO)
- Make bootable USB
  - use DellOSRecoveryTool downloaded with the link above


## Install

### Boot with USB

fill this

### Partition manually

  - [UEFI/GPT partition layout](https://msdn.microsoft.com/ko-kr/library/windows/hardware/dn898510.aspx)
  - default EFI partition is too small(100MB), 500MB is recommended to install multiple OS
  - layout
    - EFI 500MB
    - MSR 16MB
    - Windows 120000M 
    - Recovery 500M
  - commands for **DiskPart**
    ```
    rem == CreatePartitions-UEFI.txt ==
    rem == These commands are used with DiskPart to
    rem    create four partitions
    rem    for a UEFI/GPT-based PC.
    rem    Adjust the partition sizes to fill the drive
    rem    as necessary. ==
    select disk 0
    clean
    convert gpt
    
    rem == 1. System partition =========================
    create partition efi size=500
    rem    ** NOTE: For Advanced Format 4Kn drives,
    rem               change this value to size = 260 **
    format quick fs=fat32 label="System"
    assign letter="S"
    
    rem == 2. Microsoft Reserved (MSR) partition =======
    create partition msr size=16
    
    rem == 3. Windows partition ========================
    rem ==    a. Create the Windows partition ==========
    create partition primary size=120000
    rem ==    b. Prepare the Windows partition =========
    format quick fs=ntfs label="Windows"
    assign letter="W"
    
    rem === 4. Recovery tools partition ================
    create partition primary size=500
    format quick fs=ntfs label="Recovery tools"
    assign letter="R"
    set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
    gpt attributes=0x8000000000000001
    list volume
    exit
    ```

### Install Windows
