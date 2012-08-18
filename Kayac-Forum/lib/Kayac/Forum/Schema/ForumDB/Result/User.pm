use utf8;
package Kayac::Forum::Schema::ForumDB::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 user_email

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 salt

  data_type: 'varchar'
  is_nullable: 0
  size: 4

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 created_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 actived

  data_type: 'bit'
  is_nullable: 1
  size: 1

=head2 avatar

  data_type: 'varchar'
  is_nullable: 1
  size: 260

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "user_email",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "salt",
  { data_type => "varchar", is_nullable => 0, size => 4 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "created_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "actived",
  { data_type => "bit", is_nullable => 1, size => 1 },
  "avatar",
  { data_type => "varchar", is_nullable => 1, size => 260 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_name>

=over 4

=item * L</user_name>

=item * L</user_email>

=back

=cut

__PACKAGE__->add_unique_constraint("user_name", ["user_name", "user_email"]);

=head1 RELATIONS

=head2 posts

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Kayac::Forum::Schema::ForumDB::Result::Post",
  { "foreign.post_owner" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role_users

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::RoleUser>

=cut

__PACKAGE__->has_many(
  "role_users",
  "Kayac::Forum::Schema::ForumDB::Result::RoleUser",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 threads

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Thread>

=cut

__PACKAGE__->has_many(
  "threads",
  "Kayac::Forum::Schema::ForumDB::Result::Thread",
  { "foreign.created_by" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 topics

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Topic>

=cut

__PACKAGE__->has_many(
  "topics",
  "Kayac::Forum::Schema::ForumDB::Result::Topic",
  { "foreign.created_by" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-13 18:40:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5Pa8isHCW2+2ORaKhq0k2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
