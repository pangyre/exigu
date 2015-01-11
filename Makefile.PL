use inc::Module::Install;
use strict;
use warnings;

name "Exigu";
all_from "exigu.psgi";
# Apparently a no-op, perl_version_from "lib/Wren.pm";

# This is stupid... tools should do it on their own.
use lib "lib";
require "exigu.psgi";
version "Exigu"->VERSION;

cpanfile;

# auto_install;? 

WriteAll;

system "pod2markdown exigu.psgi README.md"
    if $Module::Install::AUTHOR;

exit 0;

__END__
