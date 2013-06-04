module AbilityDsl
  class UserContext

    attr_reader :user,
                :user_groups,
                :groups_group_full,
                :groups_group_read,
                :groups_layer_full,
                :groups_layer_read,
                :layers_read,
                :layers_full,
                :admin

    def initialize(user)
      @user = user
      init_groups
    end

    def all_permissions
      permissions = user.roles.collect(&:permissions).flatten.uniq
      Role::PermissionImplications.each do |given, implicated|
        if permissions.include?(given) && !permissions.include?(implicated)
          permissions << implicated
        end
      end
      permissions
    end

    def layer_ids(*groups)
      groups.flatten.collect(&:layer_group_id).uniq
    end

    def events_with_permission(permission)
      @events_with_permission ||= {}
      @events_with_permission[permission] ||= find_events_with_permission(permission)
    end

    private

    def init_groups
      @admin = user.groups_with_permission(:admin).present?

      @groups_group_full = user.groups_with_permission(:group_full).to_a
      @groups_group_read = user.groups_with_permission(:group_read).to_a + @groups_group_full
      @groups_layer_full = user.groups_with_permission(:layer_full).to_a
      @groups_layer_read = user.groups_with_permission(:layer_read).to_a

      @layers_read = layer_ids(@groups_layer_full, @groups_layer_read)
      @layers_full = layer_ids(@groups_layer_full)

      @groups_group_full.collect!(&:id)
      @groups_group_read.collect!(&:id)
      @groups_layer_full.collect!(&:id)
      @groups_layer_read.collect!(&:id)
    end

    def find_events_with_permission(permission)
      @participations ||= user.event_participations.includes(:roles).to_a
      @participations.select {|p| p.roles.any? {|r| r.class.permissions.include?(permission) }}.
                      collect(&:event_id)
    end

  end
end