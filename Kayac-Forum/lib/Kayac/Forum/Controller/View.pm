package Kayac::Forum::Controller::View;
use Moose;
use namespace::autoclean;
use HTML::Strip;
use DateTime;
use String::Random;
use Package::Alias Session => 'Kayac::Forum::Utils::Session';

BEGIN { 
        extends 'Catalyst::Controller';
        extends 'Catalyst::Controller::FormBuilder';
        $Package::Alias::BRAVE = 1;
}

our $THREAD_PER_PAGE = 10;
our $POST_PER_PAGE = 10;

=head1 NAME

Kayac::Forum::Controller::View - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub view :Global {
    my ( $self, $c) = @_;    

    my $topic_id = $c->request->param('topic');
    my $thread_id = $c->request->param('thread');
    my $page = $c->request->param('page');

    # add post

    my $post_content = $c->request->param('post_content');
    if ($post_content) {
        
        # check topic_id and thread_id
        my $topic = $c->model('ForumDB::Topic')->find( {topic_id => $topic_id} );
        my $thread = $c->model('ForumDB::Thread')->find( {thread_id => $thread_id} );
         
        $c->response->redirect('/') unless ($topic && $thread); 
         
        my $user = Session::user($c->session);
        unless ($user) {
            # get guest user
            $user = $c->model('ForumDB::User')->find( { user_name => 'guest' } );
            
            # guest user not found?
            $c->response->redirect('/') unless ($user);
        }
        
        my $file_uri;
        my $file;
	if ($file = $c->req->upload('file')) { # < 5mb
            if ($file->size < 5 * 1024 * 1024) {
                my $filename = $file->filename;

                # add string unique to file name;
                my $string_rand = new String::Random;
                $filename = $filename . '__' . $string_rand->randpattern("CCCCccccnnnnnn");            

                my $target   = $c->config->{upload_abs}."/$filename";
                $file_uri = $c->config->{upload_dir}."/$filename";

                # Make file to local disk
                unless ($file->link_to( $target) || $file->copy_to($target)) {
                    die ("Failed to copy '$filename' to '$target': $!");    
                }
            }
        }

        # process post content
        my $hs = HTML::Strip->new();
        my $clean_text = $hs->parse( $post_content );
        $hs->eof;
        
	$clean_text =~ s/\n/<p\/><p>/;
    	$clean_text =~ s{(https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?)}{<a href="$1">$1</a>}gx;
    	$clean_text =~ s{(\S+@\S+\.\S+)}{<a href="mailto:$1">$1</a>}gx;

	if ($file_uri) {
	    # add image to content
            $clean_text = $clean_text . "<div class=\"image_post\"><img src=\"$file_uri\" id=\"image_content\"</img></div>";
	}

        # add post
        my $post = $c->model('ForumDB::Post')->new( { post_id => 0 } );
        if ($post) {
            $post->post_body( $clean_text );
            $post->post_thread_id( $thread_id );
            $post->post_owner( $user->user_id );
            $post->insert_or_update;
        }
    }
   
    # view site
    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;
   
    if (!$topic_id) {
        # print all topic
        # prepare data
        my $topics = $c->model('ForumDB::Topic');
        $c->stash->{topics} = $topics;
        $c->stash->{mode} = 1;

        # title
        $c->stash->{title} = "Kayac forum";
    }
    else {
        my $topic = $c->model('ForumDB::Topic')->find( {topic_id => $topic_id} );
        $c->response->redirect('/') if (!$topic);
        $c->stash->{topic} = $topic;
        
        if (!$thread_id) {
            # print all thread of topic
            
            my @threads = $topic->threads->search (
                {},
                { order_by => 'thread_created_date' }
            )->all;

            my @tmp_threads = reverse sort {DateTime->compare($a->lastest_post_datetime, $b->lastest_post_datetime);} @threads;

            my @thread_rs;
            if ($page > 0 && ($page - 1) * $THREAD_PER_PAGE < @tmp_threads) {
                for (my $i = $THREAD_PER_PAGE * ($page - 1); $i < $THREAD_PER_PAGE * $page; $i++) {
                    push @thread_rs, $tmp_threads[$i] if ($tmp_threads[$i]);
                }
            }
            else {
                for (my $i = 0; $i < $THREAD_PER_PAGE; $i++) {
                    push @thread_rs, $tmp_threads[$i] if ($tmp_threads[$i]);
                }
                $page = 1;
            }

            $c->stash->{threads} = [@thread_rs];
            $c->stash->{page} = $page;
            $c->stash->{number_page} = (@threads % $THREAD_PER_PAGE) ? int(@threads / $THREAD_PER_PAGE + 1) : int(@threads / $THREAD_PER_PAGE);
            $c->stash->{mode} = 2; # mode for print all thread of topic

            # title
            $c->stash->{title} = $topic->topic_name;
        } 
        else {
            # focus to an thread
            my $thread = $c->model('ForumDB::Thread')->find( {thread_id => $thread_id} );

            # redirect to page error if not exist thread
            $c->response->redirect('/') if (!$thread);
            
            # check $page is invalid
            $page = 1 unless ($page > 0 && ($page - 1) * $POST_PER_PAGE < $thread->posts->count);

            # get post of thread
            my $posts = $c->model('ForumDB::Post')->search( 
                { post_thread_id => $thread_id },
                { 
                    page => $page,
		    rows => $POST_PER_PAGE,
                }
            );

            my $number_post = $thread->posts->count;
 
            # data for present
            $c->stash->{number_page} = ($number_post % $POST_PER_PAGE) ? int($number_post / $POST_PER_PAGE + 1) : int($number_post / $POST_PER_PAGE);

            $c->stash->{post_per_page} = $POST_PER_PAGE;
            $c->stash->{thread} = $thread;
            $c->stash->{posts} = $posts;
            $c->stash->{page} = $page;
            $c->stash->{mode} = 3; # mode for print one thread
            
            # title
            $c->stash->{title} = $thread->thread_title; 
        }
    }
}

sub delete :Global {
    my ( $self, $c) = @_;
    
    my $post_id = $c->request->param('post');
    my $page = $c->request->param('page');

    # check user
    my $user = Session::user($c->session);
    $c->response->redirect('/view') unless ($user); 
    
    my $post = $c->model('ForumDB::Post')->find( { post_id => $post_id } );
    
    # error if user not owner of post
    $c->response->redirect('/view') unless ($post && $post->post_owner->user_id == $user->user_id);
    
    my $thread_id = $post->post_thread_id;
    my $topic_id = $post->post_thread->topic->topic_id;

    $post->delete;
    $c->response->redirect("/view?topic=$topic_id&thread=$thread_id&page=$page");
}

sub edit_thread :Global {
    my ( $self, $c) = @_;

    my $topic_id = $c->request->param('topic');
    my $thread_id = $c->request->param('thread');
    my ($thread, $post);    

    # check role for edit topic
    my $role = Session::role($c->session);
    $c->response->redirect('/') if (!$role);

    # get infor of topic
    my $topic = $c->model('ForumDB::Topic')->find( {topic_id => $topic_id} );
    $c->stash->{topic} = $topic;
   
    $c->response->redirect('/') if (!$topic);

    if ($thread_id) {
        # get topic information
        $thread = $c->model('ForumDB::Thread')->find( {thread_id => $thread_id} );
        if ($thread) {
            if ($thread->created_by->user_id != Session::user($c->session)->user_id) {
                $c->response->redirect('/');
            } 
            
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
    if ($file = $c->req->upload('fileupload')) { # < 5mb
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
        $c->response->redirect('/view?topic=' . $topic_id);
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
