package Kayac::Forum::Controller::Topic;
use Moose;
use namespace::autoclean;
use DateTime;
use HTML::Strip;
use Package::Alias Session => 'Kayac::Forum::Utils::Session';

BEGIN { 
    extends 'Catalyst::Controller'; 
    extends 'Catalyst::Controller::FormBuilder';
    $Package::Alias::BRAVE = 1
}

=head1 NAME

Kayac::Forum::Controller::Topic - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');
    
    # list all topic here
    my $topics = $c->model('ForumDB::Topic');
    $c->stash->{topics} = $topics;

    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;
}

sub edit :Local Form {
    my ( $self, $c, $topic_id ) = @_;
    my $form = $self->formbuilder;
    my $topic;    

    # check role for edit topic
    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');

    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;    

    if ($topic_id) {
        # get topic information
        $topic = $c->model('ForumDB::Topic')->find( {topic_id => $topic_id} );
        if ($topic) {
            # fill form
            $form->field(name => 'topicname', value => $topic->topic_name);
            $form->field(name => 'description', value => $topic->topic_description);
            #$form->field(name => 'active', value => $topic->actived);
        }
        else {
            $c->stash->{not_render_form} = 1;
            $c->stash->{message} = "topic_id見つかりませんでした $topic_id";
        }    
    }
    
    $c->stash->{title} = $topic_id ? "編集: " . $topic->topic_name : "新しいトピック";

    my ($topic_name, $topic_des) = ($form->field('topicname'), $form->field('description'));

    my $hs = HTML::Strip->new();
    $topic_name = $hs->parse( $topic_name );
    $topic_des = $hs->parse( $topic_des );
    $hs->eof;    

    if ($form->submitted && $form->validate) {
        if ($topic_id && $topic) {
            # update topic
            $topic->topic_name( $topic_name );
            $topic->topic_description( $topic_des );
            #$topic->actived( $form->field('active') );
            $topic->insert_or_update;
        } 
        else {
            # create new topic
            $topic = $c->model('ForumDB::Topic')->new( {topic_id => 0} );
            if ($topic) {
                 $topic->topic_name( $topic_name );
                 #$topic->actived( $form->field('active') );
                 $topic->created_by( Session::user($c->session)->user_id );
                 $topic->topic_description( $topic_des );
                 $topic->insert_or_update;
            }
        }

        # back to list topic
        $c->response->redirect('/topic');
    }    
}

sub delete :Local :Args(1) {
    my ($self, $c, $topic_id) = @_;
    
    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');

    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;

    my $topic;
    if ($topic_id) {
        # get topic information
        $topic = $c->model('ForumDB::Topic')->find( {topic_id => $topic_id} );
        if ($topic) {
            # can not delete topic if exist thread
            my $threads = $c->model('ForumDB::Thread')->find( {topic_id => $topic_id} );
            if ($threads) {
                $c->stash->{message} = 'スレッドが存在するので、トピックを削除することはできません。前にトピックのすべてのスレッドを削除してください。'
            }
            else {
                # delete topic from database
                $topic->delete;
                
                # back to list topic
                $c->response->redirect('/topic');
            }
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
