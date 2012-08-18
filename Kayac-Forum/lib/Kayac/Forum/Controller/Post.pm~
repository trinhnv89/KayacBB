package Kayac::Forum::Controller::Post;
use Moose;
use namespace::autoclean;
use DateTime;
use Package::Alias Session => 'Kayac::Forum::Utils::Session';

BEGIN { 
    extends 'Catalyst::Controller'; 
    extends 'Catalyst::Controller::FormBuilder';
    $Package::Alias::BRAVE = 1
}


=head1 NAME

Kayac::Forum::Controller::Post - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path {
    my ( $self, $c, $thread_id ) = @_;

    my $role = Session::role($c->session);
    $c->response->redirect('/') if (!$role || $role->role_name ne 'administrator');
    
    # get infor of thread
    my $thread = $c->model('ForumDB::Thread')->find({ thread_id => $thread_id });
    $c->response->redirect('/topic') if (!$thread);

    $c->stash->{thread} = $thread;

    # list all post of thread here
    my $posts = $thread->posts->search({ }, { order_by => 'post_created_date DESC' });
    $c->stash->{posts} = $posts;

    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;
}

sub edit :Local Form {
    my ( $self, $c, $thread_id, $post_id ) = @_;
    my $form = $self->formbuilder;
    my $post;    

    # check role for edit topic
    my $role = Session::role($c->session);
    $c->response->redirect('/') if (!$role || $role->role_name ne 'administrator');

    # get infor of thread
    my $thread = $c->model('ForumDB::Thread')->find( {thread_id => $thread_id} );
    $c->stash->{thread} = $thread;
   
    $c->response->redirect('/topic') if (!$thread);
    

    # fill topic id to hidden field
    $form->field(name => 'thread', value => $thread_id);

    if ($post_id) {

        # get post information
        $post = $c->model('ForumDB::Post')->find( {post_id => $post_id} );

        if ($thread) {
            # fill form
            $form->field(name => 'postbody', value => $post->post_body);
        }
        else {
            $c->stash->{not_render_form} = 1;
            $c->stash->{message} = "not found post id $post_id";
        }    
    }
    
    if ($form->submitted && $form->validate) {
        if ($post_id && $post) {
            # update post
            $post->post_body( $form->field('postbody') );
            $post->post_last_modified(DateTime->now(time_zone=>'local'));
            $post->insert_or_update;
        } 
        else {
            # create new post
            $post = $c->model('ForumDB::Post')->new( {post_id => 0} );
            if ($post) {
                 $post->post_body( $form->field('postbody') );
                 $post->post_thread_id( $form->field('thread') );
                 $post->post_owner( Session::user($c->session)->user_id );
                 $post->insert_or_update;
            }
        }

        # back to list thread of topic
        $c->response->redirect('/post/' . $thread_id);
    }    
}

sub delete :Local {
    my ($self, $c, $thread_id, $post_id) = @_;
    
    my $role = Session::role($c->session);
    $c->response->redirect('/') if (!$role || $role->role_name ne 'administrator');

    my $post;
    if ($post_id) {
        # get post information
        $post = $c->model('ForumDB::Post')->find( {post_id => $post_id} );
        if ($post) {
            # delete thread from database
            $post->delete;
                
            # back to list topic
            $c->response->redirect('/post/' . $thread_id);
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
