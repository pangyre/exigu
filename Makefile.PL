use inc::Module::Install;
use strict;
use warnings;
#use Cwd ();
#use Path::Class;

#my $MAKEFILE = Path::Class::File->new( Cwd::realpath($0) );
#my $DIR = $MAKEFILE->dir->stringify;

name "Exigu";
all_from "exigu.psgi";

# requires "parent" => undef;
#install_requires "LWP::Simple" => undef;
#install_requires "Archive::Zip" => undef;

test_requires "Test::More" => undef;
test_requires "Test::Fatal" => undef;
# test_requires "SQL::Translator" => undef;

# build_requires "Path::Class" => undef;

system( 'pod2text exigu.psgi > README' );

# install_script glob("script/*.pl");

auto_install;

WriteAll;

exit 0;