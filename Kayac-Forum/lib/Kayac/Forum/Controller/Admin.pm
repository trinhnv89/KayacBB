package Kayac::Forum::Controller::Admin;
use Moose;
use namespace::autoclean;
use String::Random;
use Digest::SHA1 qw(sha1_hex);
use DateTime;
use Package::Alias Session => 'Kayac::Forum::Utils::Session';

BEGIN { 
    extends 'Catalyst::Controller'; 
    extends 'Catalyst::Controller::FormBuilder';
    $Package::Alias::BRAVE = 1
}

=head1 NAME

Kayac::Forum::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # if not admin go to page login
    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');

    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;

    $c->response->redirect('/topic');
}

sub login :Local {
    my ( $self, $c ) = @_;

    $c->response->redirect('/admin') if (Session::role($c->session) && Session::role($c->session)->role_name eq 'administrator'); 
    
    my $user_name = $c->request->param('username');
    my $password = $c->request->param('password');    
    
    if ($user_name && $password) {
        # validate information
         my $user;
         $user = $c->model('ForumDB::User')->find({ user_name => $user_name });
         if ($user) {
              # check password
              my $password = sha1_hex($user->salt . $password);
              if ($password eq $user->password) {
                  
                  # get role of user
                  my $role_user;
                  $role_user = $c->model('ForumDB::RoleUser')->find({  user_id => $user->user_id });
                  if ($role_user) {
                      my $role;
                      $role = $c->model('ForumDB::Role')->find({  role_id => $role_user->role_id });
                      if ($role->role_name eq 'administrator') {
                          Session::login($c->session, $user, $role);
                          # login successful
                          # $c->stash->{message} = 'login successful';
                          $c->response->redirect('/admin/');
                      }
                  }                 
              }
              else {
                   $c->stash->{message} = 'パスワードが一致しません';
              } 
         }
         else {
              $c->stash->{message} = 'ユーザー名が無効';
         }
    }
}

=head1 AUTHOR

Trinh,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#__PACKAGE__->meta->make_immutable;

1;
