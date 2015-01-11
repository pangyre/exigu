# Meta.
# Does not work this way -> requires "5.16.2";
requires "strictures";

# Code correctness and utilities.
requires "Encode";
# requires "Unicode::Normalize"...
requires "Path::Tiny";

# Building tools.
requires "Moo";
#requires "MooX::late";
#requires "MooX::HandlesVia";

# Web layer, application harness.
requires "Plack" => "1";
# requires "Plack::Builder"; # Probably...
# requires "Plack::Middleware::Session";
# requires "Plack::Middleware::Headers";

# Controller works.
requires "Router::R3";
requires "URI";
requires "HTML::Entities";
requires "HTTP::Status";
# requires "HTTP::Tiny"; ???

# View oriented.
requires "JSON";

# Model oriented.
requires "DBI";
requires "DBD::SQLite";
requires "DBIx::Class";
requires "SQL::Translator" => "0.11018";

# requires Data::Dump...
# Not yet? At all? requires "Type::Tiny" => "0.038";

# requires "Data::Dump "dump"";
on build => sub {
    requires "Module::Install::CPANfile";
    requires "Module::CPANfile::Result";
      # requires "Module::Install::CPANfile";
};

on test => sub {
    requires "Test::More" => 1;
    requires "Test::Fatal" => "0.01";
    requires "Pod::Coverage::Moose" => "0.05";
    requires "Time::HiRes" => "1.9726";
    requires "Plack::Test";
};
