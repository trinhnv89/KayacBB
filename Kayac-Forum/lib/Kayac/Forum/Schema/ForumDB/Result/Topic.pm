use utf8;
package Kayac::Forum::Schema::ForumDB::Result::Topic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::Topic

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

=head1 TABLE: C<topic>

=cut

__PACKAGE__->table("topic");

=head1 ACCESSORS

=head2 topic_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 topic_name

  data_type: 'text'
  is_nullable: 0

=head2 topic_description

  data_type: 'text'
  is_nullable: 1

=head2 created_date

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

=cut

__PACKAGE__->add_columns(
  "topic_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "topic_name",
  { data_type => "text", is_nullable => 0 },
  "topic_description",
  { data_type => "text", is_nullable => 1 },
  "created_date",
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
);

=head1 PRIMARY KEY

=over 4

=item * L</topic_id>

=back

=cut

__PACKAGE__->set_primary_key("topic_id");

=head1 RELATIONS

=head2 accesses

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Access>

=cut

__PACKAGE__->has_many(
  "accesses",
  "Kayac::Forum::Schema::ForumDB::Result::Access",
  { "foreign.topic_id" => "self.topic_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 threads

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Thread>

=cut

__PACKAGE__->has_many(
  "threads",
  "Kayac::Forum::Schema::ForumDB::Result::Thread",
  { "foreign.topic_id" => "self.topic_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-13 18:33:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lQK1BkXxmtySvxH2VZYw6A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;

sub total_thread {
    my ($self) = @_;
    return $self->threads->search({ topic_id => $self->topic_id})->count;
}

sub lastest_thread {
    my ($self) = @_;
    return $self->threads->search( 
        { }, 
        { order_by => 'thread_id DESC' }, 
    )->first;
}

1;
