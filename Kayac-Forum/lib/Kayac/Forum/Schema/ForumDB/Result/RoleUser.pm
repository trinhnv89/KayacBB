use utf8;
package Kayac::Forum::Schema::ForumDB::Result::RoleUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::RoleUser

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

=head1 TABLE: C<role_user>

=cut

__PACKAGE__->table("role_user");

=head1 ACCESSORS

=head2 role_user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role_user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "role_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_user_id>

=back

=cut

__PACKAGE__->set_primary_key("role_user_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Kayac::Forum::Schema::ForumDB::Result::Role",
  { role_id => "role_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Kayac::Forum::Schema::ForumDB::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-26 23:33:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IpYaXka9FHbZyuI/7e62Bw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
