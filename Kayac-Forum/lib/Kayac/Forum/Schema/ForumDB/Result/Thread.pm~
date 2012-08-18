use utf8;
use DateTime;
use POSIX;
package Kayac::Forum::Schema::ForumDB::Result::Thread;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::Thread

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<thread>

=cut

__PACKAGE__->table("thread");

=head1 ACCESSORS

=head2 thread_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 topic_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 thread_title

  data_type: 'text'
  is_nullable: 0

=head2 thread_created_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 created_by

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 actived

  data_type: 'bit'
  is_nullable: 1
  size: 1

=head2 closed

  data_type: 'bit'
  is_nullable: 1
  size: 1

=cut

__PACKAGE__->add_columns(
  "thread_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "topic_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "thread_title",
  { data_type => "text", is_nullable => 0 },
  "thread_created_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "created_by",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "actived",
  { data_type => "bit", is_nullable => 1, size => 1 },
  "closed",
  { data_type => "bit", is_nullable => 1, size => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</thread_id>

=back

=cut

__PACKAGE__->set_primary_key("thread_id");

=head1 RELATIONS

=head2 created_by

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "created_by",
  "Kayac::Forum::Schema::ForumDB::Result::User",
  { user_id => "created_by" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 posts

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Kayac::Forum::Schema::ForumDB::Result::Post",
  { "foreign.post_thread_id" => "self.thread_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 topic

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Topic>

=cut

__PACKAGE__->belongs_to(
  "topic",
  "Kayac::Forum::Schema::ForumDB::Result::Topic",
  { topic_id => "topic_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-13 18:40:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ySAGL7jVs/X+13h/6dhc2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;

sub lastest_post {
    my ($self) = @_;
  
    my $lastest_post = $self->posts->search( 
        undef, 
        { order_by => 'post_created_date DESC' },
    )->first;
    
    return $lastest_post;
}

sub lastest_post_datetime {
    my ($self) = @_;
  
    my $lastest_post = $self->posts->search( 
        undef, 
        { order_by => 'post_created_date DESC' },
    )->first;

    return $lastest_post->post_created_date if ($lastest_post);
    return DateTime::Infinite::Past->new();
}

sub new_thread {
    my ($self) = @_;
    my $lastest_post = $self->posts->search( 
        { }, 
        { order_by => 'post_created_date DESC' },
    )->first;
    
    return 0 unless ($lastest_post);

    my $dt_yesterday = DateTime->now;    
    $dt_yesterday->subtract( days => 1 );

    return 1 if ($dt_yesterday < $lastest_post->post_created_date);
    return 0;
}

sub total_post {
    my ($self) = @_;
    return $self->posts->count;
}

sub print_created_date {
    my ($self) = @_;
    #my $dt = DateTime->new($self->thread_created_date);
    
    #my $time = sprintf("%2d/%2d/%4d %2d::%2d", $dt->day, $dt->month, $dt->year, $dt->hour, $dt->minute);
    #my $time_str = strftime "%a %b %e %H:%M:%S %Y", $self->thread_created_date;
    return $self->thread_created_date;
    
}

1;
