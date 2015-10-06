package RedHat::Releases;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       list_redhat_releases
               );

our %SPEC;

our $meta = {
    summary => 'RedHat releases',
    fields => {
        version              => {pos=> 0, schema=>'str*' , unique=>1},
        code_name            => {pos=> 1, schema=>'str*' , unique=>1},
        reldate              => {pos=> 2, schema=>'date*'},
        eoldate              => {pos=> 3, schema=>'date*'},

        linux_version        => {pos=> 4, schema=>'str*'},

        mysql_version        => {pos=> 5, schema=>'str*'},
        mariadb_version      => {pos=> 6, schema=>'str*'},
        postgresql_version   => {pos=> 7, schema=>'str*'},
        apache_httpd_version => {pos=> 8, schema=>'str*'},
        nginx_version        => {pos=> 9, schema=>'str*'},

        perl_version         => {pos=>10, schema=>'str*'},
        python_version       => {pos=>11, schema=>'str*'},
        php_version          => {pos=>12, schema=>'str*'},
        ruby_version         => {pos=>13, schema=>'str*'},
        bash_version         => {pos=>14, schema=>'str*'},
    },
    pk => 'version',
};

our $data = do {
    no warnings 'void';
    [];
# CODE: { require JSON; require File::Slurper; my $json = JSON->new; my $rels = $json->decode(File::Slurper::read_binary("../gudangdata-distrowatch/table/redhat_release/data.json")); my $data = []; for my $r (@$rels) { my ($ver, $code) = $r->{release_name} =~ /(\d\S*) (.+)/; if (!$code) { $ver = $r->{release_name} } push @$data, {version=>$ver, code_name=>$code, reldate=>$r->{release_date}, eoldate=>($r->{eol_date} =~ /\xa0/ ? undef : $r->{eol_date}), linux_version=>$r->{linux_version}, mysql_version=>$r->{mysql_version}, mariadb_version=>$r->{mariadb_version}, postgresql_version=>$r->{postgresql_version}, apache_httpd_version=>$r->{httpd_version}, nginx_version=>$r->{nginx_version}, perl_version=>$r->{perl_version}, python_version=>$r->{python_version}, php_version=>$r->{php_version}, ruby_version=>$r->{ruby_version}, bash_version=>$r->{bash_version} } } $data; }
};

my $res = gen_read_table_func(
    name => 'list_redhat_releases',
    table_data => $data,
    table_spec => $meta,
    #langs => ['en_US', 'id_ID'],
);
die "BUG: Can't generate func: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
# ABSTRACT: List RedHat releases

=head1 SYNOPSIS

 use RedHat::Releases qw(list_redhat_release);
 my $res = list_redhat_releases(detail=>1);
 # raw data is in $RedHat::Releases::data;


=head1 DESCRIPTION

This module contains list of RedHat Enterprise Linux releases. Data source is
currently at: L<https://github.com/perlancar/gudangdata-distrowatch>
(table/redhat_release) which in turn is retrieved from
L<http://distrowatch.com>.


=head1 SEE ALSO

L<Debian::Releases>

L<Ubuntu::Releases>

L<LinuxMint::Releases>

L<CentOS::Releases>

=cut
