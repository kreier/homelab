# Tuya Smartplug

The Tuya smartplug gets the internal IP 10.10.10.41 - right next to the server it is powering - my penta - at 10.10.10.40

You can actually access the current power data if you have the encryption key for the device and the right python library TinyTuya. More about it here: [https://github.com/jasonacox/tinytuya](https://github.com/jasonacox/tinytuya)

## Cycle power

The script is

``` py
import tinytuya

# Connect to Device
d = tinytuya.OutletDevice(
    dev_id='DEVICE_ID_HERE',
    address='IP_ADDRESS_HERE',      # Or set to 'Auto' to auto-discover IP address
    local_key='LOCAL_KEY_HERE', 
    version=3.3)

# Get Status
data = d.status() 
print('set_status() result %r' % data)

# Turn On
d.turn_on()

# Turn Off
d.turn_off()
```

## Read current power value

My Tuya Smart Plug operates on protocol 3.5 but I hope the requests from 3.3 still work. DPS - Data PointS - are questioned by

``` py
# Read Value of DPS 25
data = d.status()  
print("Value of DPS 25 is ", data['dps']['25'])

# Set Value of DPS 25
d.set_value(25, '010e0d0000000000000003e803e8')
```

So which one am I interested in?

| **DP ID** | **Function Point** | **Type** | **Range** | **Units** |
|:---------:|:------------------:|:--------:|:---------:|:---------:|
| 18        | Current            | integer  | 0-30000   | mA        |
| 19        | Power              | integer  | 0-50000   | W         |
| 20        | Voltage            | integer  | 0-5000    | V         |
