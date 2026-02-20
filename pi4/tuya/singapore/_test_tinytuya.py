import tinytuya

print("TinyTuya Version:", tinytuya.__version__)
print("Trying to connect to device...")
d = tinytuya.OutletDevice(
    dev_id="a3a19d7cb976b72be09wdt",
    address="10.10.10.41",
    local_key="XWZSCLPbbR^2Tvs1"
)

d.set_version(3.5)

data = d.status()
print(data)
