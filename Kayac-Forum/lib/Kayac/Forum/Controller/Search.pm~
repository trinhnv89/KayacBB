package Kayac::Forum::Controller::Search;
use Moose;
use namespace::autoclean;
use Package::Alias Session => 'Kayac::Forum::Utils::Session';


BEGIN { 
	extends 'Catalyst::Controller'; 
	extends 'Catalyst::Controller::FormBuilder';
	$Package::Alias::BRAVE = 1; 
}

=head1 NAME

Kayac::Forum::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub search :Global {
    my ( $self, $c ) = @_;
    
    my $query = $c->request->param('query');
 
    unless ($query) {
         $c->res->redirect('/');
    }
    
    $c->stash->{username} = Session::user($c->session) ? Session::user($c->session)->user_name : undef;
    $c->stash->{role} = Session::role($c->session) ? Session::role($c->session)->role_name : undef;

    $c->stash->{'query'} = $query;
  
    my @result;
    my @topics = $c->model('ForumDB::Topic')->search (
        { topic_name => { -like => '%'.$query.'%' } },
    )->all;
    
    if (@topics > 0) {
        $c->stash->{debug_topic1} = "topic1 > 0";
     
        foreach my $topic (@topics) {
            my $content;
            if ($topic->topic_name =~ m/(\w{0,50}$query\w{0,50})/) {
                $content = $1;
            }

            my $title = "<a href=\"/view?topic=" . $topic->topic_id . "\">" . $topic->topic_name . "</a>";
            my %element;
            $element{'title'} = $title;
            $element{'content'} = $content;
            push @result, \%element;
        }
    }

    @topics = $c->model('ForumDB::Topic')->search (
        { topic_description => { -like => '%'.$query.'%' } },
    )->all;
    
    if (@topics > 0) {
        $c->stash->{debug_topic2} = "topic2 > 0";
        foreach my $topic (@topics) {
            my $content;
            if ($topic->topic_name =~ m/(\w{0,50}$query\w{0,50})/) {
                $content = $1;
            }

            my $title = "<a href=\"/view?topic=" . $topic->topic_id . "\">" . $topic->topic_name . "</a>";
            my %element;
            $element{'title'} = $title;
            $element{'content'} = $content;
            push @result, \%element;
        }
    }


    # search thread
    my @threads = $c->model('ForumDB::Thread')->search (
        { thread_title => { -like => '%'.$query.'%' } },
    )->all;

    if (@threads > 0) {
        $c->stash->{debug_thread} = "thread > 0";
        foreach my $thread (@threads) {
            my $content;
            if ($thread->thread_title =~ m/(\w{0,50}$query\w{0,50})/) {
                $content = $1;
            }

            my $title = "<a href=\"/view?topic=" . $thread->topic->topic_id . "&thread=" . $thread->thread_id . "\">" . $thread->thread_title . "</a>";
            my %element;
            $element{'title'} = $title;
            $element{'content'} = $content;
            push @result, \%element;
        }
    }

    # search in post

    my @posts = $c->model('ForumDB::Post')->search (
        { post_body => { -like => '%'.$query.'%' } },
    )->all;

    if (@posts > 0) {
        $c->stash->{debug_post} = "post > 0";
        foreach my $post (@posts) {
            my $content;
            if ($post->post_body =~ m/(\w{0,50}$query\w{0,50})/) {
                $content = $1;
            }

            my $title = "<a href=\"/view?topic=" . $post->post_thread->topic->topic_id . "&thread=" . $post->post_thread->thread_id . "\">" . $post->post_thread->thread_title . "</a>";
            my %element;
            $element{'title'} = $title;
            $element{'content'} = $content;
            push @result, \%element;
        }
    }
     
    $c->stash->{sum} = @result;
    $c->stash->{results} = [@result];
}


=head1 AUTHOR

Trinh,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#__PACKAGE__->meta->make_immutable;

1;
