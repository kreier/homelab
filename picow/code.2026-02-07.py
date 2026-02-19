import time
import wifi
import socketpool
import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode

WIFI_SSID = "NAMEIT🐌"
WIFI_PASSWORD = "FILLOUT"
PORT = 80

keyboard = Keyboard(usb_hid.devices)

def wake_pc():
    keyboard.press(Keycode.LEFT_SHIFT)
    time.sleep(0.2)
    keyboard.release_all()

wifi.radio.connect(WIFI_SSID, WIFI_PASSWORD)
print("IP:", wifi.radio.ipv4_address)

pool = socketpool.SocketPool(wifi.radio)
server = pool.socket(pool.AF_INET, pool.SOCK_STREAM)
server.bind(("0.0.0.0", PORT))
server.listen(1)

print("Ready")

while True:
    conn, addr = server.accept()
    try:
        buf = bytearray(1024)
        n = conn.recv_into(buf)
        if n == 0:
            raise RuntimeError("No data")
        data = buf[:n]
        if not data:
            raise RuntimeError("No data")
        line = data.decode("utf-8", "ignore").splitlines()[0]
        print(line)
        if "GET /wake" in line:
            wake_pc()
            body = "OK\n"
            status = "200 OK"
        else:
            body = "Use /wake\n"
            status = "404 Not Found"

        response = (
            f"HTTP/1.1 {status}\r\n"
            "Content-Type: text/plain\r\n"
            f"Content-Length: {len(body)}\r\n"
            "Connection: close\r\n"
            "\r\n"
            + body
        )

        conn.send(response.encode("utf-8"))
        time.sleep(0.1)

    except Exception as e:
        print("Error:", e)

    finally:
        conn.close()
