#!/usr/bin/env perl
use Module::Build;
use strict; use warnings;

Module::Build->subclass(
  class => 'IRC::Toolkit::_Builder',
)->new(
  module_name   => 'IRC::Toolkit',
  dist_abstract => 'Extended collection of IRC utility functions',
  dist_author   => 'Jon Portnoy <avenj@cobaltirc.org>',
  license       => 'perl',

  create_readme => 1,
  create_makefile_pl   => 'small',
  recursive_test_files => 1,

  configure_requires => {
    'Module::Build' => '0.38',
  },
  build_requires => {
    'Test::More'    => 0,
  },
  requires => {
    'perl'          => '5.10.1',
    'strictures'    => 1,

    'Carp'          => 0,
    'Exporter'      => 0,
    'Scalar::Util'  => 0,

    'Moo'           => 1,

    'POE::Filter::IRCv3'   => 0,
  },

  meta_merge => {
    resources => {
      repository => 'http://github.com/avenj/poe-filter-ircv3.git',
    },
  },
)->create_build_script;
