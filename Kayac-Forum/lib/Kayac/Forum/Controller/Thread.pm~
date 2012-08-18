package Kayac::Forum::Controller::Thread;
use Moose;
use namespace::autoclean;
use Package::Alias Session => 'Kayac::Forum::Utils::Session';

BEGIN { 
    extends 'Catalyst::Controller'; 
    extends 'Catalyst::Controller::FormBuilder';
    $Package::Alias::BRAVE = 1
}

=head1 NAME

Kayac::Forum::Controller::Thread - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path {
    my ( $self, $c, $topic_id ) = @_;

    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');
    
    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;

    if ($topic_id) {
        # get infor of topic
        my $topic = $c->model('ForumDB::Topic')->find({ topic_id => $topic_id });
        $c->stash->{topic} = $topic;

        $c->response->redirect('/topic') if (!$topic);

        # list all thread of topic here
        my @threads = $topic->threads->search(
            { },
            { order_by => 'thread_created_date DESC' },
        )->all;
        $c->stash->{threads} = [@threads];
    }
    else {
        # get all topic newest 
    }


    
}

sub edit :Local Form {
    my ( $self, $c, $topic_id, $thread_id ) = @_;
    my $form = $self->formbuilder;
    my ($thread, $post);     
    
    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;
    
    # check role for edit topic
    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');

    # get infor of topic
    my $topic = $c->model('ForumDB::Topic')->find( {topic_id => $topic_id} );
    $c->stash->{topic} = $topic;
   
    $c->response->redirect('/topic') if (!$topic);

    if ($thread_id) {
        # get topic information
        $thread = $c->model('ForumDB::Thread')->find( {thread_id => $thread_id} );
        if ($thread) {
	    $post = $thread->posts->search( {}, { order_by => 'post_id' } )->first;
	
            # fill form
            #$form->field(name => 'threadtitle', value => $thread->thread_title);
            #$form->field(name => 'active', value => $thread->actived);

            $c->stash->{thread} = $thread;
            $c->stash->{post} = $post;
        }
        else {
            $c->stash->{not_render_form} = 1;
            $c->stash->{message} = "not found thread id $thread_id";
        }    
    }
    
    if ($thread_id) {
	$c->stash->{title} = "編集: " . $thread->thread_title;
    }
    else {
        $c->stash->{title} = "新しいスレッド"; 
    }

    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;

    my $thread_title =  $c->request->param('title');
    my $thread_post = $c->request->param('post_content'); 


    # process thread_title
    if ($thread_title ne '') {
        my $hs = HTML::Strip->new();
        $thread_title = $hs->parse( $thread_title );
        $hs->eof;
    }


    # process post content (html tag)
    if ($thread_post ne '') {
        my $hs = HTML::Strip->new();
        my $clean_text = $hs->parse( $thread_post );
        $hs->eof;

        $thread_post = $clean_text;        
	$thread_post =~ s/\n/<p\/><p>/;
    	$thread_post =~ s{(https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?)}{<a href="$1">$1</a>}gx;
    	$thread_post =~ s{(\S+@\S+\.\S+)}{<a href="mailto:$1">$1</a>}gx;
    }
    
    my $file_uri;
    my $file;
    if ($file = $c->req->upload('file')) { # < 5mb
        if ($file->size < 5 * 1024 * 1024) {
            my $filename = $file->filename;

            # add string unique to file name;
            my $string_rand = new String::Random;
            $filename = $filename . '__' . $string_rand->randpattern("CCCCccccnnnnnn");            

            my $target = $c->config->{upload_abs}."/$filename";
            $file_uri = $c->config->{upload_dir}."/$filename";

            # Make file to local disk
            unless ($file->link_to( $target) || $file->copy_to($target)) {
                 die ("Failed to copy '$filename' to '$target': $!");    
            }
         }
     }

    if ($file_uri) {
	    # add image to content
            $thread_post = $thread_post . "<div class=\"image_post\"><img src=\"$file_uri\" id=\"image_content\"</img></div>";
    }


    if ($thread_title ne '' && $thread_post ne '') {
        if ($thread_id && $thread) {
            # update thread
            $thread->thread_title( $thread_title );
            #$thread->actived( $form->field('active') );
            #$thread->topic_id( $form->field('topic') );
            $thread->insert_or_update;

            $post->post_body( $thread_post );
            $post->insert_or_update;
        } 
        else {
            # create new topic
            $thread = $c->model('ForumDB::Thread')->new(
                {
                    thread_title => $thread_title,
                    actived => 1==1,
                    topic_id => $topic_id,
                    created_by => Session::user($c->session)->user_id,
                } 
            );
            if ($thread) {
                 $thread->insert_or_update;
            }
            
            # create post
            $post = $c->model('ForumDB::Post')->new( 
                {
                    post_thread_id => $thread->thread_id,
                    post_body => $thread_post,
                    post_owner => Session::user($c->session)->user_id,
                } 
            );
            if ($post) {
                $post->insert_or_update;
            }
        }

        # back to list thread of topic
        $c->response->redirect('/thread/' . $topic_id);
    }    
}

sub delete :Local {
    my ($self, $c, $topic_id, $thread_id) = @_;
    
    my $role = Session::role($c->session);
    $c->response->redirect('/admin/login') if (!$role || $role->role_name ne 'administrator');

    my $thread;
    if ($thread_id) {
        # get thread information
        $thread = $c->model('ForumDB::Thread')->find( {thread_id => $thread_id} );
        if ($thread) {
            # can not delete thread if exist post
            my @posts = $thread->posts->all;
            if (@posts > 0) {
                # delete all post
                foreach my $post (@posts) {
                    $post->delete;
                }
            }
            # delete thread from database
            $thread->delete;
                
            # back to list topic
            $c->response->redirect('/thread/' . $topic_id);
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
