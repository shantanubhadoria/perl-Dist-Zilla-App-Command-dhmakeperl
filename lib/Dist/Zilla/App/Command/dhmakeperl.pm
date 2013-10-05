use strict;
use warnings;
package Dist::Zilla::App::Command::dhmakeperl;

# PODNAME: Dist::Zilla::App::Command::dhmakeperl
# ABSTRACT: use dh-make-perl to generate .deb archives from your CPAN package
# COPYRIGHT
# VERSION

# Dependencies
use Dist::Zilla::App -command;
use autodie qw(:all);

=method abstract

=cut

sub abstract { 'build debian package using dh-make-perl from your dzil package.
    look for the deb file in ./debuild folder after running dzil dhmakeperl' }

=method opt_spec

=cut

sub opt_spec{}

=method validate_args

=cut

sub validate_args {
    my ($self, $opt, $args) = @_;
    die 'no args expected' if @$args;
}

=method execute

=cut

sub execute {
    my ($self, $opt, $args) = @_;

    system('rm -rf debuild');
    mkdir('debuild');
    $self->zilla->build_in('debuild/source');
    system('dh-make-perl make --vcs none --build debuild/source');
}
1;

__END__

=begin wikidoc

= NOTES

* You must have dh-make-perl installed on your system to use this command. use
sudo apt-get install dh-make-perl to install it on debian and ubuntu

=end wikidoc

=cut
