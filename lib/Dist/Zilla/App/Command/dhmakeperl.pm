use strict;
use warnings;
package Dist::Zilla::App::Command::dhmakeperl;

# PODNAME: Dist::Zilla::App::Command::dhmakeperl
# ABSTRACT: use dh-make-perl to generate .deb archives from your CPAN package
# COPYRIGHT
# VERSION

# Dependencies
use DhMakePerl;
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
    system('dh-make-perl make --vcs none --build debuild/source --version ' .
        $self->zilla->version);
}
1;

__END__

=begin wikidoc

= DESCRIPTION

This is a extension for the [Dist::Zilla] App that adds a command dhmakeperl to your dzil package for compiling your perl modules into .deb packages. 

Before you install this package make sure that dh-make-perl is installed in your debian/ubuntu system. There are some additional app requirements that you might want to install for dh-make-perl to avoid annoying warnings from dh-make-perl.
    
    sudo apt-get install dh-make-perl
    sudo apt-get install apt-file
    sudo apt-file update

To make sure that your changelog and debian control file is included use plugins [Dist::Zilla::Plugin::Control::Debian] and [Dist::Zilla::Plugin::ChangelogFromGit::Debian] in your dist.ini

= SYNOPSIS

Once the package is installed and you have setup the prereqs, you can run the following command inside your package folder:
    
    dzil dhmakeperl

Once this is done your package will be tested and deb file will be generated in the debuild folder for you.

= NOTES

* [http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=683533] If you have
accidentally upgraded Makemaker you may apply this patch to fix the
perllocal.pod error.
    --- ./Debian/Debhelper/Buildsystem/makefile.pm  2012-05-19 17:26:26.000000000 +0200
    +++ ./Debian/Debhelper/Buildsystem/makefile.pm.new      2012-08-01 15:53:41.000000000 +0200
    @@ -100,9 +100,9 @@
    
     sub install {
            my $this=shift;
            my $destdir=shift;
    -       $this->make_first_existing_target(['install'],
    +       $this->make_first_existing_target(['pure_install', 'install'],
                    "DESTDIR=$destdir",
                    "AM_UPDATE_INFO_DIR=no", @_);
     }
* The .deb archive is created using code in your current repository. It does not
use cpan2deb to pull CPAN code to create the .deb archive.
* You must have dh-make-perl installed on your system to use this command. 
* use sudo apt-get install dh-make-perl to install it on debian and ubuntu.
* The .deb file will be created in the debuild folder, This should be added to
your .gitignore file.

=end wikidoc

=cut
