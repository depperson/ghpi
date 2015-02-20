#!/usr/bin/env python

# The MIT License (MIT)
#
# Copyright (c) 2015 Richard Hull
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from PIL import Image, ImageFont, ImageDraw
import smbus

class canvas(object):
    """
    A canvas returns a properly-sized `ImageDraw` object onto which the caller
    can draw upon. As soon as the with-block completes, the resultant image is
    flushed onto the device.
    """
    def __init__(self, device):
        self.draw = None
        self.image = Image.new('1', (device.width, device.height))
        self.device = device

    def __enter__(self):
        self.draw = ImageDraw.Draw(self.image)
        return self.draw

    def __exit__(self, type, value, traceback):
        if type is None:
            # do the drawing onto the device
            self.device.display(self.image)

        del self.draw   # Tidy up the resources
        return False    # Never suppress exceptions


class device(object):
    """
    Base class for OLED driver classes
    """

    def __init__(self, port=1, address=0x3C, cmd_mode=0x00, data_mode=0x40):
        self.cmd_mode = cmd_mode
        self.data_mode = data_mode
        self.bus = smbus.SMBus(port)
        self.addr = address

    def command(self, *cmd):
        """
        Sends a command or sequence of commands through to the
        device - maximum allowed is 32 bytes in one go.
        """
        assert(len(cmd) <= 32)
        self.bus.write_i2c_block_data(self.addr, self.cmd_mode, list(cmd))

    def data(self, *data):
        """
        Sends a data byte or sequence of data bytes through to the
        device - maximum allowed in one transaction is 32 bytes, so if
        data is larger than this it is sent in chunks.
        """
        for i in xrange(0, len(data), 32):
            self.bus.write_i2c_block_data(self.addr,
                                          self.data_mode,
                                          list(data[i:i+32]))


class sh1106(device):
    """
    A device encapsulates the I2C connection (address/port) to the SH1106
    OLED display hardware. The init method pumps commands to the display
    to properly initialize it. Further control commands can then be
    called to affect the brightness. Direct use of the command() and
    data() methods are discouraged.
    """

    def __init__(self, port=1, address=0x3C):
        super(sh1106, self).__init__(port, address)
        self.width = 128
        self.height = 64
        self.pages = self.height / 8

        self.command(
            const.DISPLAYOFF,
            const.MEMORYMODE,
            const.SETHIGHCOLUMN,      0xB0, 0xC8,
            const.SETLOWCOLUMN,       0x10, 0x40,
            const.SETCONTRAST,        0x7F,
            const.SETSEGMENTREMAP,
            const.NORMALDISPLAY,
            const.SETMULTIPLEX,       0x3F,
            const.DISPLAYALLON_RESUME,
            const.SETDISPLAYOFFSET,   0x00,
            const.SETDISPLAYCLOCKDIV, 0xF0,
            const.SETPRECHARGE,       0x22,
            const.SETCOMPINS,         0x12,
            const.SETVCOMDETECT,      0x20,
            const.CHARGEPUMP,         0x14,
            const.DISPLAYON)

    def display(self, image):
        """
        Takes a 1-bit image and dumps it to the SH1106 OLED display.
        """
        assert(image.mode == '1')
        assert(image.size[0] == self.width)
        assert(image.size[1] == self.height)

        pix = image.load()
        page = 0xB0
        for y in xrange(0, self.pages * 8, 8):

            # move to given page, then reset the column address
            self.command(page, 0x02, 0x10)
            page += 1

            buf = []
            for x in xrange(self.width):
                buf.append(
                    pix[(x, y + 0)] & 0x01 |
                    pix[(x, y + 1)] & 0x02 |
                    pix[(x, y + 2)] & 0x04 |
                    pix[(x, y + 3)] & 0x08 |
                    pix[(x, y + 4)] & 0x10 |
                    pix[(x, y + 5)] & 0x20 |
                    pix[(x, y + 6)] & 0x40 |
                    pix[(x, y + 7)] & 0x80)

            self.data(*buf)


class ssd1306(device):
    """
    A device encapsulates the I2C connection (address/port) to the SSD1306
    OLED display hardware. The init method pumps commands to the display
    to properly initialize it. Further control commands can then be
    called to affect the brightness. Direct use of the command() and
    data() methods are discouraged.
    """
    def __init__(self, port=1, address=0x3C):
        super(ssd1306, self).__init__(port, address)
        self.width = 128
        self.height = 64
        self.pages = self.height / 8

        self.command(
            const.DISPLAYOFF,
            const.SETDISPLAYCLOCKDIV, 0x80,
            const.SETMULTIPLEX,       0x3F,
            const.SETDISPLAYOFFSET,   0x00,
            const.SETSTARTLINE,
            const.CHARGEPUMP,         0x14,
            const.MEMORYMODE,         0x00,
            const.SEGREMAP,
            const.COMSCANDEC,
            const.SETCOMPINS,         0x12,
            const.SETCONTRAST,        0xCF,
            const.SETPRECHARGE,       0xF1,
            const.SETVCOMDETECT,      0x40,
            const.DISPLAYALLON_RESUME,
            const.NORMALDISPLAY,
            const.DISPLAYON)

    def display(self, image):
        """
        Takes a 1-bit image and dumps it to the SSD1306 OLED display.
        """
        assert(image.mode == '1')
        assert(image.size[0] == self.width)
        assert(image.size[1] == self.height)

        self.command(
            const.COLUMNADDR, 0x00, self.width-1,  # Column start/end address
            const.PAGEADDR,   0x00, self.pages-1)  # Page start/end address

        pix = image.load()
        for y in xrange(0, self.pages * 8, 8):
            x = self.width-1
            buf = []
            while x >= 0:
                buf.append(
                    pix[(x, y + 0)] & 0x01 |
                    pix[(x, y + 1)] & 0x02 |
                    pix[(x, y + 2)] & 0x04 |
                    pix[(x, y + 3)] & 0x08 |
                    pix[(x, y + 4)] & 0x10 |
                    pix[(x, y + 5)] & 0x20 |
                    pix[(x, y + 6)] & 0x40 |
                    pix[(x, y + 7)] & 0x80)

                x -= 1

            self.data(*buf)


class const:
    CHARGEPUMP = 0x8D
    COLUMNADDR = 0x21
    COMSCANDEC = 0xC8
    COMSCANINC = 0xC0
    DISPLAYALLON = 0xA5
    DISPLAYALLON_RESUME = 0xA4
    DISPLAYOFF = 0xAE
    DISPLAYON = 0xAF
    EXTERNALVCC = 0x1
    INVERTDISPLAY = 0xA7
    MEMORYMODE = 0x20
    NORMALDISPLAY = 0xA6
    PAGEADDR = 0x22
    SEGREMAP = 0xA0
    SETCOMPINS = 0xDA
    SETCONTRAST = 0x81
    SETDISPLAYCLOCKDIV = 0xD5
    SETDISPLAYOFFSET = 0xD3
    SETHIGHCOLUMN = 0x10
    SETLOWCOLUMN = 0x00
    SETMULTIPLEX = 0xA8
    SETPRECHARGE = 0xD9
    SETSEGMENTREMAP = 0xA1
    SETSTARTLINE = 0x40
    SETVCOMDETECT = 0xDB
    SWITCHCAPVCC = 0x2


#
# The remainder is by Daniel Epperson, still released under MIT license.
#

import rrdtool
info = rrdtool.info('/opt/ghpi/rrd/temps-28-00043ebcf0ff.rrd')
last = info['last_update']
temp = info['ds[t].last_ds']
#print info
#print last
#print temp

device = sh1106(port=1, address=0x3C)  
with canvas(device) as draw:
    bigfont = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeMono.ttf', 40)
    smfont = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeMono.ttf', 16)
    draw.text((0, 0), "desk 1234", font=smfont, fill=255)
    draw.text((0,16), temp, font=bigfont, fill=255)

