# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.has_role?(:admin)
      can :manage, :all
      return
    end

    can :manage, Host
    can :manage, Organization
    can :manage, Certificate
    can :manage, CertificateApplication #, { user_id: user.id }
    can :manage, Renewal
  end
end
