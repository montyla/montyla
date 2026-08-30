#!/usr/bin/env python3
"""Apply Brazilian Portuguese (pt-BR) defaults onto a rAthena tree.

- Converts the official map_msg_por.conf pack from ISO-8859-1 to UTF-8 and
  installs it as the default (English slot) language, so job names, @commands
  and system messages are Portuguese without @langtype.
- Translates the custom Warper menus and labels.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path


def load_portuguese_messages(por_path: Path) -> str:
    raw = por_path.read_bytes()
    try:
        text = raw.decode("utf-8")
        if "Aprendiz" in text:
            return text
    except UnicodeDecodeError:
        pass
    return raw.decode("iso-8859-1")


def install_default_messages(rathena: Path) -> None:
    msg_dir = rathena / "conf" / "msg_conf"
    por_path = msg_dir / "map_msg_por.conf"
    if not por_path.is_file():
        raise SystemExit(f"Portuguese message pack not found: {por_path}")

    text = load_portuguese_messages(por_path)
    text = text.replace(
        "import: conf/msg_conf/import/map_msg_por_conf.txt",
        "import: conf/msg_conf/import/map_msg_eng_conf.txt",
        1,
    )
    utf8 = text.encode("utf-8")
    (msg_dir / "map_msg.conf").write_bytes(utf8)
    # Keep @langtype por on the same UTF-8 pack (restore its own import).
    por_text = load_portuguese_messages(por_path)
    if "import: conf/msg_conf/import/map_msg_por_conf.txt" not in por_text:
        por_text = por_text.replace(
            "import: conf/msg_conf/import/map_msg_eng_conf.txt",
            "import: conf/msg_conf/import/map_msg_por_conf.txt",
            1,
        )
    por_path.write_bytes(por_text.encode("utf-8"))


WARPER_PLAIN = [
    ('"Last Warp ^777777["', '"Último destino ^777777["'),
    ('" ~ Towns"', '" ~ Cidades"'),
    ('" ~ Fields"', '" ~ Campos"'),
    ('" ~ Dungeons"', '" ~ Masmorras"'),
    ('" ~ Guild Castles"', '" ~ Castelos de Clã"'),
    ('" ~ Guild Dungeons"', '" ~ Masmorras de Clã"'),
    ('" ~ Instances"', '" ~ Instâncias"'),
    ('" ~ Special Areas"', '" ~ Áreas Especiais"'),
    ("You haven't warped anywhere yet.", "Você ainda não usou o teleporte."),
    ("This map is not enabled in ", "Este mapa não está disponível no modo "),
    ('+"Pre-")+"Renewal."', '+"Pré-")+"Renewal."'),
    ('"Anthell"', '"Formigueiro"'),
    ('"Clock Tower"', '"Torre do Relógio"'),
    ('"Culvert"', '"Esgotos"'),
    ('"Pyramids"', '"Pirâmides"'),
    ('"Bio Labs"', '"Biolaboratório"'),
    ('"Abyss Lakes"', '"Lagos do Abismo"'),
    ('"Sunken Ship"', '"Navio Afundado"'),
    ('"Toy Factory"', '"Fábrica de Brinquedos"'),
    ('"Coal Mines"', '"Minas de Carvão"'),
    ('"Sphinx"', '"Esfinge"'),
    ('"Orc Dungeon"', '"Caverna dos Orcs"'),
    ('"Payon Dungeon"', '"Caverna de Payon"'),
    ('"Turtle Dungeon"', '"Ilha da Tartaruga"'),
    ('"Ice Dungeon"', '"Caverna de Gelo"'),
    ('"Hidden Dungeon"', '"Labirinto"'),
    ('"Beach Dungeon"', '"Masmorra da Praia"'),
    ('"Thor Volcano"', '"Vulcão de Thor"'),
    ('"Thanatos Tower"', '"Torre de Thanatos"'),
    ('"Odin Temple"', '"Templo de Odin"'),
    ('"Rachel Sanctuary"', '"Santuário de Rachel"'),
    ('"Auction Hall"', '"Casa de Leilão"'),
    ('"Battlegrounds"', '"Batalha Campal"'),
    ('"Dimensional Rift"', '"Fenda Dimensional"'),
    ('"Eden Group Headquarters"', '"Sede do Grupo Eden"'),
    ('"Monster Race Arena"', '"Corrida de Monstros"'),
    ('"Guild Castles"', '"Castelos de Clã"'),
    ('"Nameless Island (Day)"', '"Ilha Sem Nome (Dia)"'),
    ('"Nameless Island (Night)"', '"Ilha Sem Nome (Noite)"'),
    ('"Midgarts Expedition Camp"', '"Acampamento de Midgarts"'),
    ('"Special Security Area, Cor"', '"Área de Segurança, Cor"'),
    ('"Grey Wolf Forest"', '"Floresta do Lobo Cinzento"'),
    ('"Frozen Scale Fields"', '"Campos da Escama Congelada"'),
    ('"Hall of Abyss"', '"Salão do Abismo"'),
    ('"Ancient Shrine Maze"', '"Labirinto do Santuário Antigo"'),
    ('"Inside Ancient Shrine"', '"Interior do Santuário Antigo"'),
    ('"Basement 1"', '"Subsolo 1"'),
    ('"Basement 2"', '"Subsolo 2"'),
    ('"Basement 3"', '"Subsolo 3"'),
    ('"Basement 4"', '"Subsolo 4"'),
    ('"Basement 1 - Nightmare Mode"', '"Subsolo 1 - Pesadelo"'),
    ('"Basement 2 - Nightmare Mode"', '"Subsolo 2 - Pesadelo"'),
    ('"Nidhogg\'s Dungeon"', '"Masmorra de Nidhogg"'),
    ('"Varmundt\'s Dungeon"', '"Masmorra de Varmundt"'),
    ('"Varmundt\'s Mansion"', '"Mansão de Varmundt"'),
    ('"Oz Labyrinth Dungeon"', '"Labirinto de Oz"'),
    ('"Illusion Dungeon"', '"Masmorras Illusion"'),
    ('"Issgard Dungeon"', '"Masmorra de Issgard"'),
    ('"Rock Ridge Dungeon"', '"Masmorra de Rock Ridge"'),
    ('"Rudus Dungeon"', '"Masmorra de Rudus"'),
    ('"Warper >"', '"Teleporte >"'),
    ("Warper >", "Teleporte >"),
    ("\tduplicate(Warper)\tWarper#", "\tduplicate(Warper)\tTeleporte#"),
]


def localize_warper(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if "Último destino" in text:
        return
    for old, new in WARPER_PLAIN:
        text = text.replace(old, new)
    # Generic "Name Field(s)" / "Name Dungeon" labels (quoted menus and Disp()).
    text = re.sub(r'"([^"]+) Fields"', r'"Campos de \1"', text)
    text = re.sub(r'"([^"]+) Field"', r'"Campo de \1"', text)
    text = re.sub(r'"([^"]+) Forests"', r'"Florestas de \1"', text)
    text = re.sub(r'"([^"]+) Forest"', r'"Floresta de \1"', text)
    text = re.sub(r'"([^"]+) Deserts"', r'"Desertos de \1"', text)
    text = re.sub(r'"([^"]+) Desert"', r'"Deserto de \1"', text)
    text = re.sub(r'"([^"]+) Dungeon"', r'"Masmorra de \1"', text)
    text = text.replace("naviregisterwarp(\"Warer >", "naviregisterwarp(\"Teleporte >")
    path.write_text(text, encoding="utf-8")


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: localize-ptbr.py /path/to/rathena", file=sys.stderr)
        return 2
    rathena = Path(sys.argv[1]).resolve()
    if not (rathena / "conf").is_dir():
        print(f"not a rAthena tree: {rathena}", file=sys.stderr)
        return 1
    install_default_messages(rathena)
    warper = rathena / "npc" / "custom" / "warper.txt"
    if warper.is_file():
        localize_warper(warper)
    print(f"pt-BR locale applied under {rathena}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
