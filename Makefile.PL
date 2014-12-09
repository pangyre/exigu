use inc::Module::Install;
use strict;
use warnings;

name "Exigu";
all_from "exigu.psgi";

cpanfile;
# auto_install;? 
WriteAll;

if ( $Module::Install::AUTHOR )
{
    system "pod2markdown exigu.psgi README.md";
}

# install_script glob("script/*.pl");

exit 0;

__END__
