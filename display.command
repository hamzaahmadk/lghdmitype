#!/usr/bin/env python3

#CHANGE THESE SETTINGS#
IP = '192.168.68.115'
Input = 'HDMI_1'
Input_Mode = 'pc'
Input_Name = 'MacBook Pro'

#DON'T CHANGE BELOW CODE#

import subprocess
import plistlib
import time
import asyncio
from bscpylgtv import WebOsClient

time.sleep

def get_display_name():
    cmd = ["system_profiler", "SPDisplaysDataType", "-xml"]
    output = subprocess.check_output(cmd)

    # Parse the plist XML output
    plist = plistlib.loads(output)
    
    # Extract the model number of the primary display
    display_name_new = plist[0]['_items'][0]['spdisplays_ndrvs'][0]['_name']
    return(display_name_new)

async def change_display_settings():
    client = await WebOsClient.create(IP, states=[])
    await client.connect()

    await client.set_device_info(Input, Input_Mode, Input_Name)

    await client.disconnect()


display_name_old = None

while True:
    try: # This try/except function allows the script to continue even when you are not connected to the same network as the TV - e.g. when booting up and wifi hasn't yet connected or when you are away from your TV.
        display_name_new = get_display_name()
        if display_name_new[0:2] == 'LG':
            if display_name_new != display_name_old:
                asyncio.run(change_display_settings())
        display_name_old = display_name_new
        time.sleep(5)
    except:
        time.sleep(5)
        continue