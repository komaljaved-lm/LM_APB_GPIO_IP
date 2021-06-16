# GPIO
AMBA APB Compliant GPIO. Our design contains 32 configurable GPIO pins. 

# Features
* GPIOs IP follows AMBA APB protocol
* 32 GPIO pins that can be configured as input/output
* Two operating modes− push-pull and open-drain
* Separate input and output registers
* Input register reflect the data on GPIOs
* Output register writes data on GPIOs
* Direction register sets the direction of GPIO as input/output
* Set and Clear registers to drive GPIOs additionally
* Mode register for selection of mode

# Directory Structure
```bash
├── docs
│   ├── GPIO_doc.pdf
├── rtl
│   ├── GPIO_module.sv
│   ├── apb_slave_module.sv
│   ├── defines.h
│   └── top.sv
└── tb
    ├── TB_1.sv
    ├── TB_2.sv
    └── gpio_tb.sv
    
```
# Compatibility
This IP is compatible with Modelsim.
check5


