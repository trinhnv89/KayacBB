package Kayac::Forum::Utils::Session;
use Moose;
use namespace::autoclean;

BEGIN { 
    extends 'Catalyst::Controller'; 
}

#
# this module is ultility for session
# all sub rountine have first agrument is $c->session (session of web)
#

sub user {
    my $session = $_[0];
    my $user = $_[1];

    if ($user) {
        $session->{user} = $user;
    }
    else {
        return $session->{user};
    }
}


sub role {
    my $session = $_[0];
    my $role = $_[1];

    if ($role) {
        $session->{role} = $role;
    }
    else {
        return $session->{role};
    }
}

sub login {
    my $session = $_[0];
    my $user = $_[1];
    my $role = $_[2];

    $session->{user} = $user;
    $session->{role} = $role;
    $session->{logined} = 1;
}

sub logout {
    my $session = $_[0];
    
    $session->{user} = undef;
    $session->{role} = undef;
    $session->{logined} = 0;
}

sub logined {
    my $session = $_[0];

    return 1 if ($session->{logined} == 1);
    return 0;
}

sub back_url {
    my $session = $_[0];
    my $url = $_[1];

    if ($url) {
        $session->{back_url} = $url;
    }
    else {
        return $session->{back_url};
    }
}

1;
