#!/usr/bin/env python3
"""Render the lab network diagram to a deterministic PNG."""

from PIL import Image, ImageDraw, ImageFont

W, H = 1600, 900
BG, PANEL, BLUE, CYAN = "#08111f", "#13253d", "#3b82f6", "#38bdf8"
WHITE, MUTED, GREEN = "#f8fafc", "#cbd5e1", "#22c55e"


def font(size: int, bold: bool = False):
    name = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    return ImageFont.truetype(name, size)


def center(draw, xy, text, fnt, fill=WHITE):
    box = draw.textbbox((0, 0), text, font=fnt)
    draw.text((xy[0] - (box[2] - box[0]) / 2, xy[1]), text, font=fnt, fill=fill)


def panel(draw, box, title, ip, lines):
    draw.rounded_rectangle(box, 18, fill=PANEL, outline=BLUE, width=3)
    cx = (box[0] + box[2]) // 2
    center(draw, (cx, box[1] + 30), title, font(27, True))
    center(draw, (cx, box[1] + 72), ip, font(18), CYAN)
    for i, line in enumerate(lines):
        draw.text((box[0] + 38, box[1] + 108 + i * 32), line, font=font(19), fill=MUTED)
    draw.ellipse((box[2] - 46, box[1] + 26, box[2] - 26, box[1] + 46), fill=GREEN)


image = Image.new("RGB", (W, H), BG)
draw = ImageDraw.Draw(image)
center(draw, (W // 2, 40), "Enterprise Network & Systems Administration Lab", font(42, True))
center(draw, (W // 2, 94), "Logical architecture • 192.168.10.0/24 • corp.example.test", font(20), MUTED)

panel(draw, (610, 140, 990, 245), "Internet / Upstream NAT", "WAN connectivity", [])
panel(draw, (560, 300, 1040, 465), "pfSense Firewall", "LAN 192.168.10.1/24", ["WAN: DHCP • NAT", "Routing • Firewall policy"])

draw.line((800, 245, 800, 300), fill=CYAN, width=6)
draw.polygon([(800, 300), (790, 284), (810, 284)], fill=CYAN)
draw.line((800, 465, 800, 535), fill=CYAN, width=6)
draw.line((230, 535, 1370, 535), fill=CYAN, width=6)
center(draw, (W // 2, 490), "LAB-LAN", font(18, True), CYAN)

for x in (330, 800, 1270):
    draw.line((x, 535, x, 590), fill=CYAN, width=6)
    draw.polygon([(x, 590), (x - 10, 574), (x + 10, 574)], fill=CYAN)

panel(draw, (120, 590, 540, 805), "DC01", "192.168.10.10", ["Windows Server 2022", "AD DS • DNS • DHCP", "Group Policy • Backups"])
panel(draw, (590, 590, 1010, 805), "WIN11-01", "DHCP: 192.168.10.100", ["Windows 11 Pro", "Domain workstation", "Wazuh agent • GPO managed"])
panel(draw, (1060, 590, 1480, 805), "WAZUH01", "192.168.10.20", ["Ubuntu Server", "Wazuh manager", "Grafana dashboards"])

center(draw, (W // 2, 850), "Centralized identity • Controlled access • Monitoring • Automated recovery", font(20), MUTED)
image.save("assets/diagrams/network-diagram.png", optimize=True)
