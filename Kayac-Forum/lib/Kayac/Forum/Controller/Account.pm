package Kayac::Forum::Controller::Account;
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

Kayac::Forum::Controller::Account - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}


sub register :Global Form {
    my ( $self, $c ) = @_;

    $c->response->redirect('/') if (Session::logined($c->session)); 

    my $user_name = $c->request->param('name');
    my $email = $c->request->param('email');
    my $pass1 = $c->request->param('pass1');
    my $pass2 = $c->request->param('pass2');    

    if ($user_name && $email && $pass1 && $pass2) {
         # check username
         my $user;
         $user = $c->model('ForumDB::User')->find({user_name => $user_name});
         
         if ($user) {
              $c->stash->{message} = "$user_name is not available";
         }
         else {
              # create new user
              $user = $c->model('ForumDB::User')->new({ user_id => 0 });
  
              # hash password
              my $string_rand = new String::Random;
              $user->salt( $string_rand->randpattern("C!cn") );
              $user->user_name( $user_name );
              $user->user_email( $email );
              $user->password( $pass1 );
              $user->password( sha1_hex($user->salt . $user->password) );
              $user->actived( 1==1 );
              #$user->created_date (DateTime->now(time_zone=>'local'));
 
              # save to database
              $user->insert_or_update; 

              my $new_user = $c->model('ForumDB::User')->find({user_name => $user_name});              
 
              if (!$new_user) {
                   # redirect to error page
              }              

              # add role of user
              my $role;
              $role = $c->model('ForumDB::Role')->find({  role_name => 'registered' });
              if ($role) {
                   my $role_user;
                   $role_user = $c->model('ForumDB::RoleUser')->new({ role_user_id => 0 });
                   $role_user->role_id( $role->role_id );
                   $role_user->user_id( $new_user->user_id );
                   $role_user->insert_or_update;
              }

              $c->stash->{message} = '新規ユーザーが成功し作成します。';
              $c->go('register_successful', []);
         }
    }
}

sub register_successful :Global :Args(0){
    my ( $self, $c ) = @_;
}


sub login :Global Form {
    my ( $self, $c ) = @_;

    $c->response->redirect('/') if (Session::logined($c->session)); 
    
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

                      Session::login($c->session, $user, $role);

                      # login successful
                      # $c->stash->{message} = 'login successful';
                      $c->response->redirect('/');
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

sub logout :Global :Args(0){
    my ( $self, $c ) = @_;

    if (Session::logined($c->session)) {
        Session::logout($c->session);
    }

    $c->response->redirect('/');
}


=head1 AUTHOR

Trinh,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#__PACKAGE__->meta->make_immutable;

1;


