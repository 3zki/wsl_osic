# wsl_osic

SKY130 / GF180MCU / OpenRule1umPDK / IP62 development tools for Ubuntu 22/24 (WSL2)

# Digital flow (OpenROAD)
  1. Run `openroad-install.sh`
```
git clone https://github.com/3zki/wsl_osic
cd wsl_osic
./openroad-option.sh
```
  2. Restart your environment
  3. Get `OpenROAD-flow-scripts`
```
git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
```
  4. Tool installation is already done. now you can check...
```
cd OpenROAD-flow-scripts
cd flow
make
make gui_final
```

See OpenROAD-flow-scripts documents for more details.

# Analog Tools
  1. Run `tool-install.sh`
```
git clone https://github.com/3zki/wsl_osic
cd wsl_osic
./tool-install.sh
```

  2. Restart your environment
  3. Choose the PDK you want to use...

## SKY130
  4. Run `sky130-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `uninstall.sh`
  7. Delete pip packages: `sky130` and `flayout`.
     pip-autoremove might be useful:
```
pip-autoremove sky130 flayout
```
  8. Now you can change the PDK

#### Differences between Standard PDK

Under construction...
* Modify xschemrc
* Modify LVS rules
* Add GDSFactory PCell Library
* Add DRC/LVS/PEX menu

## GF180MCU
  4. Run `gf180mcu-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `uninstall.sh`
  7. Delete pip packages: `gf180`.
     pip-autoremove might be useful:
```
pip-autoremove gf180
```
  8. Now you can change the PDK

#### Differences between Standard PDK

Under construction...

* Modify xschemrc
* Change color scheme table in GF180MCU technology files
* Add undefined but used layers such as Nwell_Label in mcu7t5v0 standard cells
  * Change LVS rules to recognize Nwell_Label, LVPwell_Label

* Modify Pcells to support the latest GDSFactory

* Add DRC/LVS/PEX menu
  * Magic LVS cannot recognize V5_XTOR therefore menu replaces "05v0" with "06v0" in source netlist

## OpenRule1umPDK
  4. Run `or1pdk-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `uninstall.sh`
  7. Now you can change the PDK

#### Differences between Standard PDK

Under construction...

* Xschem Libraries

## IP62 (Tokai Rika)
  4. Run `ip62-setup.sh`
  5. Enjoy!
#### Uninstall or change the PDK
  6. If you want to change the PDK, run `uninstall.sh`
  7. Now you can change the PDK

#### Differences between Standard PDK

* Add "ip62_models.sym" in the models folder so you don't have to type the path to the Spice models!
