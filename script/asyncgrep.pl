#!perl

use strict;
use warnings;
use File::Basename;
use IPC::Run qw(run);
use JSON::PP;

my $script = __FILE__;
$script =~ s!\\!/!g;
my $vimremote = dirname($script).'/vimremote';
if ($script =~ /^\/[^\/]/) {
    $vimremote = "/c/$vimremote";
}

my $server = shift;
my $pattern = shift || '.';
my $filemask = shift || '**/*';

$pattern = qr/$pattern/i;

my $json = JSON::PP->new->ascii->allow_singlequote;
for (glob($filemask)) {
  my $file = $_;
  my $lnum = 1;
  open my $fh, '<', $file or die $!;
  for (<$fh>) {
    my $text = $_;
    $text =~ s/(\r\n|\n|\r)$//g;
    if ($text =~ $pattern) {
      my $pos = length($`)+1;
      $text = '' if $text =~ /\p{IsCntrl}/;
      my $json = $json->encode({
        lnum => $lnum, bufnr => 1, col => $pos, valid => 1,
        nr => 0, type => '', pattern => '', text => $text,
      });
      $json =~ s!\\"!\\x22!g;
      my @cmd = ($vimremote,
        '--servername', $server,
        '--remote-expr', "asyncgrep#add('$file',$json)");
      run \@cmd, '>', $^O eq 'MSWin32' ? 'NUL' : '/dev/null' or die $json;
    }
    $lnum++;
  }
  close $fh;
}
