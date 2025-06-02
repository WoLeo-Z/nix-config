# Nushell Config File Documentation
#
# Warning: This file is intended for documentation purposes only and
# is not intended to be used as an actual configuration file as-is.
#
# version = "0.104.0"
#
# A `config.nu` file is used to override default Nushell settings,
# define (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, so
# the user's `config.nu` only needs to override these defaults if
# desired.
#
# This file serves as simple "in-shell" documentation for these
# settings, or you can view a more complete discussion online at:
# https://nushell.sh/book/configuration
#
# You can pretty-print and page this file using:
# config nu --doc | nu-highlight | less -R

# $env.config
# -----------
# The $env.config environment variable is a record containing most Nushell
# configuration settings. Keep in mind that, as a record, setting it to a
# new record will remove any keys which aren't in the new record. Nushell
# will then automatically merge in the internal defaults for missing keys.
#
# The same holds true for keys in the $env.config which are also records
# or lists.
#
# For this reason, settings are typically changed by updating the value of
# a particular key. Merging a new config record is also possible. See the
# Configuration chapter of the book for more information.

# ----------------------
# Miscellaneous Settings
# ----------------------

# show_banner (bool): Enable or disable the welcome banner at startup
$env.config.show_banner = false
