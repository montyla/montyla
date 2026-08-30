// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// Gold Times compile-time defaults. PACKETVER is also set by ./configure.

#ifndef CONFIG_CUSTOM_DEFINES_PRE_HPP
#define CONFIG_CUSTOM_DEFINES_PRE_HPP

#ifndef PACKETVER
#define PACKETVER 20180620
#endif

// Brazilian Portuguese (@langtype por). The English slot is also filled
// with the official PT-BR pack by scripts/apply-overlay.sh, so the default
// language for new accounts is Portuguese without extra client setup.
#ifndef LANG_ENABLE
#define LANG_ENABLE 0x80
#endif

#endif /* CONFIG_CUSTOM_DEFINES_PRE_HPP */
