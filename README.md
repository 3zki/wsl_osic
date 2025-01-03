# wsl_osic

SKY130&TinyTapeout for analog / GF180MCU / OpenRule1umPDK / ihp-sg13g2 / development tools for Ubuntu 22 (WSL2) and macOS

  1. Run `tool-install.sh`
```
git clone https://github.com/noritsuna/wsl_osic_4_mac
cd wsl_osic_4_mac
bash eda-setup.sh
```

  2. Restart your environment
  3. Choose the PDK you want to use...

## SKY130 and TinyTapeout by SKY130 for analog
  4. Run `bash pdk_sky130-setup.sh`
  5. Enjoy!

#### Frame for TinyTapeout by SKY130
* [Frame GDS file](TT/gds/tt_um_username_projectname.gds)

#### Uninstall or change the PDK
  6. If you want to change the PDK, run `bash uninstall.sh`
  7. Delete pip packages: `sky130` and `flayout`.
     pip-autoremove might be useful:
```
pip-auto remove sky130 flayout
```
  8. Now you can change the PDK

#### Differences between Standard PDK

Under construction...
* Fixed xschemrc
* Fixed Pcells to support the latest GDSFactory
* Added GDSFactory PCell Library
* Fixed DRC/LVS/PEX menu

## GF180MCU
  4. Run `bash pdk_gf180mcu-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `bash uninstall.sh`
  7. Delete pip packages: `gf180`.
     pip-autoremove might be useful:
```
pip-autoremove gf180
```
  8. Now you can change the PDK

#### Differences between Standard PDK

Under construction...

* Fixed xschemrc
* Changed color scheme table in GF180MCU technology files
* Added undefined but used layers such as Nwell_Label in mcu7t5v0 standard cells
  * Changed LVS rules to recognize Nwell_Label, LVPwell_Label and Pad_Label

* Fixed Pcells to support the latest GDSFactory

* Add DRC/LVS/PEX menu
  * Magic LVS cannot recognize V5_XTOR therefore menu replaces "05v0" with "06v0" in source netlist

## OpenRule1umPDK (PTS06)
  4. Run `bash pdk_or1pdk-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `bash uninstall.sh`
  7. Now you can change the PDK

#### Differences between Standard PDK

Under construction...

* Xschem Libraries

## ihp-sg13g2
  4. Run `bash pdk_ihp-sg13g2-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `bash uninstall.sh`

#### Differences between Standard PDK

Under construction...
