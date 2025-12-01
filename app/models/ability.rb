# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == 'admin'
      can :manage, :all
    elsif user.role == 'teacher'
      can :manage, Quiz, user_id: user.id
      can :read, Quiz
      can :create, Quiz
    elsif user.role == 'user'
      can :read, Quiz
      can :create, QuizAttempt
      can :read, QuizAttempt, user_id: user.id
    else
      can :read, Quiz
    end
  end
end
